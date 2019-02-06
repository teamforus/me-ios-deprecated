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
    @IBOutlet weak var titleLabel: UILabel!
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
        if voucher.product != nil {
            if self.getLanguageISO() == "en"{
                initTextLabels(title: "Confirm transaction", amount: "Are you sure you want to request €\(voucher.amount ?? "0.0")?")
            }else if self.getLanguageISO() == "nl"{
                initTextLabels(title: "Bevestig betaling", amount: "Wil je de transactie van €\(voucher.amount ?? "0.0") bevestigen?")
            }
            var reactBodyView = bodyView.frame
            reactBodyView.size.height = reactBodyView.size.height - 36
            bodyView.frame = reactBodyView
            insuficientAmountLabel.isHidden = true
        }else{
            let amountVoucher = Double(voucher.amount)!
            aditionalAmount = Double(amount.replacingOccurrences(of: ",", with: "."))! - amountVoucher
            if self.getLanguageISO() == "en"{
                initTextLabels(title: "Confirm transaction", amount: "Please confirm the transaction of €\(amount.replacingOccurrences(of: ",", with: ".")).")
            }else if self.getLanguageISO() == "nl"{
                initTextLabels(title: "Bevestig transactie", amount: "Is het bedrag van €\(amount.replacingOccurrences(of: ",", with: ".")) correct?")
            }
            if Double(amount.replacingOccurrences(of: ",", with: "."))! > amountVoucher{
                requestButton.isEnabled = false
                requestButton.backgroundColor = #colorLiteral(red: 0.7646217346, green: 0.764754355, blue: 0.7646133304, alpha: 1)
                if self.getLanguageISO() == "en"{
                    insuficientAmountLabel.text = String(format:"Insufficient funds on the voucher. Please, request extra payment of"+"€%.02f", aditionalAmount)
                }else if self.getLanguageISO() == "nl"{
                    insuficientAmountLabel.text = String(format:"Onvoldoende budget op de voucher. Vraag de klant of hij een bedrag van"+"€%.02f"+" wilt bijbetalen.", aditionalAmount)
                }
            }else{
                var reactBodyView = bodyView.frame
                reactBodyView.size.height = reactBodyView.size.height - 36
                bodyView.frame = reactBodyView
                insuficientAmountLabel.isHidden = true
            }
        }
    }
    
    func initTextLabels(title: String, amount: String){
        titleLabel.text = title
        amountLabel.text = amount
    }
    
    @IBAction func requestTransaction(_ sender: Any) {
        
            if voucher.product == nil {
                didMakeTransactionConfirmRequest(organizationId: voucher.allowedOrganizations!.first?.id ?? 0, amount: amount.replacingOccurrences(of: ",", with: "."))
            }else{
                didMakeTransactionConfirmRequest(organizationId: voucher.product?.organization.id ?? 0, amount: voucher.amount ?? "0.0")
            }
    }
    
    func didMakeTransactionConfirmRequest(organizationId: Int, amount: String){
        let parameters: Parameters = [
            "organization_id" : organizationId,
            "amount" : amount,
            "note" : note ?? ""]
        TransactionVoucherRequest.makeTransaction(parameters: parameters, identityAdress: addressVoucher, completion: { (transaction, statusCode) in
            if statusCode == 201{
                let alert: UIAlertController
                alert = UIAlertController(title: "Success".localized(), message: "Payment succeeded".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.tabController.selectedIndex = 0
                    self.presentingViewController?
                        .presentingViewController?.dismiss(animated: true, completion: {
                            
                        })
                }))
                self.present(alert, animated: true, completion: nil)
                
            }else if statusCode == 422 {
                AlertController.showWarning(withText: "Voucher not have enough funds", vc: self)
            } }) { (error) in }
    }
    
}

extension MAConfirmationTransactionViewController: AppLockerDelegate{
    
    func closePinCodeView(typeClose: typeClose) {
        if typeClose == .validate{
            if voucher.product == nil {
                didMakeTransactionConfirmRequest(organizationId: voucher.allowedOrganizations!.first?.id ?? 0, amount: amount.replacingOccurrences(of: ",", with: "."))
            }else{
                didMakeTransactionConfirmRequest(organizationId: voucher.product?.organization.id ?? 0, amount: voucher.amount ?? "0.0")
            }
        }
    }
}

extension UIViewController{
    
    func getLanguageISO() -> String {
        return Locale.current.languageCode!
    }
}
