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

class MALoginEmailViewController: MABaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var validationEmailImage: UIImageView!
    @IBOutlet weak var validationConfirmEmail: UIImageView!
    @IBOutlet weak var emailSkyTextField: SkyFloatingLabelTextField!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    @IBOutlet weak var confirmEmailSkyTextField: SkyFloatingLabelTextField!
    var mailIsValid: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        confirmEmailSkyTextField.isEnabled = false
        emailSkyTextField.becomeFirstResponder()
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
                performSegue(withIdentifier: "goToWalet", sender: self)
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
