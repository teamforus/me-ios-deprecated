//
//  MASwitchProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MASwitchProfileViewController: MABaseViewController,MASwitchProfilePopUpViewControllerDelegate {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileName: UILabel!
    let dynamicSizePresenter: Presentr = {
        let presentationType = PresentationType.dynamic(center: .center)
        
        let presenter = Presentr(presentationType: presentationType)
        
        return presenter
    }()
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var imageQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageQR.generateQRCode(from: "ios")
        if UIScreen.main.nativeBounds.height == 2436 {
            topConstraint.constant = -45
        }else{
            topConstraint.constant = -20
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAlertSheedSwitchProfile(_ sender: Any) {
        let popupTransction =  MASwitchProfilePopUpViewController(nibName: "MASwitchProfilePopUpViewController", bundle: nil)
        popupTransction.delegate = self
        dynamicSizePresenter.presentationType = .bottomHalf
        customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    func switchProfile(_ controller: MASwitchProfilePopUpViewController, user: User) {
        profileName.text = user.name
        profileImage.image = user.image
    }
}
