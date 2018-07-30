//
//  UserShared.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/30/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation


final class UserShared {
    
    private init() { }
    
    static let shared = UserShared()
    var currentUser: User = User()
    
}
