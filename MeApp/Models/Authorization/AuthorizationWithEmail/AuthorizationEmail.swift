//
//  AuthorizationEmailResponse.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct AuthorizationEmail{
    var email : String?
    var source : String?
}

extension AuthorizationEmail: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        email = try decoder.decode("primary_email")
        source = try decoder.decode("source")
    }
}

extension AuthorizationEmail: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(email, key:"primary_email")
            try encoder.encode(source, key:"source")
        })
    }
}
