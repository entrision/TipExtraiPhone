//
//  MenuCell.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

protocol MenuCellDelegate {
    func menuCellDidTapPlusButton(cell: MenuCell)
    func menuCellDidTapMinusButton(cell: MenuCell)
}

class MenuCell: UITableViewCell {
    
    var delegate: MenuCellDelegate! = nil

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var menuItem: MenuItem = MenuItem()  {
        
        didSet {
            
            self.priceLabel.text = String(format: "$%.2f", menuItem.price)
            
            let quantity = menuItem.quantity > 0 ? "(\(menuItem.quantity))" : ""
            self.nameLabel.text = String(format: "%@ %@", menuItem.name, quantity)
            
            self.minusButton.hidden = !menuItem.ordered
            self.plusButton.hidden = !menuItem.ordered
            self.contentView.backgroundColor = menuItem.ordered ? UIColor(white: 0.925, alpha: 1.0) : UIColor.whiteColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        minusButton.layer.cornerRadius = minusButton.frame.size.width / 2
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 2
        
        minusButton.hidden = true
        plusButton.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    //MARK: Actions
    
    @IBAction func plusButtonTapped(sender: AnyObject) {
        delegate.menuCellDidTapPlusButton(self)
    }
    
    @IBAction func minusButtonTapped(sender: AnyObject) {
        delegate.menuCellDidTapMinusButton(self)
    }
}
