//
//  Messages.swift
//  HelloWorld
//
//  Created by Tcacenco Daniel on 6/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct  Messages{
    var id: Int
    var name: String
    var message: String
    var created_at: String
    var updated_at: String
}

extension Messages: JSONDecodable{
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        message = try decoder.decode("message")
        created_at = try decoder.decode("created_at")
        updated_at = try decoder.decode("updated_at")
    }
}

struct NewMessage{
    var name: String
    var message: String
}

extension NewMessage: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key:"name")
            try encoder.encode(message, key:"message")
        })
    }
}
