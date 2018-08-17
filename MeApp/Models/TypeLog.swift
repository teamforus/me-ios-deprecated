//
//  TypeLog.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/17/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable


struct TypeLog{
    var type: String!
    var value: String!
}


extension TypeLog: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        type = try decoder.decode("type")
        value = try decoder.decode("value")
    }
}

extension TypeLog: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(type, key:"type")
            try encoder.encode(value, key:"value")
        })
    }
}
