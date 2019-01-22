//
//  MABottomProductViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/18/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import ISHPullUp
import AssistantKit
import CoreData
import Reachability

class MABottomProductViewController: MABaseViewController , ISHPullUpSizingDelegate, ISHPullUpStateDelegate{
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet weak var voucherNamelabel: UILabel!
    @IBOutlet private weak var topView: UIView!
    var voucher: Voucher!
    @IBOutlet private weak var buttonLock: UIButton?
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var titleQRCodeLabel: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer : Timer! = Timer()
    var authorizeToken: AuthorizeToken!
    let reachability =  Reachability()!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView(){
        self.view.isHidden = true
        topView.layer.cornerRadius = 14.0
        rootView.layer.cornerRadius = 14.0
        rootView.layer.shadowColor = UIColor.black.cgColor
        rootView.layer.shadowOffset = CGSize(width: 0, height: -2)
        rootView.layer.shadowOpacity = 0.2
        rootView.layer.shadowRadius = 23 / 2
        self.qrCodeImageView.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(voucher.address!)\" }")
        titleQRCodeLabel.text = "This is your vouchers QR-code.".localized()
        voucherNamelabel.text = voucher.product?.name
        //        self.qrCodeImageView.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\”:\”cd66db60cde7f133bf122db07fdd534bd3ab4d04f9d93af4516c279f4dd1cbb6\“ }")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: Notification.Name("togleStateWindow"), object: nil)
        var rect: CGRect = self.rootView.frame
        let screen = Device.screen
        switch screen {
        case .inches_4_0:
            rect.size.height = 440
            break
        case .inches_4_7:
            rect.size.height = 500
            break
        case .inches_5_5:
            rect.size.height = 567
            break
        case .inches_5_8:
            rect.size.height = 650
            break
        default:
            break
            
        }
        self.rootView.frame = rect
    }
    
    @objc func toglePullUpView(){
        if pullUpController.state == .expanded{
            self.view.isHidden = true
        }else{
            self.view.isHidden = false
        }
        pullUpController.toggleState(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstAppearanceCompleted = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        if pullUpController.isLocked {
            return
        }
        pullUpController.toggleState(animated: true)
    }
    
    @IBAction private func buttonTappedLearnMore(_ sender: AnyObject) {
    }
    
    @IBAction private func buttonTappedLock(_ sender: AnyObject) {
    }
    
    @IBAction func close(_ sender: Any) {
        if pullUpController.state == .expanded || pullUpController.state == .intermediate{
            pullUpController.toggleState(animated: true)
            self.view.isHidden = true
        }
    }
    
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        
        if abs(height - halfWayPoint) < 30 {
            pullUpController.toggleState(animated: true)
            return halfWayPoint
        }
        
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
        if state == .collapsed {
            self.view.isHidden = true
        }else if state == .intermediate {
            pullUpController.toggleState(animated: true)
        }
        
    }
    
}
