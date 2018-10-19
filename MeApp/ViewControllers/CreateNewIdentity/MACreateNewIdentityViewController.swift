//
//  MACreateNewIdentityViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftMessages
import CoreData
import IQKeyboardManagerSwift
import Reachability

class MACreateNewIdentityViewController: MABaseViewController {
    @IBOutlet weak var validateIcon: UIImageView!
    @IBOutlet weak var emailSkyFloatingTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmEmailField: SkyFloatingLabelTextField!
    @IBOutlet weak var givenNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var familyNameField: SkyFloatingLabelTextField!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachablity = Reachability()!
    @IBOutlet weak var registerUIButton: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        confirmEmailField.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func create(_ sender: Any) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!) && confirmEmailField.text == emailSkyFloatingTextField.text{
            if Validation.validateFieldEmpty(textField: givenNameField) || Validation.validateFieldEmpty(textField: familyNameField) {
                if reachablity.connection != .none{
                    self.performSegue(withIdentifier: "goToPassword", sender: self)
                }else {
                    AlertController.showInternetUnable()
                }
            }
        }
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if textField == emailSkyFloatingTextField{
            if Validation.validateEmail(emailSkyFloatingTextField.text!){
                validateIcon.isHidden = false
//                emailSkyFloatingTextField.errorMessage = nil
                confirmEmailField.isEnabled = true
            }else{
                validateIcon.isHidden = true
//                emailSkyFloatingTextField.errorMessage = "Email is not valid"
                confirmEmailField.isEnabled = false
            }
        }else{
            if confirmEmailField.text == emailSkyFloatingTextField.text{
                validateIcon.isHidden = false
//                confirmEmailField.errorMessage = nil
                registerUIButton.isEnabled = true
                registerUIButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
            }else{
                validateIcon.isHidden = true
//                confirmEmailField.errorMessage = "Confirm email is not corect"
                registerUIButton.isEnabled = false
                registerUIButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPassword"{
            let creatPassVC = segue.destination as! MACreatePasswordViewController
            creatPassVC.primaryEmail = emailSkyFloatingTextField.text
            creatPassVC.givenName = givenNameField.text
            creatPassVC.familyName = familyNameField.text
        }
    }
    
    
}
