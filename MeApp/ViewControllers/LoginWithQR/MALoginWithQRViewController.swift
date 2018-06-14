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

class MALoginWithQRViewController: MABaseViewController, MARegistrationViewControllerDelegate, MASignUpViewControllerDelegate {
   
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
        qrCodeImage.generateQRCode(from: "Aanmelden")
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
