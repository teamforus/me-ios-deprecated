//
//  MAChooseTypeViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import BWWalkthrough

class MAChooseTypeViewController: UIViewController, BWWalkthroughPage, MAChooseTypeTableViewCellDelegate {
    
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var tableView: UITableView!
    var recordTypeList: NSMutableArray! = NSMutableArray()
    var selectedCell : NSMutableArray!
    var previousIndex: Int!
    var previousCell: MAChooseTypeTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategory), name: Notification.Name("SETSELECTEDCATEGORY"), object: nil)
        getRecordType()
    }
    
    func getRecordType(){
        RecordTypeRequest.getRecordType(completion: { (response) in
            self.recordTypeList.addObjects(from: response as! [Any])
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    @objc func setSelectedCategory(){
        if let recordCategory = UserDefaults.standard.value(forKey: "category") as? NSData {
            let category = try? PropertyListDecoder().decode(RecordCategory.self, from: recordCategory as Data)
            selectedCategory.setTitle(category?.name, for: .normal)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
       
    }
    
    func chooseType(cell: MAChooseTypeTableViewCell) {
        if previousCell != nil {
            previousCell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            previousCell.checkBox.isSelected = false
        }
        if previousCell != cell {
            cell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            cell.checkBox.isSelected = true
        }
        previousCell = cell
        let recordType = recordTypeList[cell.tag] as! RecordType
        UserDefaults.standard.set(try? PropertyListEncoder().encode(recordType), forKey: "type")
        NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
    }
    
    @IBAction func selectType(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORYTYPE"), object: nil)
    }
}

extension MAChooseTypeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAChooseTypeTableViewCell
        let recordType = recordTypeList[indexPath.row] as! RecordType
        cell.titleRecordType.text = recordType.name
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
