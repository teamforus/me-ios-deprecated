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
import Reachability
import LocalAuthentication

class MAPsswordEnableViewController: UIViewController, AppLockerDelegate {
    @IBOutlet weak var headLabel: UILabel!
    var primaryEmail: String!
    var givenName: String!
    var familyName: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachability = Reachability()!
    @IBOutlet weak var faceIDButton: ShadowButton!
    
    var appLocker: AppLocker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !faceIDAvailable(){
            headLabel.text = "Wil je inloggen met Touch ID"
            faceIDButton.setTitle("GEBRUIK TOUCH ID", for: .normal)
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
        appearance.title = NSLocalizedString("Login code", comment: "")
        appearance.subtitle = NSLocalizedString("Enter your login code to use Face ID", comment: "")
        appearance.isSensorsEnabled = true
        appearance.cancelIsVissible = false
        appearance.delegate = self
        
        AppLocker.present(with: .create, and: appearance, withController: self)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isWithTouchID")
        UserDefaults.standard.synchronize()
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = NSLocalizedString("Login code", comment: "")
        appearance.subtitle = NSLocalizedString("Enter a new login code", comment: "")
        appearance.isSensorsEnabled = true
        appearance.cancelIsVissible = false
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
                                                                
                                                            }) { (error) in }
                                                            self.performSegue(withIdentifier: "goToWalet", sender: self)
                                                        }else {
                                                            AlertController.showWarning(withText: NSLocalizedString("This email is already used", comment: ""), vc: self)
                                                        }
                                                        
                }, failure: { (error) in
                    AlertController.showWarning(withText: NSLocalizedString("Something went wrong, please try again…", comment: ""), vc: self)
                })
            }else{
                AlertController.showInternetUnable(vc: self)
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
