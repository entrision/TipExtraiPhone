//
//  TipExtraTextField.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/16/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class TipExtraTextField: UITextField {

    var initialized = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        text = ""
        font = UIFont(name: "Raleway", size: 19.0)
        borderStyle = UITextBorderStyle.None
        textColor = UIColor.whiteColor()
        
        if self.respondsToSelector(Selector("setAttributedPlaceholder:")) {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        } else {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !initialized {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, frame.size.height-1.0, frame.size.width, 0.5)
            bottomBorder.backgroundColor = UIColor.whiteColor().CGColor
            layer.addSublayer(bottomBorder)
            
            let leftBorder = CALayer()
            leftBorder.frame = CGRectMake(0, frame.size.height / 2.0, 0.5, (frame.size.height / 2.0) - 1.0)
            leftBorder.backgroundColor = UIColor.whiteColor().CGColor
            layer.addSublayer(leftBorder)
            
            let x = frame.size.width - 0.5
            let rightBorder = CALayer()
            rightBorder.frame = CGRectMake(x, frame.size.height / 2.0, 0.5, (frame.size.height / 2.0) - 1.0)
            rightBorder.backgroundColor = UIColor.whiteColor().CGColor
            layer.addSublayer(rightBorder)
            
            initialized = true
        }
        
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
