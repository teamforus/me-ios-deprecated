//
//  MAShareVaucherViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MAShareVaucherViewController: MABasePopUpViewController {
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var amount: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.cornerRadius = 14.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amount.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func send(_ sender: Any) {
    }
}


