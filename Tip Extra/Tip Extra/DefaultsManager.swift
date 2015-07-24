//
//  DefaultsManager.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/24/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class DefaultsManager: NSObject {
    
    class var userDict: [String: AnyObject]? {
        get {
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            return defaults.objectForKey("user_dict") as? [String: AnyObject]
        }
        set {
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if newValue != nil {
                defaults.setObject(newValue, forKey: "user_dict")
            } else {
                defaults.removeObjectForKey("user_dict")
            }
            defaults.synchronize()
        }
    }
}
