//
//  Category.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct Category {
    var id : Int?
    var name : String?
    var order : Int?
}

extension Category: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        order = try decoder.decode("order")
    }
}

extension Category: JSONEncodable{
    func toJSON() throws -> Any {
         return try JSONEncoder.create({ (encoder) -> Void in
           try encoder.encode(id, key:"id")
           try encoder.encode(name, key:"name")
            try encoder.encode(order, key:"order")
        })
    }
}
