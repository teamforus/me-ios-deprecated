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
    
    @IBOutlet weak var roundedImage: UIImageView!
    @IBOutlet weak var chooseOrganizationButton: UIButton!
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
    @IBOutlet weak var organizationVoucherName: UILabel!
    @IBOutlet weak var organizationLogo: UIImageView!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    var selectedAllowerdOrganization: AllowedOrganizations!
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
        setupView()
    }
    
    fileprivate func setupView(){
        qrImageViewBody.layer.shadowColor = UIColor.black.cgColor
        qrImageViewBody.layer.shadowOffset = CGSize(width: 0, height: 5)
        qrImageViewBody.layer.shadowOpacity = 0.1
        qrImageViewBody.layer.shadowRadius = 10.0
        qrImageViewBody.clipsToBounds = false
        IQKeyboardManager.sharedManager().enable = true
        if voucher.product != nil {
            roundedImage.isHidden = true
            chooseOrganizationButton.isHidden = true
            paketTitle.text = voucher.product?.name
            organizationNameLabel.text = voucher.product?.organization.name
            if voucher.product?.photo != nil {
                qrCodeImageView.sd_setImage(with: URL(string: voucher.product?.photo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
                organizationLogo.sd_setImage(with: URL(string: voucher.product?.photo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }else{
                qrCodeImageView.image = UIImage(named: "Resting")
                organizationLogo.image = UIImage(named: "face24Px")
            }
        }else{
            paketTitle.text = voucher.found.name
            organizationNameLabel.text =  voucher.allowedOrganizations?.first?.name ?? ""
            organizationVoucherName.text = voucher.found.organization.name ?? ""
            selectedAllowerdOrganization = voucher.allowedOrganizations?.first
            if voucher.found.logo != nil{
                qrCodeImageView.sd_setImage(with: URL(string: voucher.found?.logo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
                organizationLogo.sd_setImage(with: URL(string: voucher.allowedOrganizations?.first?.logo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }else{
                qrCodeImageView.image = UIImage(named: "Resting")
                qrCodeImageView.image = UIImage(named: "face24Px")
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        if voucher.product != nil {
            organizationVoucherName.text = voucher.product?.organization.name ?? ""
            self.amountView.isHidden = true
            var rectNote = self.noteView.frame
            rectNote.origin.y = 70
            self.noteView.frame = rectNote
            heightContraint.constant = 160
        }else{
            organizationVoucherName.text = voucher.found.organization.name ?? ""
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func paymentSucceded() {
        AlertController.showSuccess(withText: "Payment succeeded".localized(), vc: self)
    }
    
    @IBAction func chooseOrganization(_ sender: Any) {
        let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", bundle: nil)
        popOverVC.allowedOrganizations = self.voucher.allowedOrganizations
        popOverVC.delegate = self
        popOverVC.selectedOrganizations = selectedAllowerdOrganization
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(popOverVC.view)
    }
    
    
    @IBAction func send(_ sender: Any) {
        if voucher.product != nil{
            goToTrnasctionConfirm()
        }else if amount.text == ""{
            AlertController.showWarning(withText: "Please enter the amount".localized(), vc: self)
        }else{
            goToTrnasctionConfirm()
        }
    }
    
    func goToTrnasctionConfirm(){
        let popupTransction =  MAConfirmationTransactionViewController(nibName: "MAConfirmationTransactionViewController", bundle: nil)
        self.presenter.presentationType = .popup
        popupTransction.voucher = voucher
        popupTransction.tabController = tabController
        popupTransction.selectedAllowerdOrganization = selectedAllowerdOrganization
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
        cell?.organization = voucher.allowedProductCategories?[indexPath.row]
        return cell!
    }
}

extension MAContentVoucherPaymentViewController: AllowedOrganizationsViewControllerDelegate{
    func didSelectAllowedOrganization(organization: AllowedOrganizations) {
        selectedAllowerdOrganization = organization
        organizationNameLabel.text = organization.name
        organizationLogo.sd_setImage(with: URL(string: organization.logo?.sizes?.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
        
    }
}


extension MAContentVoucherPaymentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var dotString = ""
        if self.getLanguageISO() == "en"{
            
            dotString = "."
            
        }else if self.getLanguageISO() == "nl" {
            
            dotString = ","
        }
        
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            
            if !isDeleteKey {
                if text.contains(dotString) {
                    let countdots = textField.text!.components(separatedBy: dotString).count - 1
                    
                    if countdots > 0 && string == dotString
                    {
                        return false
                    }
                    
                    if text.components(separatedBy: dotString)[1].count == 2 {
                        
                        return false
                    }
                }
            }
        }
        return true
    }
    
}
