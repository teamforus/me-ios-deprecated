//
//  ResponseNewIndentity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct Response{
    var message : String!
    var errors : Errors!
    var records: Records!
    var accessToken: String!
    var success: Bool!
}

extension Response: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        message = try decoder.decode("message")
        errors = try decoder.decode("errors")
        records = try decoder.decode("records")
        accessToken = try decoder.decode("access_token")
        success = try decoder.decode("success")
    }
}




