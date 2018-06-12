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
    var authenticationCode : Int?
    var message : String?
    var errors: Errors?
    
}

extension Authorization: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        accessToken = try decoder.decode("access_token")
        success = try decoder.decode("success")
        authenticationCode = try decoder.decode("auth_code")
        message = try decoder.decode("message")
        errors = try decoder.decode("errors")
        
    }
}

struct Errors{
    var recordMessage : [String]!
}

extension Errors: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        recordMessage = try decoder.decode("email")
    }
}
