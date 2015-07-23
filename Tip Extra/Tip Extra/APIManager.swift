//
//  APIManager.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/21/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    static var theUser: User?
    
    static let kBaseURL = "http://104.236.73.241/api/v1/"
    
    class func createUser(userDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
     
        let url = kBaseURL + "users"
        Alamofire.request(.POST, url, parameters: userDict, encoding: .JSON)
        .responseJSON { (request, response, JSON, error) -> Void in
            
            if error != nil {
                failure(error: error)
            } else {
                
                println(JSON)
                
                var status = 0
                let jsonDict = JSON as! NSDictionary
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    
                    status = Utils.kFailureStatus
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    for dict in errorDict {
                        //TODO: Implement
                    }
                    
                } else {
                    
                    status = Utils.kSuccessStatus
                    let userDict = jsonDict.objectForKey("user") as! NSDictionary
                    let userID = userDict.objectForKey("id") as! NSNumber
                    let first_name = userDict.objectForKey(Utils.kFirstNameKey) as! String
                    let last_name = userDict.objectForKey(Utils.kLastNameKey) as! String
                    let email = userDict.objectForKey(Utils.kEmailKey) as! String
                    let authToken = userDict.objectForKey("authentication_token") as! String
                    let brainTreeID = userDict.objectForKey("braintree_customer_id") as! String
                    self.theUser = User(userID: userID, firstName: first_name, lastName: last_name, email: email, authToken: authToken, brainTreeID: brainTreeID)
                }
                
                success(responseStatus: status, responseDict: jsonDict)
            }
        }
    }
    
    class func getBars(success: (responseArray: NSArray!)->(), failure: (error: NSError!)->()) {
    
        let url = kBaseURL + "menus"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON, error) -> Void in
                
            if error != nil {
                failure(error: error)
            } else {
                
                println(JSON)
                success(responseArray: JSON as! NSArray)
            }
        }
    }
    
    private class func showAlertForErrorDict(errorDict: NSDictionary) {
        
        
    }
}
