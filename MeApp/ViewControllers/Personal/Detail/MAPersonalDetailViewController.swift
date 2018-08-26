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

class MAPersonalDetailViewController: MABaseViewController {
    @IBOutlet weak var nameCategory: UILabel!
    var record: Record!
    @IBOutlet weak var valueRecord: UILabel!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    let reachablity = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        validationLabel.isHidden = true
        if record.key == "primary_email"{
            nameCategory.text = "Primary E-mail"
            valueRecord.text = record.value
        }else if record.key == "email"{
            nameCategory.text = "E-mail"
            valueRecord.text = record.value
        }else if record.key == "family_name"{
            nameCategory.text = "Family name"
            valueRecord.text = record.value
        }else if record.key == "telephone"{
            nameCategory.text = "Phone Number"
            valueRecord.text = record.value
        }else if record.key == "given_name"{
            nameCategory.text = "Given Name"
            valueRecord.text = record.value
        }else if record.key == "gender"{
            nameCategory.text = "Gender"
            valueRecord.text = record.value
        }else if record.key == "children_nth"{
            nameCategory.text = "Children"
            valueRecord.text = record.value
        }else if record.key == "tax_id"{
            nameCategory.text = "Tax ID"
            valueRecord.text = record.value
        }else if record.key == "birth_date"{
            nameCategory.text = "Birth date"
            valueRecord.text = record.value
        }else if record.key == "spouse"{
            nameCategory.text = "Birth date"
            valueRecord.text = record.value
        }else if record.key == "net_worth"{
            nameCategory.text = "Net worth"
            valueRecord.text = record.value
        }else if record.key == "base_salary"{
            nameCategory.text = "Base salary"
            valueRecord.text = record.value
        }else if record.key == "bsn"{
            nameCategory.text = "BSN"
            valueRecord.text = record.value
        }else if record.key == "kindpakket_2018_eligible"{
            nameCategory.text = "Kindpakket Eligible"
            valueRecord.text = record.value
        }
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
