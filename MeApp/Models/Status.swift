//
//  Status.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 8/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire

struct Status {
    static func checkStatus(accessToken: String,completion: @escaping ((Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(accessToken)"
        ]
        
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/check-token?access_token=\(accessToken)"), method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if response.result.value != nil {
                    completion((response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
