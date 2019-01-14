//
//  CoreDataManager.swift
//  Me
//
//  Created by Tcacenco Daniel on 1/11/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController{
    
    func saveNewIdentity(primaryEmail: String, accessToken: String, givenName: String, familyName: String){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", primaryEmail)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(primaryEmail, forKey: "primaryEmail")
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue("", forKey: "pinCode")
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
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
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
    
    
    func getCurrentUser(primaryEmail: String!){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", primaryEmail)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
        } catch{
            
        }
    }
    
    func getCurrentUserByToken(accessToken: String!){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
            
        } catch{}
    }
    
    func getCurrentUser(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "currentUser == YES")
        do {
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                UserShared.shared.currentUser = results![0]
            }
        } catch {}
    }
    
}
