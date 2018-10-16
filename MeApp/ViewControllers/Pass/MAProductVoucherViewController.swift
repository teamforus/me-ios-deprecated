//
//  MAProductVoucherViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 10/15/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Presentr
import SafariServices

class MAProductVoucherViewController: MABaseViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var timAvailabelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var voucher: Voucher!
    var transactions: NSMutableArray! = NSMutableArray()
    @IBOutlet weak var kindPaketQRView: UIView!
    @IBOutlet weak var imageQR: UIImageView!
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.voucherTitleLabel.text = voucher.product?.name
        self.priceLabel.text = "€\(voucher.amount!)"
        self.timAvailabelLabel.text = voucher.product?.organization.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.getTransaction()
    }
    
    func getTransaction(){
        TransactionVoucherRequest.getTransaction(identityAdress: voucher.address, completion: { (transactions, statusCode) in
            self.transactions.removeAllObjects()
            self.transactions.addObjects(from: transactions.sorted(by: { ($0 as! Transactions).created_at.compare(($1 as! Transactions).created_at) == .orderedDescending}))
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        let popupTransction =  MAEmailForMeViewController(nibName: "MAEmailForMeViewController", bundle: nil)
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func showInfo(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.zuidhorn.nl/kindpakket")!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
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

extension MAProductVoucherViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassTableViewCell
        let transaction = self.transactions[indexPath.row] as! Transactions
        cell.companyTitle.text = transaction.organization.name
        cell.priceLabel.text = "-\(transaction.amount!)"
        cell.dateLabel.text = transaction.created_at.dateFormaterNormalDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popOverVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        popOverVC.transaction = self.transactions[indexPath.row] as? Transactions
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
