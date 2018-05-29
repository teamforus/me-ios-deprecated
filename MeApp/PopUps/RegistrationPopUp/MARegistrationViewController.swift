//
//  MARegistrationViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MARegistrationViewControllerDelegate:class {
    func confirmationEmail(_ controller: MARegistrationViewController, confirmationSuccess: Bool)
}

import UIKit
import AlertBar
import SkyFloatingLabelTextField

class MARegistrationViewController: UIViewController, UITextFieldDelegate {
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
        if emailAddressField.text?.count != 0 {
             emailAddressField.errorMessage = nil
            if emailAddressField.text == reapeatEmailField.text{
                delegate?.confirmationEmail(self, confirmationSuccess: false)
                reapeatEmailField.errorMessage = nil
            }else{
                reapeatEmailField.errorMessage = "Repeat Password field is not valid"
            }
        }else{
           emailAddressField.errorMessage = "Email is empty"
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressField {
            validateEmailField()
        }

        return false
    }
    
    
    func validateEmailField() {
        validateEmailTextFieldWithText(email: emailAddressField.text)
    }
    
    func validateEmailTextFieldWithText(email: String?) {
        guard let email = email else {
            emailAddressField.errorMessage = nil
            return
        }
        
        if email.isEmpty {
            emailAddressField.errorMessage = nil
        } else if !validateEmail(email) {
            emailAddressField.errorMessage = NSLocalizedString(
                "Email not valid",
                tableName: "SkyFloatingLabelTextField",
                comment: " "
            )
        } else {
            emailAddressField.errorMessage = nil
        }
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}
