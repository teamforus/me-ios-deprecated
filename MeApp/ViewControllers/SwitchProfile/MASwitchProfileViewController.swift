//
//  MASwitchProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import PopupWindow

class MASwitchProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAlertSheedSwitchProfile(_ sender: Any) {
    PopupWindowManager.shared.changeKeyWindow(rootViewController: RegisterPopupViewController())
    }

}
