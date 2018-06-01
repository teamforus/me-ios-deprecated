//
//  AuthorizationEmailRequest.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class AuthorizationEmailRequest {
    
    static func atuhorizeEmail(email: AuthorizationEmail){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/email"), method: .post, parameters: email.toJSON(),encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                let newIdentityResponse = Mapper<Authorization>().map(JSONObject:response.result.value)
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}
