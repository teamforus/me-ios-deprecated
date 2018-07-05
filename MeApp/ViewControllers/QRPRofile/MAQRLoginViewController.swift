//
//  MAQRLoginViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/5/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAQRLoginViewController: MABaseViewController {
    @IBOutlet weak var qrBodyView: UIView!
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrBodyView.layer.cornerRadius = 9.0
        qrBodyView.layer.shadowColor = UIColor.black.cgColor;
        qrBodyView.layer.shadowOffset = CGSize(width: 0, height: 0)
        qrBodyView.layer.shadowOpacity = 0.2
        qrBodyView.layer.shadowRadius = 10.0
        qrImage.generateQRCode(from: "LoginQr")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
