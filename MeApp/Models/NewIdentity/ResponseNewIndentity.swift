//
//  ResponseNewIndentity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import ObjectMapper

class Response: Mappable {
    var message : String?
    var errors : Erros?
    var records: Records?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
    
}

class Erros: Mappable {
    var recordMessage : [String]!
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.recordMessage <- map["email"]
    }
}
