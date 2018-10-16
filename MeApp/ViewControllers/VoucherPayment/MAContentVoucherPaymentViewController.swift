//
//  MAContentVoucherPaymentViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/10/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Alamofire

class MAContentVoucherPaymentViewController: MABaseViewController {
    @IBOutlet weak var paketTitle: UILabel!
    @IBOutlet weak var validDaysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var organizationImageView: UIImageView!
    @IBOutlet weak var pricePayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var voucher: Voucher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paketTitle.text = voucher.found.name
        organizationNameLabel.text = voucher.found.organization.name
        priceLabel.text = "€\(voucher.amount ?? 0)"
    }
    
    @IBAction func pay(_ sender: Any) {
        let parameters: Parameters = [
            "organization_id" : voucher.allowedOrganizations!.first?.id ?? 0,
            "amount" : voucher.amount]
        TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: voucher.address, completion: { (transaction, statusCode) in
            if statusCode == 201{
                self.dismiss(animated: true, completion: nil)
            }
            
        }) { (error) in
            
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
        return (voucher?.allowedProductCategories?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MAVoucherPaymentTableViewCell
        let productCategories = voucher.allowedProductCategories?[indexPath.row]
        cell?.categoryNameLabel.text = productCategories?.name
        return cell!
    }
}
