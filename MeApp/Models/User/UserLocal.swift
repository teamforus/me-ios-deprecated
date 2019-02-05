//
//  User.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import JSONCodable
import Alamofire

struct UserLocal{
    var address: String?
}

extension UserLocal: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        address = try decoder.decode("address")
    }
}

extension UserLocal: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(address, key:"address")
        })
    }
}


class IndentityRequest {

    static func requestIndentiy(completion: @escaping ((UserLocal, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "identity"), method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let idenntityAddress = try! UserLocal(object: json as! JSONObject)
                    completion(idenntityAddress, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
    
    static func sendTokenNotification(token: String ,completion: @escaping ((UserLocal, Int) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        
        Alamofire.request(BaseURL.baseURL(url: "platform/devices/register-push"), method: .post, parameters:["id": UserDefaults.standard.value(forKey: "TOKENDEVICENOTIFICATION")!] ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    let idenntityAddress = try! UserLocal(object: json as! JSONObject)
                    completion(idenntityAddress, (response.response?.statusCode)!)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }

}
