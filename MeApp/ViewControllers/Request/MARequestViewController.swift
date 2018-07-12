//
//  MARequestViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/13/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MARequestViewController: MABaseViewController {
    @IBOutlet weak var descriptionSkyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var reqeustButton: UIButton!
    
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

    @IBAction func applyRequest(_ sender: Any) {
    }
    
}
