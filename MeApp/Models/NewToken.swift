//
//  NewToken.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/6/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//
import TrustCore

import Foundation

class NewToken{
    
    func addToken(address:Address ,name:String, symbol:String, decimals:Int){
        let token = ERC20Token(
            contract: address,
            name: name,
            symbol: symbol,
            decimals: decimals
        )
    }
}
