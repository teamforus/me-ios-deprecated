//
//  TransactionViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/21/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionViewController: MABasePopUpViewController {
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceTransactionLabel: UILabel!
    @IBOutlet weak var transactionViewDetail: UIView!
    @IBOutlet weak var confirmationRecieveLabel: UILabel!
    var transaction: Transactions!
    var isVisisbeTabBar: Bool! = false
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var orgnizationNameLabel: UILabel!
    @IBOutlet weak var dateTransactionLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    
    
    @IBOutlet weak var sendTitleLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiveTitleLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var detaiTranscationButton: UIButton!
    var isOpen: Bool! = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.masksToBounds = true
        viewBody.layer.cornerRadius = 14.0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        var viewbodyRect: CGRect = self.viewBody.frame
        viewbodyRect.size.height = 315
        viewbodyRect.origin.y = self.view.frame.size.height - 315
        self.viewBody.frame = viewbodyRect
        self.transactionViewDetail.isHidden = true
        self.showAnimate()
        orgnizationNameLabel.text = transaction.organization.name
        companyNameLabel.text = transaction.organization.name
        if transaction.product != nil {
//            voucherLabel.text = transaction.product.productCategory.name
        }
        priceTransactionLabel.text = "- \(transaction.amount!) €"
        dateCreatedLabel.text = transaction.created_at.dateFormaterNormalDate()
        dateTransactionLabel.text = transaction.created_at.dateFormaterNormalDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func close(_ sender: Any) {
        self.removeAnimate()
        if isVisisbeTabBar{
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func expandTransactionDetail(_ sender: Any) {
        //315
        if isOpen{
            isOpen = false
            UIView.animate(withDuration: 0.3) {
                var viewbodyRect: CGRect = self.viewBody.frame
                viewbodyRect.size.height = 315
                viewbodyRect.origin.y = self.view.frame.size.height - 315
                self.viewBody.frame = viewbodyRect
                var detailButton: CGRect = self.detaiTranscationButton.frame
                detailButton.size.height = 65
                self.detaiTranscationButton.frame = detailButton
                self.transactionViewDetail.isHidden = true
                //                var companyNameFrame: CGRect = self.companyNameLabel.frame
                //                companyNameFrame.origin.x = 135
                //                companyNameFrame.origin.y = 117
                //                self.companyNameLabel.frame = companyNameFrame
                //                var priceFrame: CGRect = self.priceTransactionLabel.frame
                //                priceFrame.origin.x = 112
                //                priceFrame.origin.y = 152
                //                self.priceTransactionLabel.frame = priceFrame
                //                var confirmationReceive: CGRect = self.confirmationRecieveLabel.frame
                //                confirmationReceive.origin.x = 146
                //                confirmationReceive.origin.y = 184
                //                self.confirmationRecieveLabel.frame = confirmationReceive
                //                //make view for detail transaction
                //                var detailButton: CGRect = self.detaiTranscationButton.frame
                //                detailButton.origin.y = 301
                //                detailButton.size.height = 45
                //                self.detaiTranscationButton.frame = detailButton
                //                var transactionFrame: CGRect = self.transactionLabel.frame
                //                transactionFrame.origin.y = 315
                //                self.transactionLabel.frame = transactionFrame
                //                self.sendTitleLabel.isHidden = true
                //                self.senderLabel.isHidden = true
                //                self.receiveTitleLabel.isHidden = true
                //                self.receiverLabel.isHidden = true
                //                self.dateTitleLabel.isHidden = true
                //                self.dateLabel.isHidden = true
                //                self.transactionLabel.text = "Transactie"
            }
            
            //            self.viewBody.frame = companyNameFrame
        }else{
            isOpen = true
            
            UIView.animate(withDuration: 0.3) {
                var viewbodyRect: CGRect = self.viewBody.frame
                viewbodyRect.size.height = 496
                viewbodyRect.origin.y = self.view.frame.size.height - 496
                self.viewBody.frame = viewbodyRect
                var detailButton: CGRect = self.detaiTranscationButton.frame
                detailButton.size.height = 228
                self.detaiTranscationButton.frame = detailButton
                self.transactionViewDetail.isHidden = false
                //                var companyNameFrame: CGRect = self.companyNameLabel.frame
                //                companyNameFrame.origin.x = 18
                //                companyNameFrame.origin.y = 70
                //                self.companyNameLabel.frame = companyNameFrame
                //                var priceFrame: CGRect = self.priceTransactionLabel.frame
                //                priceFrame.origin.x = self.view.frame.size.width - priceFrame.size.width
                //                priceFrame.origin.y = 70
                //                self.priceTransactionLabel.frame = priceFrame
                //                var confirmationReceive: CGRect = self.confirmationRecieveLabel.frame
                //                confirmationReceive.origin.x = self.view.frame.size.width - confirmationReceive.size.width - 10
                //                confirmationReceive.origin.y = 110
                //                self.confirmationRecieveLabel.frame = confirmationReceive
                //                //make view for detail transaction
                //                var detailButton: CGRect = self.detaiTranscationButton.frame
                //                detailButton.origin.y = 140
                //                detailButton.size.height = 250
                //                self.detaiTranscationButton.frame = detailButton
                //                var transactionFrame: CGRect = self.transactionLabel.frame
                //                transactionFrame.origin.y = 160
                //                self.transactionLabel.frame = transactionFrame
                //                self.sendTitleLabel.isHidden = false
                //                self.senderLabel.isHidden = false
                //                self.receiveTitleLabel.isHidden = false
                //                self.receiverLabel.isHidden = false
                //                self.dateTitleLabel.isHidden = false
                //                self.dateLabel.isHidden = false
                //                self.transactionLabel.text = "De details"
            }
        }
        
    }
}

extension UIViewController{
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}
