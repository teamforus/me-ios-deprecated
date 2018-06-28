//
//  MAPinCodeLoginViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAPinCodeLoginViewController: MABaseViewController ,UITextFieldDelegate{
    @IBOutlet weak var codeUITextField: UITextField!
    @IBOutlet weak var digit1UITextField: UITextField!
    @IBOutlet weak var digit2UITextField: UITextField!
    @IBOutlet weak var digit3UITextField: UITextField!
    @IBOutlet weak var digit4UITextField: UITextField!
    @IBOutlet weak var digit5UITextField: UITextField!
    @IBOutlet weak var digit6UITextField: UITextField!
    @IBOutlet weak var viewPinCode: UIView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    codeUITextField.delegate = self
        viewPinCode.layer.cornerRadius = 9.0
        viewPinCode.layer.shadowColor = UIColor.black.cgColor
        viewPinCode.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewPinCode.layer.shadowOpacity = 0.1
        viewPinCode.layer.shadowRadius = 10.0
        viewPinCode.layer.masksToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    codeUITextField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let code = textField.text! + string
    switch code.count{
    case 1:
    digit1UITextField.text = string
    case 2:
    digit2UITextField.text = string
    case 3:
    digit3UITextField.text = string
    case 4:
    digit4UITextField.text = string
    case 5:
    digit5UITextField.text = string
    case 6:
    digit6UITextField.text = string
    default: break
    }
    return (textField.text?.count)! + (string.count - range.length) <= 6;
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    }

}
