//
//  BaseURL.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation

class BaseURL {
    
   static func baseURL(url:String) -> String{
        return "https://api.forus.link/api/v1/\(url)"
    }
}
