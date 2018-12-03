//
//  PassViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr
import SafariServices
import MarqueeLabel

class PassViewController: MABaseViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var voiceButton: VoiceButtonView!
    var voucher: Voucher!
    @IBOutlet weak var kindPaketQRView: UIView!
    @IBOutlet weak var emailMeButton: UIButton!
    @IBOutlet weak var smallerAmount: UIButton!
    @IBOutlet weak var qrView: UIView!
    var transactions: NSMutableArray! = NSMutableArray()
    var gestureRecognizer: UIGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var voucherTitleLabel: MarqueeLabel!
    @IBOutlet weak var timAvailabelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageBodyView: UIImageView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if voucher.found.url_webshop == nil {
            self.smallerAmount.isHidden = true
        }
        self.voucherTitleLabel.text = voucher.found.name
        self.priceLabel.text = "€ " + voucher.amount
        dateCreatedLabel.text = voucher.createdAt.dateFormaterNormalDate()
        kindPaketQRView.layer.cornerRadius = 9.0
        imageBodyView.layer.shadowColor = UIColor.black.cgColor
        imageBodyView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageBodyView.layer.shadowOpacity = 0.1
        imageBodyView.layer.shadowRadius = 10.0
        imageBodyView.clipsToBounds = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToQRReader))
        imageQR.isUserInteractionEnabled = true
        imageQR.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(voucher.address!)\" }")
        imageQR.addGestureRecognizer(tapGestureRecognizer)
        smallerAmount.layer.cornerRadius = 9.0
        emailMeButton.layer.cornerRadius = 9.0
    }
    
    
    @objc func goToQRReader(){
        //        self.tabBarController?.selectedIndex = 1
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        let transactionsArray = NSMutableArray()
        transactionsArray.addObjects(from: voucher.transactions)
        transactionsArray.addObjects(from: voucher.productVoucher!)
        self.transactions.addObjects(from: transactionsArray.sorted(by: { ($0 as! Transactions).created_at.compare(($1 as! Transactions).created_at) == .orderedDescending}))
        
        
    }
    
//    func getTransaction(){
//        TransactionVoucherRequest.getTransaction(identityAdress: voucher.address, completion: { (transactions, statusCode) in
//            self.transactions.removeAllObjects()
//            self.transactions.addObjects(from: transactions.sorted(by: { ($0 as! Transactions).created_at.compare(($1 as! Transactions).created_at) == .orderedDescending}))
//            if self.transactions.count == 0 {
//                self.tableView.isHidden = true
//            }
//            self.tableView.reloadData()
//        }) { (error) in
//
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        VoucherRequest.sendEmailToVoucher(address: voucher.address, completion: { (statusCode) in
            let popupTransction =  MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
            self.presenter.presentationType = .popup
            self.presenter.transitionType = nil
            self.presenter.dismissTransitionType = nil
            self.presenter.keyboardTranslationType = .compress
            self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
        }) { (error) in
            
        }
    }
    
    @IBAction func showAmmount(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: voucher.found.url_webshop!)!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
}

// MARK: - UITableViewDelegate
extension PassViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassTableViewCell
        let transaction = self.transactions[indexPath.row] as! Transactions
        
        if transaction.product != nil {
            cell.statusTransfer.text = "Product voucher".localized()
            cell.companyTitle.text = transaction.product?.name
            if transaction.product?.photo != nil {
                cell.imageTransfer.sd_setImage(with: URL(string: transaction.product?.photo.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }else{
                cell.imageTransfer.image = UIImage(named: "Resting")
            }
        }else{
                cell.statusTransfer.text = "Transaction".localized()
                cell.companyTitle.text = transaction.organization.name
            if transaction.organization.logo != nil {
                cell.imageTransfer.sd_setImage(with: URL(string: transaction.organization.logo?.sizes.thumbnail ?? ""), placeholderImage: UIImage(named: "Resting"))
            }else{
                cell.imageTransfer.image = UIImage(named: "Resting")
            }
        }
            cell.priceLabel.text = "- \(transaction.amount!)"
            cell.dateLabel.text = transaction.created_at.dateFormaterNormalDate()

    
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let popOverVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        //        popOverVC.transaction = self.transactions[indexPath.row] as? Transactions
        //        self.addChildViewController(popOverVC)
        //        popOverVC.view.frame = self.view.frame
        //        self.view.addSubview(popOverVC.view)
        //        popOverVC.didMove(toParentViewController: self)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
}

