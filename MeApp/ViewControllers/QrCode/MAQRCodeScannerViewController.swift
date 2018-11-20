//
//  MAQRCodeScannerViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 11/19/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import Presentr

class MAQRCodeScannerViewController: HSScanViewController , HSScanViewControllerDelegate {
    
    var addressVoucher: String!
    let reachablity = Reachability()!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    var voucher: Voucher!
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        if self.reachablity.connection != .none{
            
            // login with QR
            if scanResult.scanResultString?.range(of:"authToken") != nil {
                self.scanWorker.start()
                var token = scanResult.scanResultString?.components(separatedBy: ":")
                self.authorizeToken(token: token![1])
                
                // validate record
            }else if scanResult.scanResultString?.range(of:"uuids") != nil{
                
                var token = scanResult.scanResultString?.components(separatedBy: ":")
                self.readValidationToken(code: (token?[1])!)
                
                // make transaction
            }else if(scanResult.scanResultString?.range(of:"vouchers") != nil){
                var token = scanResult.scanResultString?.components(separatedBy: ":")
                self.getProviderConfirm(address: (token?[1])!)
                
            } else {
                let data = scanResult.scanResultString?.data(using: .utf8)!
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? Dictionary<String,Any>
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
                       self.scanWorker.stop()
                        let alert: UIAlertController
                        alert = UIAlertController(title: "Error!".localized(), message: "Unknown QR-code!".localized(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.scanWorker.start()
                        }))
                    }
                } catch _ as NSError {
                    self.scanWorker.stop()
                    let alert: UIAlertController
                    alert = UIAlertController(title: "Error!".localized(), message: "Unknown QR-code!".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.scanWorker.start()
                    }))
                }
            }
        }else{
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.scanCodeTypes  = [.qr]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func readValidationToken(code:String){
        self.scanWorker.stop()
        RecordsRequest.readValidationTokenRecord(token:code, completion: { (response, statusCode) in
            if statusCode == 401{
                self.logOut()
            }
            let alert: UIAlertController
            alert = UIAlertController(title: response.name, message: response.value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Validate".localized(), style: .default, handler: { (action) in
                RecordsRequest.aproveValidationTokenRecord(token: code, completion: { (response, statusCode) in
                    if statusCode == 401{
                        self.logOut()
                    }
                    self.scanWorker.stop()
                    let alert: UIAlertController
                    alert = UIAlertController(title: "Success".localized(), message:  "A record has been validated!".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.scanWorker.start()
                    }))
                }, failure: { (error) in
                    self.scanWorker.stop()
                    let alert: UIAlertController
                    alert = UIAlertController(title: "Error!".localized(), message: "Unknown QR-code!".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.scanWorker.start()
                    }))
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                self.scanWorker.start()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }, failure: { (error) in
            self.scanWorker.start()
        })
    }
    
    func authorizeToken(token:String){
        let alert: UIAlertController
        alert = UIAlertController(title: "Scanner", message: "Scanning successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.scanWorker.start()
        }))
        self.present(alert, animated: true, completion: nil)
        let parameter: Parameters = ["auth_token" : token]
        AuthorizeTokenRequest.authorizeToken(parameter: parameter, completion: { (response, statusCode) in
        }, failure: { (error) in
            AlertController.showError(vc:self)
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
            self.scanWorker.start()
        }) { (error) in
            AlertController.showError(vc:self)
            self.scanWorker.start()
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
    
    public func logOut(){
        //        self.parent?.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set("", forKey: ALConstants.kPincode)
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
        let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
        navigationController.viewControllers = [firstPageVC]
        self.present(navigationController, animated: true, completion: nil)
    }
}