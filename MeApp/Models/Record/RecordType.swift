//
//  RecordType.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct RecordType: Codable {
    var key: String!
    var type: String!
    var name: String!
}


extension RecordType: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        key = try decoder.decode("key")
        type = try decoder.decode("type")
        name = try decoder.decode("name")
    }
}

extension RecordType: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(key, key:"key")
            try encoder.encode(type, key:"type")
            try encoder.encode(name, key:"name")
        })
    }
}


class RecordTypeRequest {
    
    static func getRecordType(completion: @escaping ((NSMutableArray, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/record-types"), method: .get, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let recordTypeList: NSMutableArray = NSMutableArray()
                    if (json as AnyObject).count != 0{
                        if json is Array<Any>{
                        for recordTypeItem in json as! Array<Any>{
                            let recordType = try! RecordType(object: recordTypeItem as! JSONObject)
                            recordTypeList.add(recordType)
                        }
                             }
                    }
                    completion(recordTypeList, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
