//
//  ConfirmationView.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/15/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ConfirmationView: UIView {
    
    typealias ButtonClosure = () -> Void
    var buttonClosure: ButtonClosure? = { }
    
    @IBOutlet weak var placeOrderButton: ActivityButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeOrderButton.layer.cornerRadius = 8.0
        layer.cornerRadius = 8.0
    }
    
    func showInView(view: UIView) {
        
        let x = (view.frame.size.width / 2) - (frame.size.width / 2)
        let y = view.frame.size.height
        frame = CGRectMake(x, y, frame.size.width, frame.size.height)
        
        view.addSubview(self)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            let y = (view.frame.size.height / 2) - (self.frame.size.height / 2)
            self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)
            
            }, completion: { finished in
                
        })
    }
    
    func dismiss() {
        
        UIView.animateWithDuration(0.15,  animations: {
            
            self.frame = CGRectMake(-500, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }

    @IBAction func placeOrderButtonTapped(sender: AnyObject) {
        
        if let theClosure = self.buttonClosure {
            theClosure()
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
