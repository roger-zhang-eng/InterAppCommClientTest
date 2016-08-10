//
//  LoginModule.swift
//  OneBank
//
//  Created by RogerZ on 5/08/2016.
//  Copyright © 2016 MaxwellForest. All rights reserved.
//

import Foundation

struct UserProfile {
    var firstName: String
    var lastName: String
    var email: String
}

struct UserInfo {
    var id: String
    var profile: UserProfile
    var accounts: [String : String]
    var addresses: [String : String]
}

struct UserLoginInfo {
    var token: String
    var user: UserInfo
}

struct LoginModule {
    var code: String
    var with: [String]
}

struct RequestPinModule {
    var uuid: String
}
