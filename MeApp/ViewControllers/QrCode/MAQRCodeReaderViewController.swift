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
    let reachablity = Reachability()!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
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
                          // login with QR
                        if jsonArray["type"] as! String == "auth_token"{
                         self.authorizeToken(token: jsonArray["value"] as! String)
                            
                          // make transaction
                        }else  if jsonArray["type"] as! String == "voucher" {
                            self.getProviderConfirm(address: jsonArray["value"] as! String)
                            
                          // validate record
                        }else{
                            self.readValidationToken(code: jsonArray["value"] as! String)
                        }
                    } else {
                        self.reader.startScanning()
                    }
                } catch let error as NSError {
                    print(error)
                    self.reader.startScanning()
                }
            }
            }else{
                AlertController.showInternetUnable()
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
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
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
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
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
            alert.addAction(UIAlertAction(title: "Aprove", style: .default, handler: { (action) in
                self.reader.startScanning()
                RecordsRequest.aproveValidationTokenRecord(token: code, completion: { (response, statusCode) in
                    if statusCode == 401{
                        self.logOut()
                    }
                    self.reader.startScanning()
                }, failure: { (error) in
                    AlertController.showError()
                    self.reader.startScanning()
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
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
            AlertController.showError()
            self.reader.startScanning()
        })
    }
    
    func getProviderConfirm(address:String){
        VoucherRequest.getProvider(identityAdress: address, completion: { (voucher, statusCode) in
            if voucher.allowedOrganizations.count != 0 {
            let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
            popupTransction.voucher = voucher
            self.presenter.presentationType = .popup
            self.presenter.transitionType = nil
            self.presenter.dismissTransitionType = nil
            self.presenter.keyboardTranslationType = .compress
            self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
            }else{
                AlertController.showWarning(withText: "Sorry this voucher is not availebel for you!")
            }
            self.reader.startScanning()
        }) { (error) in
            AlertController.showError()
            self.reader.startScanning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
