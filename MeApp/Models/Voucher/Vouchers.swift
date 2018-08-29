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
    var amount: Int!
    var found: Found!
    var transactions: Array<Transactions>!
}

extension Voucher: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = try JSONDecoder(object:object)
        foundID = try decoder.decode("found_id")
        identityAdress = try decoder.decode("identity_address")
        address = try decoder.decode("address")
        amount = try decoder.decode("amount")
        found = try decoder.decode("found")
        transactions = try decoder.decode("transactions")
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
                    if (json as AnyObject)["message"] == nil {
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
}
