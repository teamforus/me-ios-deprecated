//
//  MACreatePasswordViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/17/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Reachability

class MACreatePasswordViewController: UIViewController {
    var primaryEmail: String!
    var givenName: String!
    var familyName: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachability = Reachability()!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func skip(_ sender: Any) {
        
        if reachability.connection != .none{
            let emailObject = ["primary_email" : primaryEmail,
                               "family_name" : familyName,
                               "given_name" : givenName]
            let parameters: Parameters = ["pin_code" : "1111",
                                          "records" : emailObject]
            RequestNewIndetity.createnewIndentity(parameters: parameters,
                                                  completion: { (response, statusCode) in
                                                    if statusCode == 401 {
                                                        
                                                    }
                                                    if response.errors == nil && response.accessToken != nil{
                                                        self.updateOldIndentity()
                                                        self.saveNewIdentity(primaryEmail: self.primaryEmail, accessToken: response.accessToken, givenName: self.givenName, familyName: self.familyName)
                                                        self.getCurrentUser(primaryEmail: self.primaryEmail)
                                                        RecordCategoryRequest.createRecordCategory(completion: { (response, statusCode) in
                                                            
                                                        }) { (error) in
                                                            
                                                        }
                                                        UserDefaults.standard.set(false, forKey: "PINCODEENABLED")
                                                        UserDefaults.standard.set("", forKey: ALConstants.kPincode)
                                                        self.performSegue(withIdentifier: "goToWalet", sender: self)
                                                    }else {
                                                        AlertController.showWarning(withText: "This email is already used".localized(), vc: self)
                                                    }
                                                    
            }, failure: { (error) in
                AlertController.showWarning(withText: "Something went wrong, please try again…".localized(), vc: self)
            })
        }else{
            AlertController.showInternetUnable(vc: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPassword"{
        let creatPassVC = segue.destination as! MAPsswordEnableViewController
        creatPassVC.primaryEmail = primaryEmail
        creatPassVC.givenName = givenName
        creatPassVC.familyName = familyName
        }
    }

}
