//
//  MANewProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField

class MANewProfileViewController: MABaseViewController,UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

}
