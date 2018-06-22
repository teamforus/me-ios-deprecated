//
//  MASwitchProfileViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class MASwitchProfileViewController: MABaseViewController,MASwitchProfilePopUpViewControllerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var descriptionQr: UILabel!
    @IBOutlet weak var labelQr: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var viewBodyQR: UIView!
    @IBOutlet weak var buttonSiwtchProfile: UIButton!
    @IBOutlet weak var heighQrConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBodyQR.layer.cornerRadius = 9.0
        viewBodyQR.layer.shadowColor = UIColor.black.cgColor;
        viewBodyQR.layer.shadowOffset = CGSize(width: 0, height: 20);
        viewBodyQR.layer.shadowOpacity = 0.1;
        viewBodyQR.layer.shadowRadius = 5.0;
        viewBodyQR.layer.masksToBounds = false;
        buttonSiwtchProfile.clipsToBounds = true
        buttonSiwtchProfile.layer.cornerRadius = 9.0
        imageQR.generateQRCode(from: "ios")
        if UIScreen.main.nativeBounds.height == 2436 {
            topConstraint.constant = -45
        }else{
            topConstraint.constant = -20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
//        profileImage.image = user.image
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset < 0)
        {
            UIView.animate(withDuration: 0.2) {
                var imageRect: CGRect = self.imageQR.frame
                imageRect.size.height = 224;
                imageRect.size.width = 250;
                imageRect.origin.x = 61
                imageRect.origin.y = 36;
                self.imageQR.frame = imageRect;
                var labelQRRect: CGRect = self.labelQr.frame
                labelQRRect.origin.y = 339
                self.labelQr.frame = labelQRRect
                var decriptionQRRect = self.descriptionQr.frame
                decriptionQRRect.origin.y = 372
                self.descriptionQr.frame = decriptionQRRect
                self.heighQrConstraint.constant = 440
            }
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            UIView.animate(withDuration: 0.2) {
                
                var imageRect: CGRect = self.imageQR.frame
                imageRect.size.height = 50;
                imageRect.size.width = 50;
                imageRect.origin.x = 173
                imageRect.origin.y = 31;
                self.imageQR.frame = imageRect;
                var labelQRRect: CGRect = self.labelQr.frame
                labelQRRect.origin.y = 104
                self.labelQr.frame = labelQRRect
                var decriptionQRRect = self.descriptionQr.frame
                decriptionQRRect.origin.y = 138
                self.descriptionQr.frame = decriptionQRRect
                self.heighQrConstraint.constant = 200
            }
        }
    }
}
