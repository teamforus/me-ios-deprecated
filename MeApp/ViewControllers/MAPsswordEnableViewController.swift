//
//  MAPsswordEnableViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAPsswordEnableViewController: MABaseViewController, AppLockerDelegate {
   
    
    var appLocker: AppLocker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createPasscode(_ sender: Any) {
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Create passcode"
        appearance.subtitle = "Your passcode is required \n to enable Face ID"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .create, and: appearance)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
       performSegue(withIdentifier: "goToWalet", sender: self)
    }
    
    func closePinCodeView(typeClose: typeClose) {
        switch typeClose {
        case .cancel:
            performSegue(withIdentifier: "goToWalet", sender: self)
            break
        case .create:
            performSegue(withIdentifier: "goToWalet", sender: self)
            break
        default:
            break
        }
    }

}
