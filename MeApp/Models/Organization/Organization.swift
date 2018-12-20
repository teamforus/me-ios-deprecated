//
//  Organization.swift
//  Me
//
//  Created by Tcacenco Daniel on 12/18/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Organization{
    var id : Int?
    var organizationId : Int?
    var identityAddress : String?
    var name: String?
    var iban: String?
    var email: String?
    var phone: String?
    var kvk: String?
    var logo: Logo?
    var btw: String?
    var permissions: Array<String>?
    var productCategories: Array<ProductCategory>?
    
}

extension Organization: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        organizationId = try decoder.decode("organization_id")
        identityAddress = try decoder.decode("identity_address")
        name = try decoder.decode("name")
        iban = try decoder.decode("iban")
        email = try decoder.decode("email")
        phone = try decoder.decode("phone")
        kvk = try decoder.decode("kvk")
        logo = try decoder.decode("logo")
        btw = try decoder.decode("btw")
        permissions = try decoder.decode("permissions")
        productCategories = try decoder.decode("product_categories")
    }
}

extension Organization: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key:"id")
            try encoder.encode(organizationId, key:"organization_id")
            try encoder.encode(identityAddress, key:"identity_address")
            try encoder.encode(name, key:"name")
            try encoder.encode(iban, key:"iban")
            try encoder.encode(email, key:"email")
            try encoder.encode(phone, key:"phone")
            try encoder.encode(kvk, key:"kvk")
            try encoder.encode(btw, key:"btw")
            try encoder.encode(btw, key:"logo")
            try encoder.encode(permissions, key:"permissions")
        })
    }
}

class OrganizationRequest{
    
    static func reqeustOrganizations(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/organizations"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if (json as AnyObject)["message"]! == nil {
                        let voucherList: NSMutableArray = NSMutableArray()
                        if (json as AnyObject).count != 0 {
                            for voucherItem in (json as AnyObject)["data"] as! Array<Any>{
                                let voucher = try! Organization(object: voucherItem as! JSONObject)
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
