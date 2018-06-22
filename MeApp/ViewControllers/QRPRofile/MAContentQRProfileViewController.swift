//
//  MAContentQRProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAContentQRProfileViewController: MABaseViewController, MASwitchProfilePopUpViewControllerDelegate {
    @IBOutlet weak var switchProfileView: UIView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var organizationIconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchProfileView.layer.cornerRadius = 9.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func switchProfile(_ controller: MASwitchProfilePopUpViewController, user: User) {
        organizationNameLabel.text = user.name
    }

    @IBAction func switchProfile(_ sender: Any) {
        let popupTransction =  MASwitchProfilePopUpViewController(nibName: "MASwitchProfilePopUpViewController", bundle: nil)
        popupTransction.delegate = self
        dynamicSizePresenter.presentationType = .bottomHalf
        customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
    }
}
