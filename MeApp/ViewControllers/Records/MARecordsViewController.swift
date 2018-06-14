//
//  MARecordsViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ExpandableCell

class MARecordsViewController: UIViewController {
    @IBOutlet weak var tableView: ExpandableTableView!
    
    var cell: UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
    }
    
    var titles : NSArray = ["Nieuwe","Persoonlijk","Medisch","Zakelijk","Relaties","Certificaten","Other"]
    var images : NSArray = ["iconNotes","iconPersonal","iconMedical","iconBuissness","iconRelations","iconCertificate","iconOther"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.expandableDelegate = self
        tableView.animation = .automatic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension MARecordsViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        if indexPath.row == 1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell1.titleLabel.text = "VOORNAAM"
            cell1.infoCategory.text = "John"
            let cell2 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell2.titleLabel.text = "ACHTERNAAM"
            cell2.infoCategory.text = "Doe"
            let cell3 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell3.titleLabel.text = "BSN"
            cell3.infoCategory.text = "45547646455"
            cell3.validateChekBox.image = UIImage(named: "shape2")
            let cell4 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell4.titleLabel.text = "E-MAIL"
            cell4.infoCategory.text = "john@forus.io"
            let cell5 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
            cell5.titleLabel.text = "TELWFOONNUMMER"
            cell5.infoCategory.text = "+315349635"
            return [cell1, cell2, cell3, cell4, cell5]
        }
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        if indexPath.row == 1 {
            return [55, 55, 55, 55, 55]
        }
        return nil
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "goToNewProfile", sender: nil)
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
                print("didSelectExpandedRowAt:\(indexPath)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? ExpandedCell {
            print("\(cell.titleLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = expandableTableView.dequeueReusableCell(withIdentifier:"cell") as! MARecordsTableViewCell
            cell.titleCategory.text = titles.object(at: indexPath.row) as? String
            cell.categoryIcon.image = UIImage(named: images.object(at: indexPath.row) as! String)
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
