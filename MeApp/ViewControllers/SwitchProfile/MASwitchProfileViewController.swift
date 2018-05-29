//
//  MASwitchProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MASwitchProfileViewController: MABaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageQR.generateQRCode(from: "ios")
        if UIScreen.main.nativeBounds.height == 2436 {
            topConstraint.constant = -45
        }else{
            topConstraint.constant = -20
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAlertSheedSwitchProfile(_ sender: Any) {
    PopupWindowManager.shared.changeKeyWindow(rootViewController: MASwitchProfilePopupViewController())
    }
}
