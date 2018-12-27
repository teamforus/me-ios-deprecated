//
//  MABaseQRProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp

class MABaseQRProfileViewController: ISHPullUpViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    private func commonInit() {
        let storyBoard = UIStoryboard(name: "LoginPage", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "content") as! MALoginWithQRViewController
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottom") as! MABotomQrProfileViewController
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTapBar"), object: nil)
    }

}
