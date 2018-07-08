//
//  MALoginWithQRViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr
import Alamofire
import ISHPullUp

class MALoginWithQRViewController: MABaseViewController, MARegistrationViewControllerDelegate, MASignUpViewControllerDelegate {
    @IBOutlet weak var qrBodyView: UIView!
    @IBOutlet weak var loginWithQRButton: UIButton!
    @IBOutlet weak var loginWithPinCodeButton: UIButton!
    @IBOutlet weak var loginWithEmailButton: UIButton!
    weak var pullUpController: ISHPullUpViewController!
    
    
    var newIndetity: NewIdentity!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    var pinCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrBodyView.layer.cornerRadius = 9.0
        qrBodyView.layer.shadowColor = UIColor.black.cgColor
        qrBodyView.layer.shadowOffset = CGSize(width: 0, height: 15)
        qrBodyView.layer.shadowOpacity = 0.1
        qrBodyView.layer.shadowRadius = 10.0
        qrBodyView.layer.masksToBounds = false
        //qr button
        loginWithQRButton.layer.cornerRadius = 9.0
        loginWithQRButton.layer.shadowColor = UIColor.black.cgColor
        loginWithQRButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        loginWithQRButton.layer.shadowOpacity = 0.2
        loginWithQRButton.layer.shadowRadius = 10.0
        loginWithQRButton.layer.masksToBounds = false
        //pin code button
        loginWithPinCodeButton.layer.cornerRadius = 9.0
        loginWithPinCodeButton.layer.shadowColor = UIColor.black.cgColor;
        loginWithPinCodeButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        loginWithPinCodeButton.layer.shadowOpacity = 0.2
        loginWithPinCodeButton.layer.shadowRadius = 10.0
        loginWithPinCodeButton.layer.masksToBounds = false
        //email button
        loginWithEmailButton.layer.cornerRadius = 9.0
        loginWithEmailButton.layer.shadowColor = UIColor.black.cgColor;
        loginWithEmailButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        loginWithEmailButton.layer.shadowOpacity = 0.2
        loginWithEmailButton.layer.shadowRadius = 10.0;
        loginWithEmailButton.layer.masksToBounds = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginWithPinCode(_ sender: Any) {
        let popupTransction =  MASignUpViewController(nibName: "MASignUpViewController", bundle: nil)
        popupTransction.delegate = self
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        let popupTransction =  MARegistrationViewController(nibName: "MARegistrationViewController", bundle: nil)
        popupTransction.delegate = self
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    func confirmPinCode(_ controller: MASignUpViewController, pinCode: String) {
        print(pinCode)
        self.pinCode = pinCode
    }
    
    
    @IBAction func loginWithQr(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    //MARK : MARegistrationViewControllerDelegate
    
    func confirmationEmail(_ controller: MARegistrationViewController, confirmationSuccess: Bool, email:String) {
        controller.dismiss(animated: true, completion: nil)
        if confirmationSuccess {
            self.performSegue(withIdentifier: "enterToWallet", sender: nil)
//            let popupTransction =  MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
//            presenter.presentationType = .popup
//            presenter.transitionType = nil
//            presenter.dismissTransitionType = nil
//            presenter.keyboardTranslationType = .compress
//            customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
        }else{
            let popupTransction =  MAFailValidationViewController(nibName: "MAFailValidationViewController", bundle: nil)
            presenter.presentationType = .popup
            presenter.transitionType = nil
            presenter.dismissTransitionType = nil
            presenter.keyboardTranslationType = .compress
            customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
        }
        
    }
    
}
