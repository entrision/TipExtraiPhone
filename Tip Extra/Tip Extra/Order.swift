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
    
    convenience override init() {
        self.init(orderItems:[])
    }
    
    init(orderItems: NSArray) {
        super.init()
        self.orderItems = orderItems
    }
}
