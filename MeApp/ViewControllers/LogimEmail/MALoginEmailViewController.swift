//
//  MALoginEmailViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
import Alamofire
import SwiftMessages

class MALoginEmailViewController: MABaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var validationEmailImage: UIImageView!
    @IBOutlet weak var validationConfirmEmail: UIImageView!
    @IBOutlet weak var emailSkyTextField: SkyFloatingLabelTextField!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    @IBOutlet weak var confirmEmailSkyTextField: SkyFloatingLabelTextField!
    var mailIsValid: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        confirmEmailSkyTextField.isEnabled = false
        emailSkyTextField.becomeFirstResponder()
//        UserDefaults.standard.setValue("66b962fca6acc70c2dc469450832430d673afd62f37b1a7880de246135deb21011bf87566b0883f745a74a27667bbad8b6401d1f5333193844d5abb02c13c5f3e1f349f2c4bc59f2b77a6178ff3f4de9436c60c35431abd054ff73d3cfefb547b6b1b50a", forKeyPath: "access_token")
//        UserDefaults.standard.setValue("a29d65318b7cff8fdab36fb3bbd30672df80ab1e166e593c99253cd5547d730a830052c9f45c368e8afd287981350c568654bb7f903d7bd7e06b84ab9e88474bb6c67e2d25c1d7c22fea4bb394bda205413ad119f8d640c38b098fee69fa33235abcb399", forKeyPath: "access_token")
//        UserDefaults.standard.synchronize()
//        a29d65318b7cff8fdab36fb3bbd30672df80ab1e166e593c99253cd5547d730a830052c9f45c368e8afd287981350c568654bb7f903d7bd7e06b84ab9e88474bb6c67e2d25c1d7c22fea4bb394bda205413ad119f8d640c38b098fee69fa33235abcb399
        //        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if textField == emailSkyTextField  {
            if Validation.validateEmail(emailSkyTextField.text!){
                validationEmailImage.isHidden = false
                confirmEmailSkyTextField.isEnabled = true
                emailSkyTextField.errorMessage = nil
            }else{
                validationEmailImage.isHidden = true
                confirmEmailSkyTextField.isEnabled = false
                emailSkyTextField.errorMessage = "Email is not valid"
            }
        }else if textField == confirmEmailSkyTextField{
            if confirmEmailSkyTextField.text == emailSkyTextField.text{
                validationConfirmEmail.isHidden = false
                confirmEmailSkyTextField.errorMessage = nil
                mailIsValid = true
            }else{
                validationConfirmEmail.isHidden = true
                mailIsValid = false
                confirmEmailSkyTextField.errorMessage = "Confirmation email is wrong"
            }
        }
    }
    
    @IBAction func loginInApp(_ sender: Any) {
        if emailSkyTextField.text == ""{
            emailSkyTextField.errorMessage = "Email is empty"
        }else if !Validation.validateEmail(emailSkyTextField.text!){
            emailSkyTextField.errorMessage = "Email is not valid"
        }else if emailSkyTextField.text != confirmEmailSkyTextField.text{
            confirmEmailSkyTextField.errorMessage = "Confirmation email is wrong"
        }else{
            emailSkyTextField.errorMessage = nil
            confirmEmailSkyTextField.errorMessage = nil
            if mailIsValid {
                
                AuthorizationEmailRequest.loginWithEmail(parameters: try! AuthorizationEmail(email: emailSkyTextField.text!,
                                                         source:"app.me_app").toJSON() as! Parameters,
                    completion: { (response) in
                    if response.errors == nil {
                        UserDefaults.standard.setValue(response.accessToken, forKeyPath: "auth_token")
                        
                        AuthorizationEmailRequest.authorizeEmailToken(completion: { (response) in
                            self.performSegue(withIdentifier: "goToWalet", sender: self)
                        }, failure: { (error) in
                            
                        })
                    }else {
                        let error = MessageView.viewFromNib(layout: .tabView)
                        error.configureTheme(.error)
                        error.configureContent(title: "Invalid email", body: response.errors?.recordMessage.first, iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                            SwiftMessages.hide()
                        }
                        error.button?.setTitle("OK", for: .normal)
                        
                        SwiftMessages.show( view: error)
                    }
                                                            
                }, failure: { (error) in
                    let error = MessageView.viewFromNib(layout: .tabView)
                    error.configureTheme(.error)
                    error.configureContent(title: "Invalid email", body: "Something go wrong, please try again!", iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                        SwiftMessages.hide()
                    }
                    error.button?.setTitle("OK", for: .normal)
                    
                    SwiftMessages.show( view: error)
                })
            }
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
