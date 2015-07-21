//
//  PlaceOrderView.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/21/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class PlaceOrderView: UIView {
    
     @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.layer.borderColor = UIColor.whiteColor().CGColor
        priceLabel.layer.borderWidth = 0.5
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        alpha = 0.75
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        alpha = 1.0
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        alpha = 1.0
        super.touchesCancelled(touches, withEvent: event)
    }

}
