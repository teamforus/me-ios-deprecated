//
//  MAPersonalViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Reachability

class MAPersonalViewController: MABaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var recordList: NSMutableArray! = NSMutableArray()
    var recordTypeList: NSMutableArray! = NSMutableArray()
    let reachablity = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if reachablity.connection != .none{
        getRecordType()
        getRecordList()
        }else {
            AlertController.showInternetUnable()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRecordType(){
        RecordTypeRequest.getRecordType(completion: { (response, statusCode) in
            if statusCode == 401{
                self.logOut()
                return
            }
            self.recordTypeList.addObjects(from: response as! [Any])
        }) { (error) in
            AlertController.showError()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail"{
            let detailPersonalVC = segue.destination as! MAPersonalDetailViewController
            detailPersonalVC.record = self.recordList[(tableView.indexPathForSelectedRow?.row)!] as! Record
        }
    }
}

extension MAPersonalViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAPersonalTableViewCell
        let record = recordList[indexPath.row] as! Record
        if record.validations.count != 0 {
            cell.validateText.isHidden = false
            cell.validationNumber.text = "\(record.validations.count)"
        }else {
            cell.validateText.isHidden = true
            cell.validationNumber.isHidden = true
        }
       
        for recordType in recordTypeList{
            if (recordType as! RecordType).key == record.key{
                cell.cellTypeLabel.text = (recordType as! RecordType).name
            }
        }
        cell.nameLabel.text = record.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
