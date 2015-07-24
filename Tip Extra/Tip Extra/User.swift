//
//  User.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/23/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var userID: NSNumber
    var firstName: String
    var lastName: String
    var email: String
    var authToken: String
    var brainTreeID: String
    
    convenience override init() {
        self.init(userDict: ["": ""])
    }
    
    init(userDict: [String: AnyObject]) {
        self.userID = userDict[Utils.kIDKey] as! NSNumber
        self.firstName = userDict[Utils.kFirstNameKey] as! String
        self.lastName = userDict[Utils.kLastNameKey] as! String
        self.email = userDict[Utils.kEmailKey] as! String
        self.authToken = userDict[Utils.kAuthTokenKey] as! String
        self.brainTreeID = userDict[Utils.kBraintreeIDKey] as! String
        super.init()
    }
}
