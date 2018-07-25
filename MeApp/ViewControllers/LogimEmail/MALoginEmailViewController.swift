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
        emailSkyTextField.text = "test3@example.com"
        confirmEmailSkyTextField.text = "test3@example.com"
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
                        UserDefaults.standard.setValue(response.accessToken, forKeyPath: "access_token")
                        self.performSegue(withIdentifier: "goToWalet", sender: self)
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
