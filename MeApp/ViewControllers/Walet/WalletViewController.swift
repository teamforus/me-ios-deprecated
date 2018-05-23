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
enum WalletCase {
    case token
    case assets
    case passes
}

class WalletViewController: UIViewController{
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var walletCase : WalletCase! = WalletCase.token
    
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont(name: "SFProText-Bold", size: 13.0),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Valuta", image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: "Bezit", image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: "Vouchers", image: nil, at: 2)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes as Any as? [NSAttributedStringKey : Any], for: .normal)
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentContentColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        searchField.attributedPlaceholder = colorPlaceholder(text: "Zoek valuta")
    }
    
    func colorPlaceholder(text: String) -> NSAttributedString {
         return NSAttributedString(string: text ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
    self.view.endEditing(true)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        if (sender.selectedSegmentIndex == 0 ){
            walletCase = WalletCase.token
        }else if (sender.selectedSegmentIndex == 1){
            walletCase = WalletCase.assets
        }else if (sender.selectedSegmentIndex == 2){
            walletCase = WalletCase.passes
        }
        self.tableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        case .passes:
            let cellWalletSecond = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! WalletSecondTableViewCell
            
            cell = cellWalletSecond
        default:
            let cellWallet = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaletTableViewCell
            cellWallet.delegate = self
            
            if indexPath.row == 0 {
                cellWallet.titleWalteCategory.text = "Kindpakket"
            }else if indexPath.row == 1 {
                cellWallet.titleWalteCategory.text = "Bike"
            }else if indexPath.row == 2 {
                cellWallet.titleWalteCategory.text = "Kindpakket"
            }
            
            cell = cellWallet
        }
        return cell
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
        case .token:
            if orientation == .left {
                return [transctionAction]
            }else {
                return [deleteAction]
            }
            
        case .assets:
            if orientation == .right {
                return [deleteAction,transctionAction]
            }
            
        case .passes: break
        default: break
            
        }
        return nil
    }
}
