//
//  User+CoreDataProperties.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/17/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var currentUser: Bool
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var pinCode: Int32
    @NSManaged public var primaryEmail: String?
    @NSManaged public var image: NSData?

}
