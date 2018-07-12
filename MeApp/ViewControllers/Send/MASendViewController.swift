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
        addressButton.layer.cornerRadius = 9.0
        addressButton.layer.shadowColor = UIColor.black.cgColor;
        addressButton.layer.shadowOffset = CGSize(width: 0, height: 10);
        addressButton.layer.shadowOpacity = 0.2;
        addressButton.layer.shadowRadius = 10.0;
        addressButton.layer.masksToBounds = false;
        //shadow for scanQrCodeButton
        scanQrCodeButton.layer.cornerRadius = 9.0
        scanQrCodeButton.layer.shadowColor = UIColor.black.cgColor;
        scanQrCodeButton.layer.shadowOffset = CGSize(width: 0, height: 0);
        scanQrCodeButton.layer.shadowOpacity = 0.2;
        scanQrCodeButton.layer.shadowRadius = 10.0;
        scanQrCodeButton.layer.masksToBounds = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func address(_ sender: Any) {
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
    }
    
}
