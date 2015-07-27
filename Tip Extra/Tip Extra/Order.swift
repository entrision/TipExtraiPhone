//
//  Order.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/15/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Order: NSObject {
   
    var orderID: NSNumber
    var orderItems: NSArray
    var total: Float {
        
        get {
            var theTotal: Float = 0.0
            for var i=0; i<orderItems.count; i++ {
                let menuItem = orderItems[i] as! MenuItem
                theTotal += menuItem.price * Float(menuItem.quantity)
            }
            return theTotal
        }
    }
    
    convenience override init() {
        self.init(orderDict:["id":-1, "line_items":[]])
    }
    
    init(orderDict: [String: AnyObject]) {
        self.orderID = orderDict["id"] as! NSNumber
        let itemsArray = orderDict["line_items"] as! NSArray
        let orderItems = NSMutableArray()
        for var i=0; i<itemsArray.count; i++ {
            let menuItem = MenuItem()
            let itemDict = itemsArray[i] as! [String: AnyObject]
            menuItem.itemID = itemDict["drink_id"] as! NSNumber
            menuItem.quantity = itemDict["qty"] as! Int
            menuItem.price = itemDict["cost"] as! Float
            orderItems.addObject(menuItem)
        }
        self.orderItems = orderItems
        super.init()
    }
}
