//
//  MAConfirmationTransactionViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/30/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Presentr
import Alamofire

class MAConfirmationTransactionViewController: MABasePopUpViewController {
    @IBOutlet weak var insuficientAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    var note: String!
    var voucher: Voucher!
    var addressVoucher: String!
    var amount: Double!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.text =  String(format: "€%.02f", amount ?? 0.0)
        let aditionalAmount = amount - voucher.amount
        if voucher.product != nil {
            amountLabel.text = String(format: "€%.02f", voucher.product?.price ?? 0.0)
            var reactBodyView = bodyView.frame
            reactBodyView.size.height = reactBodyView.size.height - 36
            bodyView.frame = reactBodyView
            insuficientAmountLabel.isHidden = true
        }else if amount > voucher.amount{
            insuficientAmountLabel.text = String(format: "Insufficient funds on the voucher.  Please, request extra payment of €%.02f", aditionalAmount)
        }else{
            var reactBodyView = bodyView.frame
            reactBodyView.size.height = reactBodyView.size.height - 36
            bodyView.frame = reactBodyView
            insuficientAmountLabel.isHidden = true
        }
    }

    @IBAction func requestTransaction(_ sender: Any) {
        if voucher.product == nil {
                    let parameters: Parameters = [
                        "organization_id" : voucher.allowedOrganizations!.first?.id ?? 0,
                        "amount" : amount,
                        "note" : note ?? ""]
                    TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: addressVoucher, completion: { (transaction, statusCode) in
                        if statusCode == 201{
                            self.dismiss(animated: true, completion: nil)
                        }else if statusCode == 422 {
                            AlertController.showWarning(withText: "Voucher not have enough funds", vc: self)
                        }
                    }) { (error) in
                    }
            }else{
            let parameters: Parameters = [
                "organization_id" : voucher.allowedOrganizations!.first?.id ?? 0,
                "amount" : voucher.amount ?? 0.0,
                "note" : note ?? ""]
            TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: addressVoucher, completion: { (transaction, statusCode) in
                if statusCode == 201{
                    self.dismiss(animated: true, completion: nil)
                }else if statusCode == 422 {
                    AlertController.showWarning(withText: "Voucher not have enough funds", vc: self)
                }
                
            }) { (error) in
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
