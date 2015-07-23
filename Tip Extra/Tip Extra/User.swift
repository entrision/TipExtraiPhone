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
        self.init(userID: 0, firstName: "", lastName: "", email: "", authToken: "", brainTreeID: "")
    }
    
    init(userID: NSNumber, firstName: String, lastName: String, email: String, authToken: String, brainTreeID: String) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.authToken = authToken
        self.brainTreeID = brainTreeID
        super.init()
    }
}
