//
//  MAValidatorsViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/23/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class MAValidatorsViewController: MABaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var validators: NSMutableArray! = NSMutableArray()
    var recordType: String!
    var recordValue: String!
    var recordCategoryId: Int!
    var recordID: Int!
    @IBOutlet weak var categoryName: ShadowButton!
    @IBOutlet weak var recordTypeName: ShadowButton!
    @IBOutlet weak var valueRecord: ShadowButton!
    @IBOutlet weak var categoryNameLabel: UILabel!
    let reachablity = Reachability()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTypeName.setTitle(recordType, for: .normal)
        valueRecord.setTitle(recordValue, for: .normal)
        if reachablity.connection != .none{
        if recordCategoryId != nil{
            RecordCategoryRequest.getCategory(categoryId: recordCategoryId, completion: { (response, statusCode) in
                self.categoryNameLabel.text = response.name
            }) { (error) in
                AlertController.showError()
            }
        }else{
             self.categoryNameLabel.text = "Persoonlijk"
        }
        }else{
            AlertController.showInternetUnable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if reachablity.connection != .none{
            ValidatorsRequest.getValidatorList(completion: { (response, statusCode) in
                self.validators.addObjects(from: response as! [Any])
                self.tableView.reloadData()
            }) { (error) in
                AlertController.showError()
            }
        }else {
            AlertController.showInternetUnable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension MAValidatorsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.validators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAValidatorCellTableViewCell
        let validator = validators[indexPath.row] as! Validator
        
        cell.nameValidator.text = validator.organization?.name
        cell.descriptionValidator.text = validator.organization?.identityAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reachablity.connection != .none{
            let validator = validators[indexPath.row] as! Validator
            let parametr: Parameters = ["validator_id" : validator.id!,
                                        "record_id" : recordID!]
            ValidatorsRequest.createValidationRequest(parameters: parametr, completion: { (response, statusCode) in
                if response.message != nil{
                    AlertController.showWarning(withText: "Sorry request to validate is already send")
                }else{
                    AlertController.showSuccess(withText: "")
                }
            }) { (error) in
                
            }
        }else {
            AlertController.showInternetUnable()
        }
    }
}
