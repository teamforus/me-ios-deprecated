//
//  Record.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Record{
    var id : Int!
    var value : String!
    var order : Int!
    var key : String!
    var recordCategoryId : Int!
    var validations : [Validations]!
}

extension Record: JSONDecodable{
     init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        value = try decoder.decode("value")
        order = try decoder.decode("order")
        key = try decoder.decode("key")
        recordCategoryId = try decoder.decode("record_category_id")
        validations = try decoder.decode("validations")
        
    }
}

extension Record: JSONEncodable{
    func toJSON() throws -> Any {
         return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key:"id")
            try encoder.encode(value, key:"value")
            try encoder.encode(order, key:"order")
            try encoder.encode(key, key:"key")
            try encoder.encode(recordCategoryId, key:"record_category_id")
            try encoder.encode(validations, key:"validations")
        })
    }
}

struct Validations{
    var identityAddress : String!
    var state : String!
}

extension Validations: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        identityAddress = try decoder.decode("identity_address")
        state = try decoder.decode("state")
        
    }
}

extension Validations: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(identityAddress, key:"identity_address")
            try encoder.encode(state, key:"state")
        })
    }
}

struct RecordValidation{
    var state : String!
    var identityAddress : String!
    var uuid : String!
    var value : String!
    var key : String!
    var name : String!
}

extension RecordValidation: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        state = try decoder.decode("state")
        identityAddress = try decoder.decode("identity_address")
        uuid = try decoder.decode("uuid")
        value = try decoder.decode("value")
        key = try decoder.decode("key")
        name = try decoder.decode("name")
        
    }
}

extension RecordValidation: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(state, key:"state")
            try encoder.encode(identityAddress, key:"identity_address")
            try encoder.encode(uuid, key:"uuid")
            try encoder.encode(value, key:"value")
            try encoder.encode(key, key:"key")
            try encoder.encode(name, key:"name")
        })
    }
}

class RecordsRequest {
    
    static func getRecordsList(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/records"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let recordList: NSMutableArray = NSMutableArray()
                    if (json as AnyObject).count != 0{
                        for recordItem in json as! Array<Any>{
                             let record = try! Record(object: recordItem as! JSONObject)
                            recordList.add(record)
                        }
                    }
                    completion(recordList,(response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func createRecord(parameters: Parameters, completion: @escaping ((Record, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity/records"), method: .post, parameters:parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let authorizeCodeResponse = try! Record(object: json as! JSONObject)
                    completion(authorizeCodeResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func createValidationTokenRecord(parameters: Parameters, completion: @escaping ((RecordValidation, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity/record-validations"), method: .post, parameters:parameters ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let authorizeCodeResponse = try! RecordValidation(object: json as! JSONObject)
                    completion(authorizeCodeResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func readValidationTokenRecord(token: String, completion: @escaping ((RecordValidation, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity/record-validations/\(token)"), method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let authorizeCodeResponse = try! RecordValidation(object: json as! JSONObject)
                    completion(authorizeCodeResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func aproveValidationTokenRecord(token: String, completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity/record-validations/\(token)/approve"), method: .patch, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let authorizeCodeResponse = try! Response(object: json as! JSONObject)
                    completion(authorizeCodeResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func deleteRecord(recordId: Int, completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity/records/\(recordId)"), method: .delete, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let deleteResponse = try! Response(object: json as! JSONObject)
                    completion(deleteResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
