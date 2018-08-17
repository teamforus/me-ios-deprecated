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

class MACreateNewIdentityViewController: MABaseViewController {
    @IBOutlet weak var validateIcon: UIImageView!
    @IBOutlet weak var emailSkyFloatingTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var givenNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var familyNameField: SkyFloatingLabelTextField!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func create(_ sender: Any) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!){
            if Validation.validateFieldEmpty(textField: givenNameField) || Validation.validateFieldEmpty(textField: familyNameField) {
                self.performSegue(withIdentifier: "goToPassword", sender: self)
            }
        }
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!){
            validateIcon.isHidden = false
            emailSkyFloatingTextField.errorMessage = nil
        }else{
            validateIcon.isHidden = true
            emailSkyFloatingTextField.errorMessage = "Email is not valid"
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
