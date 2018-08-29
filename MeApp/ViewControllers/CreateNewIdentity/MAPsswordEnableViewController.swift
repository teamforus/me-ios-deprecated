//
//  MAPsswordEnableViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftMessages
import Reachability
import LocalAuthentication

class MAPsswordEnableViewController: UIViewController, AppLockerDelegate {
    @IBOutlet weak var headLabel: UILabel!
    var primaryEmail: String!
    var givenName: String!
    var familyName: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachability = Reachability()!
    
    var appLocker: AppLocker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !faceIDAvailable(){
            headLabel.text = "Would you like to log in with Tocuh ID?"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    @IBAction func createPasscode(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isWithTouchID")
        UserDefaults.standard.synchronize()
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Create passcode"
        appearance.subtitle = "Your passcode is required \n to enable Face ID"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .create, and: appearance, withController: self)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isWithTouchID")
        UserDefaults.standard.synchronize()
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Create passcode"
        appearance.subtitle = "Your passcode is required"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .create, and: appearance, withController: self)
    }
    
    func closePinCodeView(typeClose: typeClose) {
        switch typeClose {
        case .cancel:
            performSegue(withIdentifier: "goToWalet", sender: self)
            break
        case .create:
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
                                                            self.saveNewIdentity(accessToken: response.accessToken, pinCode:UserDefaults.standard.string(forKey: ALConstants.kPincode)!)
                                                            self.getCurrentUser(primaryEmai: self.primaryEmail)
                                                            RecordCategoryRequest.createRecordCategory(completion: { (response, statusCode) in
                                                                
                                                            }) { (error) in
                                                                
                                                            }
                                                            self.performSegue(withIdentifier: "goToWalet", sender: self)
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
            }else{
                AlertController.showInternetUnable()
            }
            break
        default:
            break
        }
    }
    
    // MARK: - CoreDataManaged
    
    func saveNewIdentity(accessToken: String, pinCode: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", primaryEmail)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(primaryEmail, forKey: "primaryEmail")
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(pinCode, forKey: "pinCode")
                newUser.setValue(accessToken, forKey: "accessToken")
                newUser.setValue(givenName, forKey: "firstName")
                newUser.setValue(familyName, forKey: "lastName")
                
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
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", primaryEmail)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
            
        } catch{
            
        }
    }
    
}
