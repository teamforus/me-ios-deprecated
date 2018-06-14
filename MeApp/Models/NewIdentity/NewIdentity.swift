//
//  NewIdentity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import JSONCodable

struct NewIdentity {
    var pinCode : String?
    var type : String?
    var records: Records?
}

extension NewIdentity: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        pinCode = try decoder.decode("pin_code")
        type = try decoder.decode("type")
        type = try decoder.decode("records")
    }
}

extension NewIdentity: JSONEncodable{
    func toJSON() throws -> Any {
         return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(pinCode, key:"pin_code")
            try encoder.encode(type, key:"type")
            try encoder.encode(records, key:"records")
        })
    }
}




