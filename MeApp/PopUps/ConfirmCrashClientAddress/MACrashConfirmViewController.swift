//
//  MACrashConfirmViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 1/15/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import UIKit

class MACrashConfirmViewController: MABasePopUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmCrashAddress(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "ISENABLESENDADDRESS")
        self.dismiss(animated: true, completion: nil)
    }
    

}
