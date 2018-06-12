//
//  Records.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import JSONCodable

struct Records {
    var email : String?
}

extension Records: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        email = try decoder.decode("email")
    }
}

extension Records: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(email, key:"email")
        })
    }
}
