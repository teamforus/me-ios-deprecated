//
//  AuthorizationEmailRequest.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire
import JSONCodable

class AuthorizationEmailRequest {
    
    static func loginWithEmail(parameters: Parameters, completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/email"), method: .post, parameters:parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                if let json = response.result.value {
                    let messages = try! Response(object: json as! JSONObject)
                    print(messages)
                    completion(messages, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func authorizeEmailToken(completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/authorize/email/app.me_app/\(UserDefaults.standard.string(forKey: "access_token")!)"), method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                if let json = response.result.value {
                    let messages = try! Response(object: json as! JSONObject)
                    print(messages)
                    completion(messages, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
}
