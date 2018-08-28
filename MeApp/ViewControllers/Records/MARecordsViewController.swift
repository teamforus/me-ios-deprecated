//
//  MARecordsViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/22/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ExpandableCell
import BWWalkthrough

class MARecordsViewController: MABaseViewController, BWWalkthroughViewControllerDelegate {
    @IBOutlet weak var tableView: ExpandableTableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var recordList: NSMutableArray! = NSMutableArray()
    
    var cell: UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID)!
    }
    
    var titles : NSArray = ["Persoonlijk","Medisch","Zakelijk","Relaties","Certificaten","Anderen"]
    var images : NSArray = ["iconPersonal","iconMedical","iconBuissness","iconRelations","iconCertificate","iconOther"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.expandableDelegate = self
        tableView.animation = .automatic
        NotificationCenter.default.addObserver(self, selector: #selector(closePage), name: Notification.Name("CLOSESLIDEPAGE"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //        self.title = "Eigenschappen"
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.getRecordList()
        UIApplication.shared.statusBarStyle = .default
    }
    
    func getRecordList(){
        RecordsRequest.getRecordsList(completion: { (response, statusCode) in
            if statusCode == 401{
                self.logOut()
                return
            }
            self.recordList.removeAllObjects()
            self.recordList.addObjects(from: response as! [Any])
            self.tableView.reloadData()
        }) { (error) in
            AlertController.showError()
        }
    }
    
    @objc func closePage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Walkthrough delegate 
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createRecord(_ sender: Any) {
        let stb = UIStoryboard(name: "NewProfile", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "categories")
        let pageOne = stb.instantiateViewController(withIdentifier: "types")
        let pageTwo = stb.instantiateViewController(withIdentifier: "text")
        
        walkthrough.delegate = self
        walkthrough.scrollview.isScrollEnabled = false
        walkthrough.add(viewController:page_zero)
        walkthrough.add(viewController:pageOne)
        walkthrough.add(viewController:pageTwo)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
}


extension MARecordsViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        //        if indexPath.row == 2 {
        //            let cell1 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        //            cell1.titleLabel.text = "VOORNAAM"
        //            cell1.infoCategory.text = "John"
        //            let cell2 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        //            cell2.titleLabel.text = "ACHTERNAAM"
        //            cell2.infoCategory.text = "Doe"
        //            let cell3 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        //            cell3.titleLabel.text = "BSN"
        //            cell3.infoCategory.text = "45547646455"
        //            cell3.validateChekBox.image = UIImage(named: "shape2")
        //            let cell4 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        //            cell4.titleLabel.text = "E-MAIL"
        //            cell4.infoCategory.text = "john@forus.io"
        //            let cell5 = tableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) as! ExpandedCell
        //            cell5.titleLabel.text = "TELWFOONNUMMER"
        //            cell5.infoCategory.text = "+315349635"
        //            return [cell1, cell2, cell3, cell4, cell5]
        //        }
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        //        if indexPath.row == 2 {
        //            return [55, 55, 55, 55, 55]
        //        }
        return nil
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "goToNewProfile", sender: nil)
            
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "goToSwitchProfile", sender: nil)
        }else{
            let alert: UIAlertController
            alert = UIAlertController(title: "", message: "Comming Soon!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
             
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
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
            if indexPath.row == 0{
                cell.subcategoryTitle.text = "\(self.recordList.count) eigenschappen"
            }else{
                cell.subcategoryTitle.text = "0 eigenschappen"
            }
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func expandableTableView(_ expandableTableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension MARecordsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
