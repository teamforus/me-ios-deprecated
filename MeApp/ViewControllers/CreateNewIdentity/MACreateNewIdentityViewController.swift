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
                newUser.setValue(givenNameField.text, forKey: "firstName")
                newUser.setValue(familyNameField.text, forKey: "lastName")
                
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
            if results?.count != 0 {
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
                self.performSegue(withIdentifier: "goToPassword", sender: self)
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
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
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
