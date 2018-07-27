//
//  RecordCategory.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct RecordCategory: Codable {
    var id : Int?
    var name : String?
    var order : Int?
}

extension RecordCategory: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        order = try decoder.decode("order")
    }
}

extension RecordCategory: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(id, key:"id")
            try encoder.encode(name, key:"name")
            try encoder.encode(order, key:"order")
        })
    }
}

class RecordCategoryRequest {
    
    static func getRecordCategory(completion: @escaping ((NSMutableArray) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "access_token")!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/record-categories"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let recordTypeList: NSMutableArray = NSMutableArray()
                    if (json as AnyObject).count != 0{
                        for recordTypeItem in json as! Array<Any>{
                            let recordType = try! RecordCategory(object: recordTypeItem as! JSONObject)
                            recordTypeList.add(recordType)
                        }
                    }
                    completion(recordTypeList)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func createRecordCategory(completion: @escaping ((Response) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: "access_token")!)"
        ]
        
        let parameter: Parameters = ["order": 1,
                                     "name": "Personal"]
        
        Alamofire.request(BaseURL.baseURL(url: "identity/record-categories"), method: .post, parameters:parameter ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let authorizeCodeResponse = try! Response(object: json as! JSONObject)
                    completion(authorizeCodeResponse)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
}
