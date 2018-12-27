//
//  MACreateNewIdentityViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import CoreData
import IQKeyboardManagerSwift
import Reachability

class MACreateNewIdentityViewController: MABaseViewController {
    @IBOutlet weak var validateIcon: UIImageView!
    @IBOutlet weak var emailSkyFloatingTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var validateIcon2: UIImageView!
    @IBOutlet weak var confirmEmailField: SkyFloatingLabelTextField!
    @IBOutlet weak var givenNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var familyNameField: SkyFloatingLabelTextField!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachablity = Reachability()!
    @IBOutlet weak var registerUIButton: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        confirmEmailField.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func create(_ sender: Any) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!) && confirmEmailField.text == emailSkyFloatingTextField.text{
            if Validation.validateFieldEmpty(textField: givenNameField) || Validation.validateFieldEmpty(textField: familyNameField) {
                if reachablity.connection != .none{
                    let emailObject = ["primary_email" : emailSkyFloatingTextField.text,
                                       "family_name" : familyNameField.text,
                                       "given_name" : givenNameField.text]
                    let parameters: Parameters = ["pin_code" : "1111",
                                                  "records" : emailObject]
                    RequestNewIndetity.createnewIndentity(parameters: parameters,
                                                          completion: { (response, statusCode) in
                                                            if statusCode == 401 {
                                                                
                                                            }
                                                            if response.errors == nil && response.accessToken != nil{
                                                                self.updateOldIndentity()
                                                                self.saveNewIdentity(accessToken: response.accessToken)
                                                                self.getCurrentUser(primaryEmai: self.emailSkyFloatingTextField.text)
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
                }else {
                    AlertController.showInternetUnable(vc: self)
                }
            }
        }
    }
    
    // MARK: - CoreDataManaged
    
    func saveNewIdentity(accessToken: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", emailSkyFloatingTextField.text!)
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(emailSkyFloatingTextField.text, forKey: "primaryEmail")
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue("", forKey: "pinCode")
                newUser.setValue(accessToken, forKey: "accessToken")
                newUser.setValue(givenNameField.text, forKey: "firstName")
                newUser.setValue(familyNameField.text, forKey: "lastName")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{}
    }
    
    func updateOldIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(false, forKey: "currentUser")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{}
    }
    
    func getCurrentUser(primaryEmai: String!){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", emailSkyFloatingTextField.text!)
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
        } catch{}
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if textField == emailSkyFloatingTextField{
            if Validation.validateEmail(emailSkyFloatingTextField.text!){
                validateIcon.isHidden = false
//                emailSkyFloatingTextField.errorMessage = nil
                confirmEmailField.isEnabled = true
            }else{
                validateIcon.isHidden = true
//                emailSkyFloatingTextField.errorMessage = "Email is not valid"
                confirmEmailField.isEnabled = false
            }
        }else if textField == confirmEmailField{
            if confirmEmailField.text == emailSkyFloatingTextField.text{
                validateIcon.isHidden = false
                validateIcon2.isHidden = false
//                confirmEmailField.errorMessage = nil
                registerUIButton.isEnabled = true
                registerUIButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
            }else{
                validateIcon.isHidden = true
                validateIcon2.isHidden = true
                registerUIButton.isEnabled = false
                registerUIButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPassword"{
            let creatPassVC = segue.destination as! MACreatePasswordViewController
            creatPassVC.primaryEmail = emailSkyFloatingTextField.text
            creatPassVC.givenName = givenNameField.text
            creatPassVC.familyName = familyNameField.text
        }
    }
    
    
}
