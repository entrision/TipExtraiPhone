//
//  MenuItem.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/15/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class MenuItem: NSObject {
    
    var itemID: NSNumber
    var name: String
    var price: Float
    var ordered: Bool = false
    var quantity: Int = 0
    
    convenience override init() {
        self.init(drinkDict: ["":""])
    }
    
    init(drinkDict: [String: AnyObject]) {
        self.itemID = drinkDict[Utils.kIDKey] as! NSNumber
        self.name = drinkDict[Utils.kNameKey] as! String
        self.price = (drinkDict[Utils.kPriceKey] as! NSString).floatValue
        super.init()
    }
}
