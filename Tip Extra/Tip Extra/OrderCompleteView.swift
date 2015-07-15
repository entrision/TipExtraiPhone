//
//  OrderCompleteView.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/15/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class OrderCompleteView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8.0
    }
    
    func showInView(view: UIView) {
        
        let x = view.frame.size.width
        let y = (view.frame.size.height / 2) - (self.frame.size.height / 2)
        frame = CGRectMake(x, y, frame.size.width, frame.size.height)
        view.addSubview(self)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            let x = (view.frame.size.width / 2) - (self.frame.size.width / 2)
            self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            
            }, completion: { finished in
                
        })
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
