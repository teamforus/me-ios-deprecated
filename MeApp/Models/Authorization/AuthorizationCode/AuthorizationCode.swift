//
//  AuthorizationCode.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/26/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Code {
    var accessTokenCode: String!
    var authCode: Int!
    var exchange_token: Int!
}

extension Code: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        accessTokenCode = try decoder.decode("access_token")
        authCode = try decoder.decode("auth_code")
    }
}

extension Code: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(accessTokenCode, key:"access_token")
            try encoder.encode(authCode, key:"auth_code")
            try encoder.encode(authCode, key:"exchange_token")
        })
    }
}

class AuthorizationCodeRequest{
    static func createAuthorizationCode(completion: @escaping ((Code, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/code"), method: .post, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let codeResponse = try! Code(object: json as! JSONObject)
                    completion(codeResponse, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func authorizeCode(completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        let parameter: Parameters = ["auth_code" : UserDefaults.standard.integer(forKey: "auth_code")]
        
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/authorize/code"), method: .post, parameters:parameter ,encoding: JSONEncoding.default, headers: headers).responseJSON {
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
}
