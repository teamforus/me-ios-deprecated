//
//  MAContentPersonalDetailViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/26/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import ISHPullUp

class MAContentPersonalDetailViewController: ISHPullUpViewController {
    var record: Record!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    private func commonInit() {
        let storyBoard = UIStoryboard(name: "Records", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "personalDetail") as! MAPersonalDetailViewController
        contentVC.record = record
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottomPersonal") as! MABottomPersonalQRViewController
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        bottomVC.record = record
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTapBar"), object: nil)
    }
    
}

