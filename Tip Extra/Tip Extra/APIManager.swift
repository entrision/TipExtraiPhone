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
                    
                    var manager = Manager.sharedInstance
                    manager.session.configuration.HTTPAdditionalHeaders = [
                        "Authorization": "Token token=\(appDelegate.theUser?.authToken)"
                    ]
                }
                
                success(responseStatus: status, responseDict: jsonDict)
            }
        }
    }
    
    //MARK: Content
    
    class func getMenus(success: (responseStatus: Int!, responseArray: NSArray!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "menus"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON, error) -> Void in
            
            if error != nil {
                failure(error: error)
            } else {
                
                println(JSON)

                var jsonDict = JSON as! NSDictionary
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
        .responseJSON { (request, response, JSON, error) -> Void in
                
            if error != nil {
                failure(error: error)
            } else {
                
                println(JSON)
        
                var jsonDict = JSON as! NSDictionary
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
        
        Alamofire.request(.GET, NSURL(string: path)!)
            .response() { (_, _, data, error) in
                
                if error != nil {
                    failure(error: error)
                }
                else {
                    let image = UIImage(data: data! as! NSData)
                    success(theImage: image)
                }
        }
    }
    
    //MARK: Orders
    
    class func placeOrder(orderDict: [String: AnyObject], success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "orders"
        Alamofire.request(.POST, url, parameters: nil, encoding: .JSON)
        .responseJSON { (request, response, JSON, error) -> Void in
            
            if error != nil {
                failure(error: error)
            } else {
                var jsonDict = JSON as! NSDictionary
                if jsonDict.objectForKey(Utils.kErrorsKey) != nil {
                    let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as! NSDictionary
                    success(responseStatus: Utils.kFailureStatus, responseDict: errorDict)
                } else {
                    let orderDict = jsonDict.objectForKey("order") as! [String: AnyObject]
                    let order = Order(orderDict: orderDict)
                    success(responseStatus: Utils.kSuccessStatus, responseDict:["order": order])
                }
            }
        }
    }
}
