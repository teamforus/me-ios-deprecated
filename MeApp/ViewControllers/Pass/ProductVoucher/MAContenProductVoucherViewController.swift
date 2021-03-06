//
//  MAContenProductVoucherViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/18/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import ISHPullUp

class MAContenProductVoucherViewController: ISHPullUpViewController {

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
        let storyBoard = UIStoryboard(name: "ProductVoucher", bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "productVoucher") as! MAProductVoucherViewController
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottomQRProduct") as! MABottomProductViewController
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }

}
