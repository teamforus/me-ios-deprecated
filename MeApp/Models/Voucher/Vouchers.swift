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
    var amount: String!
    var createdAtLocale: String!
    var createdAt: String!
    var found: Found!
    var transactions: Array<Transactions>!
    var allowedOrganizations: Array<AllowedOrganizations>?
    var allowedProductCategories: Array<AllowedProductCategories>?
    var allowedProducts: Array<AllowedProducts>?
    var product: ProductVoucher?
    var productVoucher: Array<Transactions>?
    var offices: Array<Office>?
    var expireAt: ExpireAt?
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
        createdAtLocale = try decoder.decode("created_at_locale")
        createdAt = try decoder.decode("created_at")
        productVoucher = try decoder.decode("product_vouchers")
        offices = try decoder.decode("offices")
        expireAt = try decoder.decode("expire_at")
    }
}

struct Office {
    var id: Int!
    var address: String!
    var phone: String?
    var lon: String!
    var organization: Organization!
    var lat: String?
    var photo: Logo!
}

extension Office: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        address = try decoder.decode("address")
        phone = try decoder.decode("phone")
        lon = try decoder.decode("lon")
        lat = try decoder.decode("lat")
        photo = try decoder.decode("photo")
        organization = try decoder.decode("organization")
    }
}

struct AllowedOrganizations {
    var id: Int!
    var name: String!
    var logo: Logo!
}

extension AllowedOrganizations: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        logo = try decoder.decode("logo")
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
    var price: String!
    var oldPrice: Int!
    var totalAmount: Int!
    var soldAmount: Int!
    var organization: AllowedOrganizations!
    var organizationId: Int!
    var productCategoryId: Int!
    var photo: Logo?
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

struct ExpireAt {
    var date: String?
    var timeZone: String?
}

extension ExpireAt: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        date = try decoder.decode("date")
        timeZone = try decoder.decode("timezone")
    }
}

class VoucherRequest {
    
    static func getVoucherList(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        DispatchQueue.global(qos: .userInteractive).async {
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
//                                    Date.dateFormaterFromServer(date: voucher.expireAt?.date)
                                    
//                                    let expriderDate: Date! = date.dateFormaterFromServer(date: voucher.expireAt?.date)
                                    if Date().dateFormaterFromServer(dateString: voucher.expireAt?.date ?? "") >= Date(){
                                    voucherList.add(voucher)
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                completion(voucherList, (response.response?.statusCode)!)
                            }
                        }
                        
                    }
                    break
                case .failure(let error):
                    
                    failure(error)
                }
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
                    
                    if (json as AnyObject).count != 0 && (json as AnyObject).count != 5 {
                        if response.response?.statusCode == 200{
                            transaction = try! Voucher(object: (json as AnyObject)["data"] as! JSONObject)
                            completion(transaction, (response.response?.statusCode)!)
                        }else{
                            completion(Voucher(), (response.response?.statusCode)!)
                        }
                    }else{
                        completion(Voucher(), (response.response?.statusCode)!)
                    }
                }
                
                
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func sendEmailToVoucher(address: String,completion: @escaping (( Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers/"+address+"//send-email"), method: .post, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    completion((response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func testRequest(){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request("http://xyz.hcn.one:9500/test.php", method: .post, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
               
                break
            case .failure(let error): break
                
            }
        }
    }
}
