//
//  ActivityButton.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ActivityButton: UIButton {
    
    var activityIndicator = UIActivityIndicatorView()
    var theTitle = ""

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        activityIndicator = UIActivityIndicatorView(frame: self.bounds)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.addSubview(activityIndicator)
    }
    
    func startAnimating() {
        
        theTitle = self.currentTitle!
        self.setTitle("", forState: .Normal)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        
        self.setTitle(theTitle, forState: .Normal)
        activityIndicator.stopAnimating()
    }
}
