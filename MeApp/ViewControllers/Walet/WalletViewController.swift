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
import Speech
enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: MABaseViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var walletCase : WalletCase! = WalletCase.token
    
//    @IBOutlet weak var voiceButton: VoiceButtonView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ro"))!
    @IBOutlet weak var segmentedControl: HBSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "SFProText-Bold", size: 13.0),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        segmentedControl.items = ["WEEKLY", "MONTHLY", "YEARLY"]
        segmentedControl.selectedIndex = 0
        segmentedControl.font = UIFont(name: "Avenir-Black", size: 12)
//        segmentedControl.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmentedControl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        tableView.keyboardDismissMode = .onDrag
        Web3Provider.getBalance()
        Service.sendContract { (response, error) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func segmentSelected(sender:HBSegmentedControl) {
        print("Segment at index \(sender.selectedIndex)  selected")
        if (sender.selectedIndex == 0 ){
            walletCase = WalletCase.token
        }else if (sender.selectedIndex == 1){
            walletCase = WalletCase.assets
        }else if (sender.selectedIndex == 2){
            walletCase = WalletCase.passes
        }
        self.tableView.reloadData()
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell! = nil
        
        switch walletCase {
        case .token:
            let cellWalletSecond = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WalletSecondTableViewCell
            cell = cellWalletSecond
            break
            
        case .assets:
            let cellWalletOwner = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! MAWalletOwnerTableViewCell
            cellWalletOwner.delegate = self
            cell = cellWalletOwner
            
        default:
            let cellWallet = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! MAWalletOwnerTableViewCell
            cellWallet.delegate = self
            
            if indexPath.row == 0 {
//                cellWallet.titleWalteCategory.text = "Kindpakket"
            }else if indexPath.row == 1 {
//                cellWallet.titleWalteCategory.text = "Bike"
            }else if indexPath.row == 2 {
//                cellWallet.titleWalteCategory.text = "Kindpakket"
            }
            
            cell = cellWallet
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedIndex == 1 {
            let popupTransction =  TransactionViewController(nibName: "TransactionViewController", bundle: nil)
            dynamicSizePresenter.presentationType = .bottomHalf
            customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
        }else if segmentedControl.selectedIndex == 2{
            self.performSegue(withIdentifier: "goToKindPaket", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch walletCase {
        case .token:
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
        case .token: break
        case .assets:
            if orientation == .right {
                return [deleteAction,transctionAction]
            }
            
        case .passes:
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
