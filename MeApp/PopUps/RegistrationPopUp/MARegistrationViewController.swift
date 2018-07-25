//
//  MARegistrationViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MARegistrationViewControllerDelegate:class {
    func confirmationEmail(_ controller: MARegistrationViewController, confirmationSuccess: Bool, email:String)
}

import UIKit
import AlertBar
import SkyFloatingLabelTextField
import Alamofire
import SwiftMessages

class MARegistrationViewController: MABasePopUpViewController, UITextFieldDelegate {
    @IBOutlet var viewBody: UIView!
    @IBOutlet weak var emailAddressField: SkyFloatingLabelTextField!
    @IBOutlet weak var reapeatEmailField: SkyFloatingLabelTextField!
    weak var delegate: MARegistrationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 8.0
        emailAddressField.delegate = self
        reapeatEmailField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirm(_ sender: Any) {
        if Validation.validateEmailTextFieldWithText(email: emailAddressField.text, textField: emailAddressField) {
            if emailAddressField.text?.count != 0 {
                emailAddressField.errorMessage = nil
                if emailAddressField.text == reapeatEmailField.text{
                    delegate?.confirmationEmail(self, confirmationSuccess: true,email: emailAddressField.text!)
                    reapeatEmailField.errorMessage = nil
                  
                  
                }else{
                    reapeatEmailField.errorMessage = "Repeat Password field is not valid"
                }
            }else{
                emailAddressField.errorMessage = "Email is empty"
            }
        }
    }
    
    
}
