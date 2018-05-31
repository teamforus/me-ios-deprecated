//
//  MAEmailForMeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MAEmailForMeViewController: MABasePopUpViewController {
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 8.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func send(_ sender: Any) {
        if (Validation.validateEmailTextFieldWithText(email: emailTextField.text, textField: emailTextField)){
            print("tat ciki")
        }else{
            print("herovo")
        }
    }
}
