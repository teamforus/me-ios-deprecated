//
//  RequestNewIndetity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire
import JSONCodable

class RequestNewIndetity{
    
    static func createnewIndentity(newIndeity: NewIdentity){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity"), method: .post, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                if let json = response.result.value {
                    let messages = try! Response(object: json as! JSONObject)
                    print(messages)
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}
