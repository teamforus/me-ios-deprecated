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

protocol MAConfirmationTransactionViewControllerDelegate: class {
    func paymentSucceded()
}

class MAConfirmationTransactionViewController: MABasePopUpViewController {
    @IBOutlet weak var requestButton: ShadowButton!
    var tabController: UITabBarController!
    @IBOutlet weak var insuficientAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    weak var delegate: MAConfirmationTransactionViewControllerDelegate!
    var note: String!
    var aditionalAmount: Double!
    var voucher: Voucher!
    var addressVoucher: String!
    var amount: String!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        if voucher.product != nil {
            amountLabel.text = "€\(voucher.product?.price ?? "0.0")?"
            var reactBodyView = bodyView.frame
            reactBodyView.size.height = reactBodyView.size.height - 36
            bodyView.frame = reactBodyView
            insuficientAmountLabel.isHidden = true
        }else{
            amountLabel.text = "€\(amount ?? "0.0")?"
            let amountVoucher = Double(voucher.amount)!
            aditionalAmount = Double(amount.replacingOccurrences(of: ",", with: "."))! - amountVoucher
            if Double(amount.replacingOccurrences(of: ",", with: "."))! > amountVoucher{
                requestButton.isEnabled = false
                requestButton.backgroundColor = #colorLiteral(red: 0.7646217346, green: 0.764754355, blue: 0.7646133304, alpha: 1)
                if NSLocale.preferredLanguages.first == "en"{
                insuficientAmountLabel.text = String(format:"Insufficient funds on the voucher. Please, request extra payment of".localized()+" €%.02f", aditionalAmount)
                }else if NSLocale.preferredLanguages.first == "nl"{
                    insuficientAmountLabel.text = String(format:"Onvoldoende budget op de voucher. Vraag de klant of hij een bedrag van".localized()+" €%.02f"+"wilt bijbetalen.", aditionalAmount)
                }
            }else{
            var reactBodyView = bodyView.frame
            reactBodyView.size.height = reactBodyView.size.height - 36
            bodyView.frame = reactBodyView
            insuficientAmountLabel.isHidden = true
            }
        }
    }

    @IBAction func requestTransaction(_ sender: Any) {
        if voucher.product == nil {
                    let parameters: Parameters = [
                        "organization_id" : voucher.allowedOrganizations!.first?.id ?? 0,
                        "amount" : amount.replacingOccurrences(of: ",", with: "."),
                        "note" : note ?? ""]
                    TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: addressVoucher, completion: { (transaction, statusCode) in
                        if statusCode == 201{
                            let alert: UIAlertController
                            alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Payment succeeded", comment: ""), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.tabController.selectedIndex = 0
                                self.presentingViewController?
                                    .presentingViewController?.dismiss(animated: true, completion: {
                                        
                                    })
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else if statusCode == 422 {
                            AlertController.showWarning(withText: "Voucher not have enough funds", vc: self)
                        }
                    }) { (error) in
                    }
            }else{
            let parameters: Parameters = [
                "organization_id" : voucher.product?.organization.id ?? 0,
                "amount" : voucher.amount ?? "0.0",
                "note" : note ?? ""]
            TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: addressVoucher, completion: { (transaction, statusCode) in
                if statusCode == 201{
                    let alert: UIAlertController
                    alert = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Payment succeeded", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.tabController.selectedIndex = 0
                        self.presentingViewController?
                            .presentingViewController?.dismiss(animated: true, completion: {
                                
                            })
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
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
