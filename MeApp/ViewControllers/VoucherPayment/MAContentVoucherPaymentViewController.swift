//
//  MAContentVoucherPaymentViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/10/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Alamofire
import Presentr
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
import SDWebImage

class MAContentVoucherPaymentViewController: MABaseViewController, MAConfirmationTransactionViewControllerDelegate {
    @IBOutlet weak var noteView: CustomCornerUIView!
    @IBOutlet weak var amountView: CustomCornerUIView!
    @IBOutlet weak var paketTitle: UILabel!
    var addressVoucher: String!
    var tabController: UITabBarController!
    @IBOutlet weak var qrImageViewBody: UIImageView!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var validDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var pricePayLabel: UILabel!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var noteSkyTextField: UITextField!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    var voucher: Voucher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImageViewBody.layer.shadowColor = UIColor.black.cgColor
        qrImageViewBody.layer.shadowOffset = CGSize(width: 0, height: 5)
        qrImageViewBody.layer.shadowOpacity = 0.1
        qrImageViewBody.layer.shadowRadius = 10.0
        qrImageViewBody.clipsToBounds = false
        IQKeyboardManager.sharedManager().enable = true
        if voucher.product != nil {
            paketTitle.text = voucher.product?.name
            organizationNameLabel.text = voucher.product?.organization.name
            qrCodeImageView.sd_setImage(with: URL(string: voucher.product?.photo.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
        }else{
            paketTitle.text = voucher.found.name
            organizationNameLabel.text = voucher.found.organization.name ?? ""
            if voucher.found.logo != nil{
                qrCodeImageView.sd_setImage(with: URL(string: voucher.found.logo.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }else{
                qrCodeImageView.image = UIImage(named: "Resting")
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        if voucher.product != nil {
            self.priceLabel.text = voucher.product?.organization.name ?? ""
            self.amountView.isHidden = true
            var rectNote = self.noteView.frame
            rectNote.origin.y = 70
            self.noteView.frame = rectNote
            heightContraint.constant = 160
        }else{
            self.priceLabel.text = voucher.found.organization.name ?? ""
        }
        
    }
    
    @objc func dismissKeyboard(){
        //        self.tabBarController?.selectedIndex = 1
        self.view.endEditing(true)
    }
    
    func paymentSucceded() {
        AlertController.showSuccess(withText: "Payment succeeded", vc: self)
    }
    
    @IBAction func send(_ sender: Any) {
        if voucher.product != nil{
            goToTrnasctionConfirm()
        }else if amount.text == ""{
            AlertController.showWarning(withText: "Please set amount!", vc: self)
        }else{
            goToTrnasctionConfirm()
        }
    }
    
    func goToTrnasctionConfirm(){
        let popupTransction =  MAConfirmationTransactionViewController(nibName: "MAConfirmationTransactionViewController", bundle: nil)
        self.presenter.presentationType = .popup
        popupTransction.voucher = voucher
        popupTransction.tabController = tabController
        popupTransction.addressVoucher = addressVoucher
        popupTransction.delegate = self
        popupTransction.amount = amount.text
        popupTransction.note = noteSkyTextField.text ?? ""
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.keyboardTranslationType = .compress
        self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func checkAmount(_ sender: Any) {
     
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MAContentVoucherPaymentViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if voucher.product != nil {
            return 0
        }
        return (voucher?.allowedProductCategories?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MAVoucherPaymentTableViewCell
        let productCategories = voucher.allowedProductCategories?[indexPath.row]
        cell?.categoryNameLabel.text = productCategories?.name
        return cell!
    }
}
