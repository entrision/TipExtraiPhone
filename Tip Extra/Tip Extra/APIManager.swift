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
    
    static let kBaseURL = "http://104.236.73.241/api/v1/"
    
    //MARK: Authentication
    
    class func createUser(userDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
     
        let url = kBaseURL + "users"
        self.handleAuthentication(url, userDict: userDict, success: { (responseStatus, responseDict) -> () in
            success(responseStatus: responseStatus, responseDict: responseDict)
        }, failure: { (error) -> () in
            failure(error: error)
        })
    }
    
    class func loginWithDict(loginDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
     
        let url = kBaseURL + "sessions"
        self.handleAuthentication(url, userDict: loginDict, success: { (responseStatus, responseDict) -> () in
            success(responseStatus: responseStatus, responseDict: responseDict)
        }) { (error) -> () in
            failure(error: error)
        }
    }
    
    private class func handleAuthentication(url: String, userDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
        
        Alamofire.request(.POST, url, parameters: userDict, encoding: .JSON)
        .responseJSON { (request, response, JSON, error) -> Void in
                
            if error != nil {
                failure(error: error)
            } else {
                
                println(JSON)
                
                var status = 0
                var jsonDict = JSON as! NSDictionary
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    
                    status = Utils.kFailureStatus
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    jsonDict = errorDict
                    
                } else {
                    
                    status = Utils.kSuccessStatus
                    let userDict = jsonDict.objectForKey("user") as! [String: AnyObject]
                    DefaultsManager.userDict = userDict
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.theUser = User(userDict: userDict)
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
}
