//
//  Found.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/28/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable

struct Found{
    var id: Int!
    var name: String!
    var state: String!
    var organization: Organization!
    var productCategories: Array<ProductCategory>!
    var logo: Logo!
}

extension Found: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        state = try decoder.decode("state")
        organization = try decoder.decode("organization")
        productCategories = try decoder.decode("product_categories")
        logo = try decoder.decode("logo")
        
    }
}

struct ProductCategory {
    var id: Int!
    var key: String!
    var name: String!
}

extension ProductCategory: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        key = try decoder.decode("key")
        name = try decoder.decode("name")
    }
}
