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
    var amount: String!
    var adress: String!
    var organization: Organization!
    var product: Product!
    var created_at: String!
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
        created_at = try decoder.decode("created_at")
        
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
    
    
    static func getTransaction(identityAdress: String,completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers/\(identityAdress)/transactions"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                var _: Transactions!
                if let json = response.result.value {
                    if (json as AnyObject)["message"]! == nil {
                        let voucherList: NSMutableArray = NSMutableArray()
                        if (json as AnyObject).count != 0 {
                            for voucherItem in (json as AnyObject)["data"] as! Array<Any>{
                                let voucher = try! Transactions(object: voucherItem as! JSONObject)
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
    
    
    static func makeTransaction(parameters: Parameters,identityAdress: String,completion: @escaping ((Transactions, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/vouchers/"+identityAdress+"/transactions"), method: .post, parameters:parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                var transaction: Transactions! = Transactions()
                if let json = response.result.value {
                    
                    if (json as AnyObject)["message"]! == nil{
                        transaction = try! Transactions(object: (json as AnyObject)["data"] as! JSONObject)
                    }else{
//                        AlertController.showWarning(withText: (json as AnyObject)["message"] as! String, vc: self)
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
