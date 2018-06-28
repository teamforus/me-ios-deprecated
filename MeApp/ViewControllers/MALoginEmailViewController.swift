//
//  MALoginEmailViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MALoginEmailViewController: MABaseViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var validationEmailImage: UIImageView!
    @IBOutlet weak var validationConfirmEmail: UIImageView!
    @IBOutlet weak var emailSkyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmEmailSkyTextField: SkyFloatingLabelTextField!
    var mailIsValid: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 9.0
        confirmButton.layer.shadowColor = UIColor.black.cgColor;
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        confirmButton.layer.shadowOpacity = 0.2
        confirmButton.layer.shadowRadius = 10.0
        confirmButton.layer.masksToBounds = false
       
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if textField == emailSkyTextField  {
            if Validation.validateEmail(emailSkyTextField.text!){
                validationEmailImage.isHidden = false
            }else{
                validationEmailImage.isHidden = true
            }
        }else if textField == confirmEmailSkyTextField{
            if confirmEmailSkyTextField.text == emailSkyTextField.text{
                validationConfirmEmail.isHidden = false
                mailIsValid = true
            }else{
                validationConfirmEmail.isHidden = true
                mailIsValid = false
            }
        }
    }
    
    @IBAction func loginInApp(_ sender: Any) {
        if mailIsValid {
            performSegue(withIdentifier: "goToWalet", sender: self)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
