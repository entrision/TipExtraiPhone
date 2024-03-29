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
        .responseJSON { (request, response, JSON) -> Void in
            
            print(JSON)
            
            var status = 0
            if var jsonDict = JSON.value as? NSDictionary {
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
                    self.setUserToken()
                }
                
                success(responseStatus: status, responseDict: jsonDict)
            }
        }
    }
    
    class func logout(success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
     
        let url = kBaseURL + "sessions"
        Alamofire.request(.DELETE, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            DefaultsManager.userDict = nil
        }
    }
    
    //MARK: Content
    
    class func getMenus(success: (responseStatus: Int!, responseArray: NSArray!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "menus"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            print(JSON)
            if let jsonDict = JSON.value as? NSDictionary {
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    success(responseStatus: Utils.kFailureStatus, responseArray: [errorDict])
                } else {
                    let menuArray = jsonDict.objectForKey("menus") as! NSArray
                    let menus = NSMutableArray()
                    for var i=0; i<menuArray.count; i++ {
                        let menuDict = menuArray[i] as! [String: AnyObject]
                        let menu = Menu(menuDict: menuDict)
                        menus.addObject(menu)
                    }
                    
                    success(responseStatus: Utils.kSuccessStatus, responseArray: menus)
                }
            }
        }
    }
    
    class func getItemsForMenu(menu: Menu, success: (responseStatus: Int!, responseArray: NSArray!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "menus/\(menu.menuID)"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            print(JSON)
            if let jsonDict = JSON.value as? NSDictionary {
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    success(responseStatus: Utils.kFailureStatus, responseArray: [errorDict])
                } else {
                    let menuDict = jsonDict.objectForKey(Utils.kMenuKey) as! NSDictionary
                    let drinkArray = menuDict.objectForKey(Utils.kDrinksKey) as! NSArray
                    let drinks = NSMutableArray()
                    for var i=0; i<drinkArray.count; i++ {
                        let drinkDict = drinkArray[i] as! [String: AnyObject]
                        let menuItem = MenuItem(drinkDict: drinkDict)
                        drinks.addObject(menuItem)
                    }
                    
                    success(responseStatus: Utils.kSuccessStatus, responseArray: drinks)
                }
            }
        }
    }
    
    //MARK: Images
    
    class func getImage(path: String, success: (theImage: UIImage!)->(), failure: (error: NSError!)->()) {
        
        //removing auth header for call to amazon servers
        removeUserToken()
        
        Alamofire.request(.GET, NSURL(string: path)!)
        .response() { (_, _, data, error) in
            self.setUserToken()
            if let theData = data {
                if let image = UIImage(data: theData) {
                    success(theImage: image)
                }
            }
        }
    }
    
    //MARK: Orders
    
    class func placeOrder(orderDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "orders"
        Alamofire.request(.POST, url, parameters: orderDict, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            print(JSON)
            if let jsonDict = JSON.value as? NSDictionary {
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    success(responseStatus: Utils.kFailureStatus, responseDict: errorDict)
                } else {
                    if jsonDict.count > 0 {
                        success(responseStatus: Utils.kSuccessStatus, responseDict:jsonDict)
                    } else {
                        success(responseStatus: Utils.kSuccessStatus, responseDict:["":""])
                    }
                }
            }
        }
    }
    
    //MARK: Braintree
    
    class func getBraintreeToken(success: (braintreeToken: String!)->(), failure: (error: NSError!)->()) {

        let url = kBaseURL + "client_token"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            print(JSON)
            if let jsonDict = JSON.value as? NSDictionary {
                let token = jsonDict.objectForKey("token") as! String
                success(braintreeToken: token)
            }
        }
    }
    
    class func sendBraintreeNonce(nonceDict: [String: AnyObject], success: ()->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "payment_nonce"
        Alamofire.request(.POST, url, parameters: nonceDict, encoding: .JSON)
        .responseJSON { (request, response, JSON) -> Void in
            success()
        }
    }
    
    //MARK: Misc methods
    
    class func setUserToken() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": "Token token=\(appDelegate.theUser!.authToken)"
        ]
    }
    
    class func removeUserToken() {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("", forKey: "Authorization")
    }
}
