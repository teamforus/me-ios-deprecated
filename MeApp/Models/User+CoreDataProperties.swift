//
//  User+CoreDataProperties.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/28/18.
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
    @NSManaged public var image: NSData?
    @NSManaged public var lastName: String?
    @NSManaged public var pinCode: String?
    @NSManaged public var primaryEmail: String?

}
