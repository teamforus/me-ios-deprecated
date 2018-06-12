//
//  Token.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct Authorization {
    var accessToken : String?
    var success : Bool?
    var authenticationCode : NSNumber?
    var message : String?
    var error: Error?
    
//    required init?(map: Map) {}
//    
//     func mapping(map: Map) {
//        self.accessToken <- map["access_token"]
//        self.success <- map["success"]
//        self.authenticationCode <- map["auth_code"]
//        self.message <- map["message"]
//        self.error <- map["errors"]
//    }
}

extension Authorization: JSONDecodable{
    init(object: JSONObject) throws {
        
    }
}

