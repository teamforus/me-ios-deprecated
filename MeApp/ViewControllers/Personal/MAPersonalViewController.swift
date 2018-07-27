//
//  MAPersonalViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAPersonalViewController: MABaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var recordList: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecordList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRecordList(){
        RecordsRequest.getRecordsList(completion: { (response) in
            self.recordList.addObjects(from: response as! [Any])
            self.tableView.reloadData()
        }) { (error) in
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
        if record.valid != nil {
            cell.validateText.isHidden = false
        }else {
            cell.validateText.isHidden = true
        }
        if record.key == "primary_email"{
            cell.cellTypeLabel.text = "Primary E-mail"
            cell.nameLabel.text = record.value
        }else if record.key == "family_name"{
             cell.cellTypeLabel.text = "Family name"
            cell.nameLabel.text = record.value
        }else if record.key == "telephone"{
            cell.cellTypeLabel.text = "Phone Number"
            cell.nameLabel.text = record.value
        }else if record.key == "given_name"{
            cell.cellTypeLabel.text = "Given Name"
            cell.nameLabel.text = record.value
        }else if record.key == "gender"{
            cell.cellTypeLabel.text = "Gender"
            cell.nameLabel.text = record.value
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
