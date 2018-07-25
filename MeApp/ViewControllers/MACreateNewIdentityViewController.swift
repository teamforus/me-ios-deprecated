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

class MACreateNewIdentityViewController: MABaseViewController {
    @IBOutlet weak var validateIcon: UIImageView!
    @IBOutlet weak var emailSkyFloatingTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func create(_ sender: Any) {
        let emailObject = ["primary_email" : emailSkyFloatingTextField.text]
        let parameters: Parameters = ["pin_code" : "1234",
                          "records" : emailObject]
        RequestNewIndetity.createnewIndentity(parameters: parameters,
             completion: { (response) in
            if response.errors == nil {
                UserDefaults.standard.setValue(response.accessToken, forKeyPath: "access_token")
                self.performSegue(withIdentifier: "goToWalet", sender: self)
            }else {
                let error = MessageView.viewFromNib(layout: .tabView)
                error.configureTheme(.error)
                error.configureContent(title: "Invalid email", body: response.errors?.recordMessage.first, iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
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
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!){
            validateIcon.isHidden = false
            emailSkyFloatingTextField.errorMessage = nil
        }else{
            validateIcon.isHidden = true
            emailSkyFloatingTextField.errorMessage = "Email is not valid"
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
