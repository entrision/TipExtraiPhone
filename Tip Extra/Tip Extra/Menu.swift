//
//  Menu.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/24/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Menu: NSObject {
    
    var menuID: NSNumber
    var name: String
    var serviceEnabled: Bool
    var menuItems: NSArray?
    
    convenience override init() {
        self.init(menuDict: ["": ""])
    }
    
    init(menuDict: [String: AnyObject]) {
        
        self.menuID = menuDict[Utils.kIDKey] as! NSNumber
        self.name = menuDict[Utils.kNameKey] as! String
        self.serviceEnabled = (menuDict[Utils.kServiceEnabled] as! NSString).boolValue
        super.init()
    }
}
