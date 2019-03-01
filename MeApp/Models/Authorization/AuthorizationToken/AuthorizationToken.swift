//
//  AuthorizationToken.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/30/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire
import JSONCodable

struct AuthorizeToken : Codable {
    var accessToken: String!
    var authToken: String!
}

extension AuthorizeToken: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        accessToken = try decoder.decode("access_token")
        authToken = try decoder.decode("auth_token")
    }
}

extension AuthorizeToken: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(accessToken, key:"access_token")
            try encoder.encode(authToken, key:"auth_token")
        })
    }
}

class AuthorizeTokenRequest {
    
    static func createToken(completion: @escaping ((AuthorizeToken, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/token"), method: .post, parameters:nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let responses = try! AuthorizeToken(object: json as! JSONObject)
                    completion(responses, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func authorizeToken(parameter: Parameters, completion: @escaping ((Response, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity/proxy/authorize/token"), method: .post, parameters:parameter, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let responses = try! Response(object: json as! JSONObject)
                    completion(responses, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func removeToken(parameter: Parameters, completion: @escaping (( Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        Alamofire.request(BaseURL.baseURL(url: "platform/devices/delete-push"), method: .delete, parameters:parameter, encoding: JSONEncoding.default, headers: headers).responseData {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    
                    completion((response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}


