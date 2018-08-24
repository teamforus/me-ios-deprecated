//
//  MAGeneralPassViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/24/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import ISHPullUp

class MAGeneralPassViewController: ISHPullUpViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        let storyBoard = UIStoryboard(name: "PassStoryboard", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "contentPass") as! PassViewController
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottomQRVoucher") as! MABottomVoucherViewController
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTapBar"), object: nil)
    }

}
