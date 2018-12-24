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

class MAQRCodeScannerViewController: HSScanViewController , HSScanViewControllerDelegate, AppLockerDelegate {
    func closePinCodeView(typeClose: typeClose) {
    }
    
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
                         self.present(alert, animated: true, completion: nil)
                    }
                } catch _ as NSError {
                    self.scanWorker.stop()
                    let alert: UIAlertController
                    alert = UIAlertController(title: "Error!".localized(), message: "Unknown QR-code!".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.scanWorker.start()
                    }))
                     self.present(alert, animated: true, completion: nil)
                }
            
        }else{
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isStartFromScanner"){
            if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil {
                var appearance = ALAppearance()
                appearance.image = UIImage(named: "lock")!
                appearance.title = "Enter login code".localized()
                appearance.isSensorsEnabled = true
                appearance.cancelIsVissible = false
                appearance.delegate = self
                
                AppLocker.present(with: .validate, and: appearance, withController: self)
            }
        }
        
        self.delegate = self
        self.scanCodeTypes  = [.qr]
        ScanPermission.authorizeCamera { (isAuthorized) in
            if !isAuthorized{
                let alert: UIAlertController
                alert = UIAlertController(title: "Camera permission reuest was denied.".localized(), message: "Press settings to give an access or cancel to close this window.".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "Settings".localized(), style: .default, handler: { (action) in
                    ScanPermission.goToSystemSetting()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
                    alert = UIAlertController(title: "Success".localized(), message: "A record has been validated!".localized(), preferredStyle: .alert)
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
       
        let parameter: Parameters = ["auth_token" : token]
        AuthorizeTokenRequest.authorizeToken(parameter: parameter, completion: { (response, statusCode) in
            if response.success == nil {
                self.scanWorker.stop()
                let alert: UIAlertController
                alert = UIAlertController(title: "Error!".localized(), message: "Unknown QR-code!".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.scanWorker.start()
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert: UIAlertController
                alert = UIAlertController(title: "Success!".localized(), message: "Scanning successfully!".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.scanWorker.start()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }, failure: { (error) in
            AlertController.showError(vc:self)
        })
    }
    
    func getProviderConfirm(address:String){
        self.addressVoucher = address
        VoucherRequest.getProvider(identityAdress: address, completion: { (voucher, statusCode) in
            if statusCode != 403{
                if voucher.allowedOrganizations?.count != 0 && voucher.allowedOrganizations?.count  != nil {
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


extension UIViewController {
    
    func showToast(message : String, messageButton: String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        let toastLabel2 = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastLabel2.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel2.textColor = UIColor.white
        toastLabel2.textAlignment = .center;
        toastLabel2.font = UIFont(name: "GoogleSans-Regular", size: 12.0)
        toastLabel2.minimumScaleFactor = 0.5
        toastLabel2.adjustsFontSizeToFitWidth = true
        toastLabel2.text = messageButton
        toastLabel2.alpha = 1.0
        toastLabel2.layer.cornerRadius = 10;
        toastLabel2.clipsToBounds  =  true
        
        let toastButton = UIButton(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastButton.backgroundColor = .clear
        toastButton.addTarget(self, action: #selector(self.goToSettings(sender:)), for: .touchUpInside)
        
        self.view.addSubview(toastLabel)
        self.view.addSubview(toastButton)
        self.view.addSubview(toastLabel2)
        UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            toastLabel2.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            toastLabel2.removeFromSuperview()
            toastButton.removeFromSuperview()
        })
    }
    
    func showSimpleToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.9, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc func goToSettings( sender :UIButton){
        ScanPermission.goToSystemSetting()
    }
    
}
