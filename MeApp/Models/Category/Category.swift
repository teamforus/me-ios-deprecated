//
//  Category.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import ObjectMapper

class Category: Mappable {
    var id : NSNumber?
    var name : String?
    var order : NSNumber?
    
    required init?(map: Map) {}
    
     func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.order <- map["order"]
    }
}
