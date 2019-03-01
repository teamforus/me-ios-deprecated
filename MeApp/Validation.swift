//
//  Validation.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class Validation: NSObject {
    
  static public func validateEmailTextFieldWithText(email: String?, textField: SkyFloatingLabelTextField) -> Bool {

    if (email?.isEmpty)! {
            textField.errorMessage = nil
            return true
    } else if !validateEmail(email!) {
            textField.errorMessage = NSLocalizedString(
                "Email not valid",
                tableName: "SkyFloatingLabelTextField",
                comment: " "
            )
            return false
        } else {
            textField.errorMessage = nil
            return true
        }
    }
    
    static public func validateFieldEmpty(textField: SkyFloatingLabelTextField) -> Bool{
        if textField.text == "" {
             textField.errorMessage = "Field is empty".localized()
            return false
        }else {
             textField.errorMessage = nil
            return true
        }
    }
    
   static func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    

}
