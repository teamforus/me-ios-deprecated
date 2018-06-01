//
//  NewIdentity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ObjectMapper

class NewIdentity: Mappable {
    var pinCode : String?
    var type : String?
    var records: Records?
    
    init(pinCode:String, type:String, records: Records) {
        self.pinCode = pinCode
        self.type = type
        self.records = records
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.pinCode <- map["pin_code"]
        self.type <- map["type"]
        self.records <- map["records"]
    }
    
}


