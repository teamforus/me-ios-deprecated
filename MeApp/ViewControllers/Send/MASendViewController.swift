//
//  MASendViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/13/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MASendViewController: MABaseViewController {
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var scanQrCodeButton: UIButton!
    
    @IBOutlet weak var descriptionSkyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var amounSkyTextField: SkyFloatingLabelTextField!
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

    @IBAction func address(_ sender: Any) {
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
    }
    
}
