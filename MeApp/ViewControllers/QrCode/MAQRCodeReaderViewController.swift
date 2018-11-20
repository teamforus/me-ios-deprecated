//
//  MAQRCodeReaderViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import QRCodeReader
import Alamofire
import Reachability
import Presentr

class MAQRCodeReaderViewController: MABaseViewController {
    lazy var reader: QRCodeReader = QRCodeReader()
    var addressVoucher: String!
    let reachablity = Reachability()!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    var voucher: Voucher!
    @IBOutlet weak var previewQR: QRCodeReaderView!{
        didSet {
            previewQR.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard checkScanPermissions(), !reader.isRunning else { return }
        
        reader.didFindCode = { result in
            print("Completion with result: \(result.value) of type \(result.metadataType)")
            if self.reachablity.connection != .none{
                
                // login with QR
            if result.value.range(of:"authToken") != nil {
                 self.reader.startScanning()
                var token = result.value.components(separatedBy: ":")
                self.authorizeToken(token: token[1])
                
                // validate record
            }else if result.value.range(of:"uuids") != nil{
                
                var token = result.value.components(separatedBy: ":")
                self.readValidationToken(code: token[1])
               
                // make transaction
            }else if(result.value.range(of:"vouchers") != nil){
                var token = result.value.components(separatedBy: ":")
                self.getProviderConfirm(address: token[1])
               
            } else {
                let data = result.value.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                    {
                          // login with QR with normal json format
                        if jsonArray["type"] as! String == "auth_token"{
                         self.authorizeToken(token: jsonArray["value"] as! String)
                            
                          // make transaction with normal json format
                        }else  if jsonArray["type"] as! String == "voucher" {
                            self.getProviderConfirm(address: jsonArray["value"] as! String)
                            
                          // validate record with normal json format
                        }else{
                            self.readValidationToken(code: jsonArray["value"] as! String)
                        }
                    } else {
                        AlertController.showWarningWithTitle(title:"Error!".localized(), text: "Unknown QR-code!".localized(), vc: self)
                        self.reader.startScanning()
                        
                    }
                } catch _ as NSError {
                     AlertController.showWarningWithTitle(title:"Error!".localized(), text: "Unknown QR-code!".localized(), vc: self)
                    self.reader.startScanning()
                }
            }
            }else{
                AlertController.showInternetUnable(vc: self)
            }
        }
        
        
        reader.startScanning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
         self.reader.startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.reader.stopScanning()
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera".localized(), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:],
                                                      completionHandler: {
                                                        (success) in
                                                        print(" \(success)")
                            })
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "The scanner is not supported on this device".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func readValidationToken(code:String){
        RecordsRequest.readValidationTokenRecord(token:code, completion: { (response, statusCode) in
            if statusCode == 401{
                self.logOut()
            }
            self.reader.startScanning()
            let alert: UIAlertController
            alert = UIAlertController(title: response.name, message: response.value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Validate".localized(), style: .default, handler: { (action) in
                self.reader.startScanning()
                RecordsRequest.aproveValidationTokenRecord(token: code, completion: { (response, statusCode) in
                    if statusCode == 401{
                        self.logOut()
                    }
                    AlertController.showSuccess(withText: "A record has been validated!".localized(), vc: self)
                    self.reader.startScanning()
                }, failure: { (error) in
                    AlertController.showError(vc:self)
                    self.reader.startScanning()
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                self.reader.startScanning()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }, failure: { (error) in
            self.reader.startScanning()
        })
    }
    
    func authorizeToken(token:String){
        
        let parameter: Parameters = ["auth_token" : token]
        AuthorizeTokenRequest.authorizeToken(parameter: parameter, completion: { (response, statusCode) in
            self.reader.startScanning()
        }, failure: { (error) in
            AlertController.showError(vc:self)
            self.reader.startScanning()
        })
    }
    
    func getProviderConfirm(address:String){
        self.addressVoucher = address
        VoucherRequest.getProvider(identityAdress: address, completion: { (voucher, statusCode) in
            if statusCode != 403{
            if voucher.allowedOrganizations?.count != 0 && voucher.allowedOrganizations?.count  != nil {
                
//            let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
//            popupTransction.voucher = voucher
//            self.presenter.presentationType = .popup
//            self.presenter.transitionType = nil
//            self.presenter.dismissTransitionType = nil
//            self.presenter.keyboardTranslationType = .compress
//            self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
                
                self.voucher = voucher
                if voucher.amount != "0.00"{
                self.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                }else{
                    AlertController.showWarningWithTitle(title:"Error!".localized(), text: "The voucher is empty! No transactions can be done.".localized(), vc: self)
                }
            }else if voucher.product != nil{
                if voucher.product?.price != "0.00"{
                    self.voucher = voucher
                    self.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                }else{
                    AlertController.showWarningWithTitle(title:"Error!".localized(), text: "This product voucher is used!".localized(), vc: self)
                }
               
               
            }else{
                AlertController.showWarning(withText: "Sorry you do not meet the criteria for this voucher".localized(), vc: self)
            }
            }else{
                AlertController.showWarningWithTitle(title:"Error!".localized(), text: "You can't scan this voucher. You are not accepted as a provider for the fund that hands out these vouchers.".localized(), vc: self)
            }
            self.reader.startScanning()
        }) { (error) in
            AlertController.showError(vc:self)
            self.reader.startScanning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVoucherPayment"{
            let detailPaymentVC = segue.destination as! MABaseVoucherPaymentViewController
            (detailPaymentVC.contentViewController as! MAContentVoucherPaymentViewController).voucher = self.voucher
            (detailPaymentVC.contentViewController as! MAContentVoucherPaymentViewController).addressVoucher = self.addressVoucher
            (detailPaymentVC.contentViewController as! MAContentVoucherPaymentViewController).tabController = self.tabBarController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
