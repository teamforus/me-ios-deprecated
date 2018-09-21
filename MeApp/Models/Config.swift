//
//  Config.swift
//  Me
//
//  Created by Tcacenco Daniel on 9/21/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import Foundation
import JSONCodable
import Alamofire

struct Config{
    var wallet: WalletConfig!
    var records: WalletConfig!
    var recordCategories: WalletConfig!
}

extension Config: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        wallet = try decoder.decode("wallet")
        records = try decoder.decode("records")
        recordCategories = try decoder.decode("record_categories")
    }
}

struct WalletConfig{
    var tokens: Bool!
    var assets: Bool!
    var vouchers: Bool!
}

extension WalletConfig: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        tokens = try decoder.decode("tokens")
        assets = try decoder.decode("assets")
        vouchers = try decoder.decode("vouchers")
    }
}

struct RecordsConfig{
    var list: Bool!
    var show: Bool!
    var create: Bool!
    var update: Bool!
    var delete: Bool!
}

extension RecordsConfig: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        list = try decoder.decode("list")
        show = try decoder.decode("show")
        create = try decoder.decode("create")
        update = try decoder.decode("update")
        delete = try decoder.decode("delete")
    }
}

struct RecordCategoriesConfig{
    var list: Bool!
    var show: Bool!
    var create: Bool!
    var update: Bool!
    var delete: Bool!
}

extension RecordCategoriesConfig: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        list = try decoder.decode("list")
        show = try decoder.decode("show")
        create = try decoder.decode("create")
        update = try decoder.decode("update")
        delete = try decoder.decode("delete")
    }
}

class ConfigRequest{
    
    static func getConfig(configType: String,completion: @escaping ((Int, String) -> Void), failure: @escaping ((Error) -> Void)){
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization" : "Bearer \(UserShared.shared.currentUser.accessToken!)"
        ]
        
        Alamofire.request(BaseURL.baseURL(url: "platform/config/ios?ver="+configType), method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if response.result.value != nil {
                    completion((response.response?.statusCode)!,(response.result.value as AnyObject)["message"] as! String)
                }
                break
            case .failure(let error):
                
                failure(error)
            }
        }
    }
}
