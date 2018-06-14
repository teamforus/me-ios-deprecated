//
//  MAValidationRequestViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/13/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MAValidationRequestViewController: MABaseViewController {
    @IBOutlet weak var tokenAddressSkyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameSkyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var shapeValidation1: UIImageView!
    @IBOutlet weak var shapeValidation2: UIImageView!
    
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
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    @IBAction func confirm(_ sender: Any) {
    }
    
}
