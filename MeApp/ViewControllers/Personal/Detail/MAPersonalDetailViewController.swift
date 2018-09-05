//
//  MAPersonalDetailViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/30/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class MAPersonalDetailViewController: MABaseViewController{
    @IBOutlet weak var nameCategory: UILabel!
    var record: Record!
    var validators: NSMutableArray! = NSMutableArray()
    var validatorRequests: NSMutableArray! = NSMutableArray()
    var recordTypeList: NSMutableArray! = NSMutableArray()
    @IBOutlet weak var valueRecord: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    let reachablity = Reachability()!
    @IBOutlet weak var tableView: UITableView!
    var sectionNumber: Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        validationLabel.isHidden = true
        for recordType in recordTypeList{
            if (recordType as! RecordType).key == record.key{
                nameCategory.text = (recordType as! RecordType).name
            }
        }
        valueRecord.text = record.value
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if record.validations.count == 0{
            self.tableView.isHidden = true
        }else{
             self.tableView.isHidden = false
        }
//        if reachablity.connection != .none{
//            ValidatorsRequest.getValidatorRequestList(uuid:record.completion: { (response, statusCode) in
//                self.validatorRequests.removeAllObjects()
//                self.validatorRequests.addObjects(from: response as! [Any])
//                if response.count != 0{
//                    self.tableView.isHidden = false
//                }else {
//                    self.tableView.isHidden = true
//                }
//                self.tableView.reloadData()
//
//            }) { (error) in
//                AlertController.showError()
//            }
//        }else {
//            AlertController.showInternetUnable()
//        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func deleteRecord(_ sender: Any) {
        if  reachablity.connection != .none{
            RecordsRequest.deleteRecord(recordId: record.id, completion: { (response, statusCode) in
                if statusCode == 401{
                    self.logOut()
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                AlertController.showError()
            }
        }else{
            AlertController.showInternetUnable()
        }
    }
    
    @IBAction func addFavorite(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToValidators" {
            let validatorsVC = segue.destination as! MAValidatorsViewController
            validatorsVC.recordType =  nameCategory.text
            validatorsVC.recordValue = valueRecord.text
            validatorsVC.recordCategoryId = record.recordCategoryId
            validatorsVC.recordID = record.id
        }
    }
    
    
    @IBAction func showQR(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("togleStateWindow"), object: nil)
    }
    
}

extension MAPersonalDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.validations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Peer-top-peer validations"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MAValidatorCellTableViewCell
        let validator = record.validations[indexPath.row] 
        cell.nameValidator.text = validator.identityAddress
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if reachablity.connection != .none{
//            let validator = record.validations[indexPath.row]
//            let parametr: Parameters = ["validator_id" : validator.id!,
//                                        "record_id" : record.id!]
//            ValidatorsRequest.createValidationRequest(parameters: parametr, completion: { (response, statusCode) in
//                if response.message != nil{
//                    AlertController.showWarning(withText: "Sorry request to validate is already send")
//                }else{
//                    AlertController.showSuccess(withText: "")
//                }
//            }) { (error) in
//
//            }
//        }else {
//            AlertController.showInternetUnable()
//        }
//    }
}
