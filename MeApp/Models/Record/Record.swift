//
//  Record.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import ObjectMapper

class Record: Mappable {
    var id : NSNumber?
    var value : String?
    var order : NSNumber?
    var key : String?
    var recordCategoryId : NSNumber?
    var valid : Bool?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.value <- map["value"]
        self.order <- map["order"]
        self.key <- map["key"]
        self.recordCategoryId <- map["record_category_id"]
        self.valid <- map["valid"]
    }
}
