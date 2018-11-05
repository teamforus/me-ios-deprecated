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
import Reachability

class MALoginEmailViewController: MABaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var validationEmailImage: UIImageView!
    @IBOutlet weak var emailSkyTextField: SkyFloatingLabelTextField!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    var mailIsValid: Bool! = true
    let reachablity = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        emailSkyTextField.becomeFirstResponder()
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if textField == emailSkyTextField  {
            if Validation.validateEmail(emailSkyTextField.text!){
                validationEmailImage.isHidden = false
                confirmButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
            }else{
                validationEmailImage.isHidden = true
                confirmButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
            }
        }
    }
    
    @IBAction func loginInApp(_ sender: Any) {
        if emailSkyTextField.text == ""{
            emailSkyTextField.errorMessage = "Email is empty"
        }else if !Validation.validateEmail(emailSkyTextField.text!){
            emailSkyTextField.errorMessage = "E-mailadres is ongeldig"
        }else{
            emailSkyTextField.errorMessage = nil
            if mailIsValid {
                if reachablity.connection != .none{
                    AuthorizationEmailRequest.loginWithEmail(parameters: try! AuthorizationEmail(email: emailSkyTextField.text!,
                                                                                                 source:"app-me_app").toJSON() as! Parameters,
                                                             completion: { (response, statusCode) in
                                                                if response.errors == nil {
                                                                    UserDefaults.standard.setValue(response.accessToken, forKeyPath: "auth_token")
                                                                    self.performSegue(withIdentifier: "goToSuccessMail", sender: self)
                                                                    //
                                                                }else {
                                                                     AlertController.showWarning(withText: "Such email not exist!", vc: self)
                                                                }
                                                                
                    }, failure: { (error) in
                        AlertController.showWarning(withText: NSLocalizedString("Something went wrong, please try again…", comment: ""), vc: self)
                    })
                }
                
            }else{
                AlertController.showInternetUnable(vc: self)
            }
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let succesVC = segue.destination as! MASuccessEmailViewController
        succesVC.email = emailSkyTextField.text
    }
    
}
