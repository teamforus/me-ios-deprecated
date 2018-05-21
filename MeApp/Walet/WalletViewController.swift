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

class WalletViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, SwipeTableViewCellDelegate{
   
    
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    let largerRedTextSelectAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                                         NSAttributedStringKey.foregroundColor: UIColor.white]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: "Tokens", image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: "Assets", image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: "Passes", image: nil, at: 2)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes, for: .normal)
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentContentColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        
        
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
    }

    
    // MARK: UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaletTableViewCell
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.titleWalteCategory.text = "Kindpakket"
        }else if indexPath.row == 1 {
            cell.titleWalteCategory.text = "Bike"
        }else if indexPath.row == 2 {
            cell.titleWalteCategory.text = "Kindpakket"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            
            let transctionAction = SwipeAction(style: .default, title: "Transaction") { action, indexPath in
            }
          
            transctionAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
            transctionAction.textColor = UIColor.lightGray
            transctionAction.image = UIImage(named: "transactionIcon")
            return [transctionAction]
        }else {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
        
        // customize the action appearance
        deleteAction.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        deleteAction.textColor = UIColor.lightGray
        deleteAction.image = UIImage(named: "removeIcon")
        
        return [deleteAction]
        }
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
