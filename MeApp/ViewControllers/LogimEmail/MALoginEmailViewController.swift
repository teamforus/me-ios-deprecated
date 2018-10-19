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
                emailSkyTextField.errorMessage = nil
            }else{
                validationEmailImage.isHidden = true
                emailSkyTextField.errorMessage = "Email is not valid"
            }
        }
    }
    
    @IBAction func loginInApp(_ sender: Any) {
        if emailSkyTextField.text == ""{
            emailSkyTextField.errorMessage = "Email is empty"
        }else if !Validation.validateEmail(emailSkyTextField.text!){
            emailSkyTextField.errorMessage = "Email is not valid"
        }else{
            emailSkyTextField.errorMessage = nil
            if mailIsValid {
                if reachablity.connection != .none{
                    AuthorizationEmailRequest.loginWithEmail(parameters: try! AuthorizationEmail(email: emailSkyTextField.text!,
                                                                                                 source:"app.me_app").toJSON() as! Parameters,
                                                             completion: { (response, statusCode) in
                                                                if response.errors == nil {
                                                                    UserDefaults.standard.setValue(response.accessToken, forKeyPath: "auth_token")
                                                                    self.performSegue(withIdentifier: "goToSuccessMail", sender: self)
                                                                    //
                                                                }else {
                                                                    let error = MessageView.viewFromNib(layout: .tabView)
                                                                    error.configureTheme(.error)
                                                                    error.configureContent(title: "Invalid email", body: "", iconImage: nil, iconText: "Such email not exist!", buttonImage: nil, buttonTitle: "YES") { _ in
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
                
            }else{
                AlertController.showInternetUnable()
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
