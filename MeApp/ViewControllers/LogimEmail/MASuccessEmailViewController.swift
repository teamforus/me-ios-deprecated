//
//  MASuccessEmailViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/27/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import CoreData

class MASuccessEmailViewController: MABaseViewController, AppLockerDelegate {
    
    
    var timer : Timer! = Timer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var email: String!
    var accessToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NSNotification.Name(rawValue: "authorizeToken"),
            object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        let mailURL = NSURL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.open(mailURL as URL, options: [:],
                                      completionHandler: {
                                        (success) in }) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func authorizeToken(notifcation: Notification){
        AuthorizationEmailRequest.authorizeEmailToken(token: notifcation.userInfo?["authToken"] as! String, completion: { (response, statusCode) in
            if response.accessToken != nil {
                self.updateOldIndentity()
                self.saveNewIdentity(accessToken: response.accessToken, email: self.email)
                self.getCurrentUserByToken(accessToken: response.accessToken)
                self.performSegue(withIdentifier: "goToWalet", sender: nil)
            }else{
                AlertController.showWarning(withText: "Please try to send email again.".localized(), vc: self)
            }
        }) { (error) in }
    }
    
    func saveNewIdentity(accessToken: String, email: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", email)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(accessToken, forKey: "accessToken")
                newUser.setValue(UserDefaults.standard.string(forKey: ALConstants.kPincode), forKey: "pinCode")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }else{
                results![0].setValue(accessToken, forKey: "accessToken")
                results![0].setValue(true, forKey: "currentUser")
                results![0].setValue(UserDefaults.standard.string(forKey: ALConstants.kPincode), forKey: "pinCode")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{}
    }
    
    func closePinCodeView(typeClose: typeClose) {}
    
    @IBAction func cancel(_ sender: Any) {
        UserDefaults.standard.setValue("", forKeyPath: "auth_token")
        self.dismiss(animated: true, completion: nil)
    }
}
