//
//  Transaction.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/28/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Transactions {
    var organizationId: Int!
    var productId: Int!
    var amount: Int!
    var adress: String!
    var organization: Organization!
    var product: Product!
}

extension Transactions: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        organizationId = try decoder.decode("organization_id")
        productId = try decoder.decode("product_id")
        amount = try decoder.decode("amount")
        adress = try decoder.decode("adress")
        organization = try decoder.decode("organization")
        product = try decoder.decode("product")
        
    }
}

struct Product{
    var id: Int!
    var organizationId: Int!
    var productCategoryId: Int!
    var name: String!
    var description: String!
    var price: Int!
    var oldPrice: Int!
    var totalAmount: Int!
    var soldAmount: Int!
    var photo: Logo!
    var productCategory: ProductCategory!
}

extension Product: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder =  JSONDecoder(object:object)
        organizationId = try decoder.decode("organization_id")
        id = try decoder.decode("id")
        productCategoryId = try decoder.decode("product_category_id")
        name = try decoder.decode("name")
        description = try decoder.decode("description")
        price = try decoder.decode("price")
        oldPrice = try decoder.decode("oldPrice")
        totalAmount = try decoder.decode("totalAmount")
        soldAmount = try decoder.decode("soldAmount")
        photo = try decoder.decode("photo")
        productCategory = try decoder.decode("product_category")
        
    }
}

class TransactionVoucherRequest {
    
    
    static func getTransaction(identityAdress: String,completion: @escaping ((Transactions, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers/\(identityAdress)/transactions"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                var transaction: Transactions!
                if let json = response.result.value {
                    
                    if (json as AnyObject).count != 0 {
                             transaction = try! Transactions(object: (json as AnyObject) as! JSONObject)
                        }
                    }
                    completion(transaction, (response.response?.statusCode)!)
                
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
