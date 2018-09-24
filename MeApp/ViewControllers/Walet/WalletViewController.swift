//
//  WalletViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import SwipeCellKit
import CoreData
import Speech
import Reachability
enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: MABaseViewController, AppLockerDelegate{
    func closePinCodeView(typeClose: typeClose) {
        
    }
    @IBOutlet weak var profileIconImage: UIImageView!
    @IBOutlet weak var profileIcon: ShadowButton!
    let reachability = Reachability()!
    @IBOutlet weak var tableView: UITableView!
    var walletCase : WalletCase! = WalletCase.token
    @IBOutlet weak var segmentView: UIView!
    var vouhers: NSMutableArray! = NSMutableArray()
    
//    @IBOutlet weak var voiceButton: VoiceButtonView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en"))!
    @IBOutlet weak var segmentedControl: HBSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "GoogleSans-Medium", size: 14.0),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
            var appearance = ALAppearance()
            appearance.image = UIImage(named: "lock")!
            appearance.title = "Devios Ryasnoy"
            appearance.isSensorsEnabled = true
            appearance.cancelIsVissible = false
            appearance.delegate = self
            
            AppLocker.present(with: .validate, and: appearance, withController: self)
        }
        // profile icon round
       
        
            walletCase = WalletCase.passes
        
//        segmentView.layer.cornerRadius = 8.0
//        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
//        segmentedControl.items = ["Valuta", "Bezit", "Vouchers"]
//        segmentedControl.selectedIndex = 0
//        segmentedControl.font = UIFont(name: "GoogleSans-Medium", size: 14)
//        segmentedControl.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
//        segmentedControl.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
//        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
//        segmentedControl.borderColor = .clear
        tableView.keyboardDismissMode = .onDrag
        Web3Provider.getBalance()
        Service.sendContract { (response, error) in
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                UserShared.shared.currentUser = results![0]
                 UserDefaults.standard.set(UserShared.shared.currentUser.pinCode, forKey: ALConstants.kPincode)
                 UserDefaults.standard.synchronize()
            }
        } catch{}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        VoucherRequest.getVoucherList(completion: { (response, statusCode) in
            self.vouhers.removeAllObjects()
            self.vouhers.addObjects(from: response as! [Any])
            if self.vouhers.count == 0{
                self.tableView.isHidden = true
            }else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        }) { (error) in
            
        }
        
      //  ConfigRequest.getConfig(configType: "wallet", completion: { (statuCode, response) in
            
       // }) { (error) in }
    }
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
//    @objc func segmentSelected(sender:HBSegmentedControl) {
//        print("Segment at index \(sender.selectedIndex)  selected")
//        if (sender.selectedIndex == 0 ){
//            walletCase = WalletCase.token
//            self.tableView.reloadData()
//        }else if (sender.selectedIndex == 1){
//            walletCase = WalletCase.assets
//            self.tableView.reloadData()
//        }else if (sender.selectedIndex == 2){
//            walletCase = WalletCase.passes
//            self.tableView.reloadData()
//        }
//
//    }
    @IBAction func logout(_ sender: Any) {
        self.logOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToKindPaket"{
            let passVC = segue.destination as! MAGeneralPassViewController
            (passVC.contentViewController as! PassViewController).voucher = self.vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
            (passVC.bottomViewController as! MABottomVoucherViewController).voucher = self.vouhers[(self.tableView.indexPathForSelectedRow?.row)!] as? Voucher
        }else if segue.identifier == "goToProfile"{
            let profileVC = segue.destination as! MAMyProfileViewController
            (profileVC.contentViewController as! MAContentProfileViewController).isCloseButtonHide = false
        }
    }
}

// MARK: - VoiceButtonDelegate

extension WalletViewController: VoiceButtonDelegate{
    
    
    func updateSpeechText(_ text: String) {
    }
    
    func startedRecording() {
        print("")
    }
    
    func stoppedRecording() {
        print("")
    }
    
    func notifyError(_ error: String) {
        print(error)
    }
}

    // MARK: UITableViewDelegate

extension WalletViewController: UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if walletCase == .passes{
            return vouhers.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell! = nil
        
        switch walletCase {
        case .token?:
            let cellWalletSecond = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WalletSecondTableViewCell
            if indexPath.row == 0{
                cellWalletSecond.priceLabel.text = "10,509876"
                cellWalletSecond.typeCoinLabel.text = "ETH"
            } else if indexPath.row == 1{
                cellWalletSecond.priceLabel.text = "200,85"
                cellWalletSecond.typeCoinLabel.text = "BAT"
                cellWalletSecond.typeCoinImageView.image = UIImage.init(named: "bat")
            }else if indexPath.row == 2{
                cellWalletSecond.priceLabel.text = "225,57"
                cellWalletSecond.typeCoinLabel.text = "ERC-20 Token"
                cellWalletSecond.typeCoinImageView.image = UIImage.init(named: "erc")
            }
            
            cell = cellWalletSecond
            break
            
        case .assets?:
            let cellWalletOwner = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! MAWalletOwnerTableViewCell
            cellWalletOwner.delegate = self
                cellWalletOwner.headNameLabel.text = "APPARTEMENT"
                cellWalletOwner.productNameLabel.text = "Groningen"
                cellWalletOwner.marcLabel.text = "Ulgersmaweg 35, 9731BK"
    
            cell = cellWalletOwner
            break
        case .passes?:
            let cellWallet = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! MAWaletVoucherTableViewCell
//            cellWallet.delegate = self
            cellWallet.selectionStyle = .none
            let voucher = self.vouhers[indexPath.row] as! Voucher
            cellWallet.voucherTitleLabel.text = voucher.found.name
            cellWallet.priceLabel.text = "€\(voucher.amount!)"
            cellWallet.organizationNameLabel.text = voucher.found.organization.name
            cell = cellWallet
        default:
            let cellWallet = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! MAWaletVoucherTableViewCell
            cellWallet.delegate = self
            if indexPath.row == 0{
                cellWallet.voucherTitleLabel.text = "Kindpakket"
                cellWallet.priceLabel.text = "€ 122,67"
            }else if indexPath.row == 1{
                cellWallet.voucherTitleLabel.text = "Meedoen"
                cellWallet.voucherImage.image = #imageLiteral(resourceName: "Logo-Nijmgen-4-3")
            }
            cell = cellWallet
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedIndex == 1 {
//            let popOverVC = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
//            self.addChildViewController(popOverVC)
//            popOverVC.view.frame = self.view.frame
//            popOverVC.isVisisbeTabBar = true
//            self.view.addSubview(popOverVC.view)
//            popOverVC.didMove(toParentViewController: self)
            let alert: UIAlertController
            alert = UIAlertController(title: "", message: "Comming Soon!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if segmentedControl.selectedIndex == 2{
            self.performSegue(withIdentifier: "goToKindPaket", sender: self)
        }
        self.performSegue(withIdentifier: "goToKindPaket", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch walletCase {
        case .token?:
            return 130
        case .passes?:
            return 130
        default:
            break
        }
        return 142
    }
    
    
    // MARK: SwipeTableViewCellDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let transctionAction = SwipeAction(style: .default, title: "Transaction") { action, indexPath in
        }
        transctionAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        transctionAction.textColor = UIColor.lightGray
        transctionAction.image = UIImage(named: "transactionIcon")
        transctionAction.font =  UIFont(name: "SFUIText-Bold", size: 10.0)
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        }
        deleteAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        deleteAction.textColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "removeIcon")
        deleteAction.font =  UIFont(name: "SFUIText-Bold", size: 10.0)
        
        switch walletCase {
        case .token?: break
        case .assets?:
            if orientation == .right {
                return [deleteAction,transctionAction]
            }
            
        case .passes?:
            if orientation == .left {
                return [transctionAction]
            }else {
                return [deleteAction]
            }
            
        default: break
            
        }
        return nil
    }
}
