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
    var valid : Bool!
}

extension Record: JSONDecodable{
     init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        value = try decoder.decode("value")
        order = try decoder.decode("order")
        key = try decoder.decode("key")
        recordCategoryId = try decoder.decode("record_category_id")
        valid = try decoder.decode("valid")
        
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
            try encoder.encode(valid, key:"valid")
        })
    }
}

class RecordsRequest {
    
    static func getRecordsList(completion: @escaping ((NSMutableArray) -> Void), failure: @escaping ((Error) -> Void)){
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
                    completion(recordList)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func createRecord(parameters: Parameters, completion: @escaping ((Record) -> Void), failure: @escaping ((Error) -> Void)){
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
                    completion(authorizeCodeResponse)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
