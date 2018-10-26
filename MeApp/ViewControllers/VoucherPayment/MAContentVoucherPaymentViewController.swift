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

class MAContentVoucherPaymentViewController: MABaseViewController {
    @IBOutlet weak var paketTitle: UILabel!
    @IBOutlet weak var validDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var pricePayLabel: UILabel!
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
            priceLabel.text = "€\(voucher.product?.price! ?? 0.0)"
        }else{
            priceLabel.text = "€\(voucher.amount ?? 0.0)"
        }
        
    }
    
    @objc func dismissKeyboard(){
        //        self.tabBarController?.selectedIndex = 1
        self.view.endEditing(true)
    }
    
    @IBAction func send(_ sender: Any) {
        if amount.text != "" {
            if  Double(amount.text!)! > Double(self.voucher.amount ?? 0){
                amount.errorMessage = "You enter more biger price then amount!"
            }else{
                amount.errorMessage = nil
                let parameters: Parameters = [
                    "organization_id" : voucher.allowedOrganizations!.first?.id ?? 0,
                    "amount" : Double(self.amount.text!)!,
                    "note" : noteSkyTextField.text ?? ""]
                TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: voucher.address, completion: { (transaction, statusCode) in
                    if statusCode == 201{
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }) { (error) in
                    
                }
            }
        }else{
            amount.errorMessage = "This field is required"
        }
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
