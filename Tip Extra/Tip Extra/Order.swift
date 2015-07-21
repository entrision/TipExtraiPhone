//
//  Order.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/15/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Order: NSObject {
   
    var orderItems = NSArray()
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
        self.init(orderItems:[])
    }
    
    init(orderItems: NSArray) {
        super.init()
        self.orderItems = orderItems
    }
}
