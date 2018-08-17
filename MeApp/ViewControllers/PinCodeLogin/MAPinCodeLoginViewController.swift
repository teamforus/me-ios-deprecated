//
//  MAPinCodeLoginViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SwiftMessages

class MAPinCodeLoginViewController: MABaseViewController ,UITextFieldDelegate{
    @IBOutlet weak var codeUITextField: UITextField!
    @IBOutlet weak var digit1UILabel: UILabel!
    @IBOutlet weak var digit2UILabel: UILabel!
    @IBOutlet weak var digit3UILabel: UILabel!
    @IBOutlet weak var digit4UILabel: UILabel!
    @IBOutlet weak var digit5UILabel: UILabel!
    @IBOutlet weak var digit6UILabel: UILabel!
    @IBOutlet weak var viewPinCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPinCode.layer.cornerRadius = 9.0
        viewPinCode.layer.shadowColor = UIColor.black.cgColor
        viewPinCode.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewPinCode.layer.shadowOpacity = 0.1
        viewPinCode.layer.shadowRadius = 10.0
        viewPinCode.layer.masksToBounds = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthorizationCodeRequest.createAuthorizationCode(completion: { (response) in
            if response.authCode != nil{
                let stringCode: String = "\(response.authCode!)"
                if stringCode.count == 6{
                    self.digit1UILabel.text = String(stringCode[0])
                    self.digit2UILabel.text = String(stringCode[1])
                    self.digit3UILabel.text = String(stringCode[2])
                    self.digit4UILabel.text = String(stringCode[3])
                    self.digit5UILabel.text = String(stringCode[4])
                    self.digit6UILabel.text = String(stringCode[5])
                    UserDefaults.standard.setValue(response.authCode, forKey: "auth_code")
                }
            }
        }) { (error) in
            AlertController.showError()
        }
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //    let code = textField.text! + string
    //    switch code.count{
    //    case 1:
    //    digit1UITextField.text = string
    //    case 2:
    //    digit2UITextField.text = string
    //    case 3:
    //    digit3UITextField.text = string
    //    case 4:
    //    digit4UITextField.text = string
    //    case 5:
    //    digit5UITextField.text = string
    //    case 6:
    //    digit6UITextField.text = string
    //    default: break
    //    }
    //    return (textField.text?.count)! + (string.count - range.length) <= 6;
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginWithCode(_ sender: Any) {
        if UserShared.shared.currentUser != nil {
            AuthorizationCodeRequest.authorizeCode(completion: { (response) in
                if response.success != nil {
                    self.performSegue(withIdentifier: "goToWallet", sender: nil)
                }else if response.message != nil {
                    let error = MessageView.viewFromNib(layout: .tabView)
                    error.configureTheme(.error)
                    error.configureContent(title: "Warning", body: response.message , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                        SwiftMessages.hide()
                    }
                    error.button?.setTitle("OK", for: .normal)
                    
                    SwiftMessages.show( view: error)
                }
            }) { (error) in
                AlertController.showError()
            }
        }else {
            let error = MessageView.viewFromNib(layout: .tabView)
            error.configureTheme(.error)
            error.configureContent(title: "Warning", body: "This device in not authorize" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                SwiftMessages.hide()
            }
            error.button?.setTitle("OK", for: .normal)
            
            SwiftMessages.show( view: error)
        }
    }
}
