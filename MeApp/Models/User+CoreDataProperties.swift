//
//  User+CoreDataProperties.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var pinCode: Int32
    @NSManaged public var primaryEmail: String?
    @NSManaged public var currentUser: Bool

}
