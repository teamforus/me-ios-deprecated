//
//  MAFirstPageViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/28/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MAFirstPageViewController: MABaseViewController, AppLockerDelegate {
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    @IBOutlet weak var haveIdentityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
