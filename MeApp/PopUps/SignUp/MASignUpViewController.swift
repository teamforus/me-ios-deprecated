//
//  MASignUpViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MASignUpViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var codeUITextField: UITextField!
    @IBOutlet weak var digit1UITextField: UITextField!
    @IBOutlet weak var digit2UITextField: UITextField!
    @IBOutlet weak var digit3UITextField: UITextField!
    @IBOutlet weak var digit4UITextField: UITextField!
    @IBOutlet weak var digit5UITextField: UITextField!
    @IBOutlet weak var digit6UITextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 8.0
        codeUITextField.delegate = self
        codeUITextField.becomeFirstResponder()
        
    }
    
    //    private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    //        let code = textField.text! + string
    //
    //        switch code.characters.count{
    //        case 1:
    //            digit1UITextField.text = string
    //        case 2:
    //            digit2UITextField.text = string
    //        case 3:
    //            digit3UITextField.text = string
    //        case 4:
    //            digit4UITextField.text = string
    //        case 5:
    //            digit5UITextField.text = string
    //        case 6:
    //            digit6UITextField.text = string
    //        default: break
    //        }
    //        return textField.text!.characters.count + (string.characters.count - range.length) <= 4;
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let code = textField.text! + string
        switch code.characters.count{
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
        return textField.text!.characters.count + (string.characters.count - range.length) <= 6;
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
