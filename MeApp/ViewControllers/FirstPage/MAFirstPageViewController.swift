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
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
//        popupTransction.voucher = voucher
        self.presenter.presentationType = .popup
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.keyboardTranslationType = .compress
        self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
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
