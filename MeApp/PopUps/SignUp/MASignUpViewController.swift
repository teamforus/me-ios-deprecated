//
//  MASignUpViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MASignUpViewControllerDelegate:class {
    func confirmPinCode(_ controller: MASignUpViewController, pinCode: String)
}

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
    weak var delegate: MASignUpViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 8.0
        codeUITextField.delegate = self
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
    
    
    @IBAction func close(_ sender: Any) {
        delegate.confirmPinCode(self, pinCode: codeUITextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
