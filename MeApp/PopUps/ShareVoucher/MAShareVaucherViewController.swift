//
//  MAShareVaucherViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class MAShareVaucherViewController: MABasePopUpViewController {
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    var voucher: Voucher!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    var categoryNames: NSMutableString! = NSMutableString()
    @IBOutlet weak var amount: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.cornerRadius = 14.0
        organizationName.text = voucher.found.name
        for category in voucher.allowedProductCategories{
            if category.id == voucher.allowedProductCategories.last?.id{
                categoryNames.append(category.name)
            }else{
                categoryNames.append(category.name+", ")
            }
        }
        categoriesLabel.text = "\(categoryNames!)"
        categoryNameLabel.text = voucher.found.organization.name
        productNameLabel.text = "€\(voucher.amount ?? 0)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amount.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkAmount(_ sender: Any) {
        if amount.text != "" {
            if Float(amount.text!)! > Float(self.voucher.amount  ?? 0){
                amount.errorMessage = "You enter more biger price then amount!"
            }else{
                amount.errorMessage = nil
            }
        }else {
             amount.errorMessage = "This field is required"
        }
    }
    
    
    @IBAction func send(_ sender: Any) {
        if amount.text != "" {
            if  Float(amount.text!)! > Float(self.voucher.amount ?? 0){
                amount.errorMessage = "You enter more biger price then amount!"
            }else{
                amount.errorMessage = nil
                let parameters: Parameters = [
                    "organization_id" : voucher.allowedOrganizations.first?.id ?? 0,
                                  "amount" : Float(self.amount.text!)!]
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
}


