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

class MAContentVoucherPaymentViewController: MABaseViewController {
    @IBOutlet weak var noteView: CustomCornerUIView!
    @IBOutlet weak var amountView: CustomCornerUIView!
    @IBOutlet weak var paketTitle: UILabel!
    var addressVoucher: String!
    @IBOutlet weak var validDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var pricePayLabel: UILabel!
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amount: SkyFloatingLabelTextField!
    @IBOutlet weak var noteSkyTextField: SkyFloatingLabelTextField!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    var voucher: Voucher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        if voucher.product != nil {
            paketTitle.text = voucher.product?.name
            organizationNameLabel.text = voucher.product?.organization.name
        }else{
            paketTitle.text = voucher.found.name
            organizationNameLabel.text = voucher.found.organization.name ?? ""
            
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        if voucher.product != nil {
            self.priceLabel.text = String(format: "€%.02f", voucher.product?.price ?? 0.0)
            self.amountView.isHidden = true
            var rectNote = self.noteView.frame
            rectNote.size.height =  130
            rectNote.origin.y = 70
            self.noteView.frame = rectNote
        }else{
            self.priceLabel.text = String(format: "€%.02f", voucher.amount ?? 0.0)
        }
        
    }
    
    @objc func dismissKeyboard(){
        //        self.tabBarController?.selectedIndex = 1
        self.view.endEditing(true)
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
        popupTransction.addressVoucher = addressVoucher
        popupTransction.amount = Double(amount.text ?? "0.0")
        popupTransction.note = noteSkyTextField.text ?? ""
        self.presenter.transitionType = nil
        self.presenter.dismissTransitionType = nil
        self.presenter.keyboardTranslationType = .compress
        self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func checkAmount(_ sender: Any) {
        if amount.text != "" {
            if Double(amount.text!)! > Double(self.voucher.amount  ?? 0){
                amount.errorMessage = "You enter more biger price then amount!"
            }else{
                amount.errorMessage = nil
            }
        }else {
            amount.errorMessage = "This field is required"
        }
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
