//
//  Validator.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/17/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Validators {
    var id : Int?
    var validatorId : Int?
    var recordValidationUid : String?
    var identityAddress : String?
    var recordId : Int?
    var state : String?
    var validator : Validator?
    var message: String!
 
}

extension Validators: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        validatorId = try decoder.decode("validator_id")
        recordValidationUid = try decoder.decode("record_validation_uid")
        identityAddress = try decoder.decode("identity_address")
        recordId = try decoder.decode("record_id")
        state = try decoder.decode("state")
        validator = try decoder.decode("validator")
        message = try decoder.decode("message")
    }
}

extension Validators: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key:"id")
            try encoder.encode(validatorId, key:"validator_id")
            try encoder.encode(recordValidationUid, key:"record_validation_uid")
            try encoder.encode(identityAddress, key:"identity_address")
            try encoder.encode(recordId, key:"record_id")
            try encoder.encode(state, key:"state")
            try encoder.encode(validator, key:"validator")
        })
    }
}

struct Validator{
    var id : Int?
    var organizationId : Int?
    var identityAddress : String?
    var organization: Organization?
}

extension Validator: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        organizationId = try decoder.decode("organization_id")
        identityAddress = try decoder.decode("identity_address")
        organization = try decoder.decode("organization")
    }
}

extension Validator: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key:"id")
            try encoder.encode(organizationId, key:"organization_id")
            try encoder.encode(identityAddress, key:"identity_address")
            try encoder.encode(organization, key:"organization")
        })
    }
}

struct Organization{
    var id : Int?
    var organizationId : Int?
    var identityAddress : String?
    var name: String?
    var iban: String?
    var email: String?
    var phone: String?
    var kvk: String?
    var btw: String?
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
        btw = try decoder.decode("btw")
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
        })
    }
}

class ValidatorsRequest {

    static func getValidatorList(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/validators"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let recordList: NSMutableArray = NSMutableArray()
                    if (json as AnyObject).count != 0 {
                        for recordItem in (json as AnyObject)["data"] as! Array<Any>{
                            let record = try! Validator(object: recordItem as! JSONObject)
                            recordList.add(record)
                        }
                    }
                    completion(recordList, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func createValidationRequest(parameters: Parameters, completion: @escaping ((Validators, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "platform/validator-requests"), method: .post, parameters:parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                   
                    if (json as AnyObject)["data"]! != nil {
                    let authorizeCodeResponse = try! Validators(object: (json as AnyObject)["data"]  as! JSONObject)
                        completion(authorizeCodeResponse, (response.response?.statusCode)!)
                    }else {
                       let authorizeCodeResponse = try! Validators(object: json  as! JSONObject)
                        completion(authorizeCodeResponse, (response.response?.statusCode)!)
                    }
                    
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }

}


