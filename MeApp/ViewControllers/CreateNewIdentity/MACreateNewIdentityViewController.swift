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
import SwiftMessages
import CoreData
import IQKeyboardManagerSwift

class MACreateNewIdentityViewController: MABaseViewController {
    @IBOutlet weak var validateIcon: UIImageView!
    @IBOutlet weak var emailSkyFloatingTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var givenNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var familyNameField: SkyFloatingLabelTextField!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveNewIdentity(accessToken: String, pinCode: Int16){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", emailSkyFloatingTextField.text!)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(self.emailSkyFloatingTextField.text, forKey: "primaryEmail")
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(pinCode, forKey: "pinCode")
                newUser.setValue(accessToken, forKey: "accessToken")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func updateOldIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                results![0].setValue(false, forKey: "currentUser")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func getCurrentUser(primaryEmai: String!){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", emailSkyFloatingTextField.text!)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
          
        } catch{
            
        }
    }
    
    @IBAction func create(_ sender: Any) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!){
            if Validation.validateFieldEmpty(textField: givenNameField) || Validation.validateFieldEmpty(textField: familyNameField) {
            let emailObject = ["primary_email" : emailSkyFloatingTextField.text,
                               "family_name" : familyNameField.text,
                               "given_name" : givenNameField.text]
            let parameters: Parameters = ["pin_code" : "2460",
                                          "records" : emailObject]
            RequestNewIndetity.createnewIndentity(parameters: parameters,
                                                  completion: { (response) in
                                                    if response.errors == nil {
                                                        self.saveNewIdentity(accessToken: response.accessToken, pinCode: 2460)
                                                        self.updateOldIndentity()
                                                        self.getCurrentUser(primaryEmai: self.emailSkyFloatingTextField.text)
                                                        RecordCategoryRequest.createRecordCategory(completion: { (response) in
                                                            
                                                        }) { (error) in
                                                            
                                                        }
                                                        if UserDefaults.standard.string(forKey: ALConstants.kPincode) != "" && UserDefaults.standard.string(forKey: ALConstants.kPincode) != nil{
                                                        self.performSegue(withIdentifier: "goToWalet", sender: self)
                                                        }else{
                                                        self.performSegue(withIdentifier: "goToPassword", sender: self)
                                                        }
                                                    }else {
                                                        let error = MessageView.viewFromNib(layout: .tabView)
                                                        error.configureTheme(.error)
                                                        error.configureContent(title: "Invalid data", body: response.errors?.recordMessage != nil ? response.errors?.recordMessage.first : "Email already is used" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                                                            SwiftMessages.hide()
                                                        }
                                                        error.button?.setTitle("OK", for: .normal)
                                                        
                                                        SwiftMessages.show( view: error)
                                                    }
                                                    
            }, failure: { (error) in
                let error = MessageView.viewFromNib(layout: .tabView)
                error.configureTheme(.error)
                error.configureContent(title: "Invalid email", body: "Something go wrong, please try again!", iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                    SwiftMessages.hide()
                }
                error.button?.setTitle("OK", for: .normal)
                
                SwiftMessages.show( view: error)
            })
            }
        }
    }
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        if Validation.validateEmail(emailSkyFloatingTextField.text!){
            validateIcon.isHidden = false
            emailSkyFloatingTextField.errorMessage = nil
        }else{
            validateIcon.isHidden = true
            emailSkyFloatingTextField.errorMessage = "Email is not valid"
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
