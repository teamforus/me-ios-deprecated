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
    @IBOutlet weak var organizationLabel: UILabel!
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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        
        organizationLabel.text = voucher.found.organization.name
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
        imageQR.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address!)\" }")
        imageBodyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToQRReader)))
        imageBodyView.isUserInteractionEnabled = true
        smallerAmount.layer.cornerRadius = 9.0
        emailMeButton.layer.cornerRadius = 9.0
        
        self.tabBarController?.tabBar.isHidden = true
        let transactionsArray = NSMutableArray()
        transactionsArray.addObjects(from: voucher.transactions)
        transactionsArray.addObjects(from: voucher.productVoucher!)
        self.transactions.addObjects(from: transactionsArray.sorted(by: { ($0 as! Transactions).created_at.compare(($1 as! Transactions).created_at) == .orderedDescending}))
    }
    
    @objc func goToQRReader(){
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        
        AlertController.showAlertActions(vc: self,
                                         title: "E-mail to me".localized(),
                                         detail: "Send the voucher to your email?".localized(),
                                         cancelTitle: "Cancel".localized(),
                                         confirmTitle: "Confirm".localized())
                                         { (action) in
                                            VoucherRequest.sendEmailToVoucher(address: self.voucher.address, completion: { (statusCode) in
                                                
                                                let popupTransction = MARegistrationSuccessViewController(nibName: "MARegistrationSuccessViewController", bundle: nil)
                                                self.presenter.presentationType = .popup
                                                self.presenter.transitionType = nil
                                                self.presenter.dismissTransitionType = nil
                                                self.presenter.keyboardTranslationType = .compress
                                                self.customPresentViewController(self.presenter, viewController: popupTransction, animated: true, completion: nil)
                                            }) { (error) in }
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
        cell.transaction = self.transactions[indexPath.row] as? Transactions
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didAnimateTransactioList()
    }
}


extension PassViewController{
    func didAnimateTransactioList(){
        if self.transactions.count > 8{
            if isFirstCellVisible(){
                self.heightConstraint.constant = 322
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }else{
                self.heightConstraint.constant = 60
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func isFirstCellVisible() -> Bool{
        let indexes = tableView.indexPathsForVisibleRows
        for indexPath in indexes!{
            if indexPath.row == 0{
                return true
            }
        }
        return false
    }
}
