//
//  MenuCell.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

protocol MenuCellDelegate {
    func menuCellDidSwipeRight(cell: MenuCell)
    func menuCellDidSwipeLeft(cell: MenuCell)
}

class MenuCell: UITableViewCell {
    
    var delegate: MenuCellDelegate! = nil

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    var menuItem: MenuItem = MenuItem()  {
        
        didSet {
            
            nameLabel.text = menuItem.name
            priceLabel.text = String(format: "$%.2f", menuItem.price)
            qtyLabel.text = "\(menuItem.quantity)"
            qtyLabel.alpha = menuItem.quantity > 0 ? 1.0 : 0.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        qtyLabel.layer.borderColor = UIColor.darkGrayColor().CGColor
        qtyLabel.layer.borderWidth = 0.5
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("leftSwipe:"))
        leftSwipe.direction = .Left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("rightSwipe:"))
        rightSwipe.direction = .Right
        self.addGestureRecognizer(rightSwipe)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    //MARK: Actions
    
    func leftSwipe(gr: UISwipeGestureRecognizer) {
        
        if gr.state == UIGestureRecognizerState.Began {
            
        } else if gr.state == UIGestureRecognizerState.Ended {
            delegate.menuCellDidSwipeLeft(self)
        }
    }
    
    func rightSwipe(gr: UISwipeGestureRecognizer) {
        if gr.state == UIGestureRecognizerState.Began {
            
        } else if gr.state == UIGestureRecognizerState.Ended {
            delegate.menuCellDidSwipeRight(self)
        }
    }
}
