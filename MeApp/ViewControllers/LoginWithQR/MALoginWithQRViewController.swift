//
//  MALoginWithQRViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MALoginWithQRViewController: MABaseViewController, MARegistrationViewControllerDelegate {
   
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImage.generateQRCode(from: "Aanmelden")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginWithPinCode(_ sender: Any) {
        let popupTransction =  MASignUpViewController(nibName: "MASignUpViewController", bundle: nil)
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
    
    
    //MARK : MARegistrationViewControllerDelegate
    
    func confirmationEmail(_ controller: MARegistrationViewController, confirmationSuccess: Bool) {
        controller.dismiss(animated: true, completion: nil)
        if confirmationSuccess {
            let popupTransction =  MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
            presenter.presentationType = .popup
            presenter.transitionType = nil
            presenter.dismissTransitionType = nil
            presenter.keyboardTranslationType = .compress
            customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
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
