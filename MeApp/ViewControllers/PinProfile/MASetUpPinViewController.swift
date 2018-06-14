//
//  MASetUpPinViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/24/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MASetUpPinViewController: MABaseViewController,UITextFieldDelegate {
    @IBOutlet weak var codeUITextField: UITextField!
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    @IBOutlet weak var pin1: UITextField!
    @IBOutlet weak var pin2: UITextField!
    @IBOutlet weak var pin3: UITextField!
    @IBOutlet weak var pin4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         codeUITextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeUITextField.becomeFirstResponder()
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let code = textField.text! + string
        switch code.count{
        case 1:
            pin1.text = string
        case 2:
            pin2.text = string
        case 3:
            pin3.text = string
        case 4:
            pin4.text = string
            
        default: break
        }
        return (textField.text?.count)! + (string.count - range.length) <= 4;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
