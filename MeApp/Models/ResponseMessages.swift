//
//  ResponseMessages.swift
//  HelloWorld
//
//  Created by Tcacenco Daniel on 6/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct ResponseMessage{
    var messages: [Messages]?
    var ipfs: Bool?
    var blockChain: Bool?
}

extension ResponseMessage: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        messages = try decoder.decode("db")
        ipfs = try decoder.decode("ipfs")
        blockChain = try decoder.decode("blockChain")
    }
}

