//
//  Vouchers.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/28/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Voucher {
    var foundID: Int!
    var identityAdress: String!
    var address: String!
    var amount: Float!
    var found: Found!
    var transactions: Array<Transactions>!
    var allowedOrganizations: Array<AllowedOrganizations>?
    var allowedProductCategories: Array<AllowedProductCategories>?
    var allowedProducts: Array<AllowedProducts>?
    var product: ProductVoucher?
}

extension Voucher: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        foundID = try decoder.decode("found_id")
        identityAdress = try decoder.decode("identity_address")
        address = try decoder.decode("address")
        amount = try decoder.decode("amount")
        found = try decoder.decode("fund")
        transactions = try decoder.decode("transactions")
        allowedOrganizations = try decoder.decode("allowed_organizations")
        allowedProductCategories = try decoder.decode("allowed_product_categories")
        allowedProducts = try decoder.decode("allowed_products")
        product = try decoder.decode("product")
    }
}

struct AllowedOrganizations {
    var id: Int!
    var name: String!
}

extension AllowedOrganizations: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
    }
}

struct AllowedProducts {
    var id: Int!
    var name: String!
    var description: String!
    var price: Int!
    var oldPrice: Int!
    var totalAmount: Int!
    var soldAmount: Int!
}

extension AllowedProducts: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        description = try decoder.decode("description")
        price = try decoder.decode("price")
        oldPrice = try decoder.decode("old_price")
        totalAmount = try decoder.decode("total_amount")
        soldAmount = try decoder.decode("sold_amounts")
    }
}

struct ProductVoucher {
    var id: Int!
    var name: String!
    var description: String!
    var price: Double!
    var oldPrice: Int!
    var totalAmount: Int!
    var soldAmount: Int!
    var organization: AllowedOrganizations!
    var organizationId: Int!
    var productCategoryId: Int!
    var photo: String!
}

extension ProductVoucher: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        description = try decoder.decode("description")
        price = try decoder.decode("price")
        oldPrice = try decoder.decode("old_price")
        totalAmount = try decoder.decode("total_amount")
        soldAmount = try decoder.decode("sold_amounts")
        organization = try decoder.decode("organization")
        organizationId = try decoder.decode("organization_id")
        productCategoryId = try decoder.decode("product_category_id")
        photo = try decoder.decode("photo")
    }
}

struct AllowedProductCategories {
    var id: Int!
    var name: String!
    var key: String!
}

extension AllowedProductCategories: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        key = try decoder.decode("key")
    }
}

class VoucherRequest {
    
    static func getVoucherList(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if (json as AnyObject)["message"]! == nil {
                        let voucherList: NSMutableArray = NSMutableArray()
                        if (json as AnyObject).count != 0 {
                            for voucherItem in (json as AnyObject)["data"] as! Array<Any>{
                                let voucher = try! Voucher(object: voucherItem as! JSONObject)
                                voucherList.add(voucher)
                            }
                        }
                        completion(voucherList, (response.response?.statusCode)!)
                    }
                    
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func getProvider(identityAdress: String,completion: @escaping ((Voucher, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers/"+identityAdress+"/provider"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                var transaction: Voucher!
                if let json = response.result.value {
                    
                    if (json as AnyObject).count != 0 {
                        transaction = try! Voucher(object: (json as AnyObject)["data"] as! JSONObject)
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
