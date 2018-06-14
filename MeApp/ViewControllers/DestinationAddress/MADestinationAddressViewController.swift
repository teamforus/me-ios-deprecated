//
//  MADestinationAddressViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/13/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MADestinationAddressViewController: MABaseViewController {
    @IBOutlet weak var tokenAddressSkyTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func checkAddedToContactList(_ sender: Any) {
        
    }
    
    @IBAction func confirm(_ sender: Any) {
    }
    
    
}
