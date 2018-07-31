//
//  MAFirstPageViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAFirstPageViewController: MABaseViewController, AppLockerDelegate {
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    @IBOutlet weak var haveIdentityButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Devios Ryasnoy"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .validate, and: appearance)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func closePinCodeView(typeClose: typeClose) {
        switch typeClose {
        case .validate:
            break
        default:
            break
        }
    }

}
