//
//  OnebankClient.swift
//  OneFillSim
//
//  Created by RogerZ on 10/08/2016.
//  Copyright © 2016 MaxwellForest. All rights reserved.
//

import Foundation
import SwiftyJSON

class OnebankClient: IACClient {
    override init() {
        super.init(URLScheme: clientURLSchemeText)
    }
    
    func pushLoginInformation(userLoginData: UserLoginInfo?) {
        var userInfo = [String:String]()
        
        if userLoginData != nil {
            userInfo["userData"] = "HasValue"
            userInfo["token"] = userLoginData!.token
            userInfo["userID"] = userLoginData!.user.id
        } else {
            userInfo["userData"] = "Empty"
        }
        
        super.performAction("authenticationFromOnefill", parameters: userInfo, onSuccess: {
            result in
            print("OnebankClient->pushLoginInformation success info: \(result)")
            
            }, onFailure: {
                error in
                print("OnebankClient->pushLoginInformation fail info: \(error.localizedDescription)")
        })
    }
}