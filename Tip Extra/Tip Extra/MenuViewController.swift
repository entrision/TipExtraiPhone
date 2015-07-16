//
//  ViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class MenuViewController: TipExtraViewController {
    
    let cellID = "MenuCellID"
    
    var dummyCell = MenuCell()

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    
    var theOrder = Order.new()
    var menuItems = NSArray()
    var orderItems = NSMutableArray()
    var restrictionView = UIView()
    var totalPrice: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Menu"
        
        theTableView.registerNib(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: cellID)
        theTableView.separatorInset = UIEdgeInsetsZero;
        theTableView.layoutMargins = UIEdgeInsetsZero;
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("MenuCell", owner: self, options: nil)[0] as! MenuCell
        
        restrictionView = UIView(frame: view.bounds)
        restrictionView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        
        self.addMenuItems()
    }
    
    //MARK: Private methods
    
    func updateOrderButton() {
        totalPrice = 0.0
        orderButton.enabled = false
        orderButton.alpha = 0.5
        var count = orderItems.count > 0 ? orderItems.count : 0
        for var i=0; i<count; i++ {
            let menuItem = orderItems[i] as! MenuItem
            totalPrice += menuItem.price * Float(menuItem.quantity)
        }
        
        var orderString = "Order"
        if totalPrice > 0 {
            orderButton.enabled = true
            orderButton.alpha = 1.0
            orderString = String(format: "Order ($%.2f)", totalPrice)
        }
        
        orderButton.setTitle(orderString, forState: .Normal)
    }
    
    func increaseQtyForCell(cell: MenuCell) {
        cell.menuItem.quantity++
        
        let index = orderItems.indexOfObject(cell.menuItem)
        orderItems.replaceObjectAtIndex(index, withObject: cell.menuItem)
        
        self.updateOrderButton()
        theTableView.reloadRowsAtIndexPaths([theTableView.indexPathForCell(cell)!], withRowAnimation: .None)
    }
    
    func addMenuItems() {
        let menuItem = MenuItem(name: "Jack and Coke", price: 4.00)
        let menuItem2 = MenuItem(name: "Corona", price: 5.00)
        let menuItem3 = MenuItem(name: "Martini", price: 10.00)
        
        theOrder = Order(orderItems: [menuItem, menuItem2, menuItem3])
        menuItems = [menuItem, menuItem2, menuItem3]
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //MARK: Actions
    
    @IBAction func orderButtonTapped(sender: AnyObject) {
        
        let confirmationView = NSBundle.mainBundle().loadNibNamed("ConfirmationView", owner: self, options: nil)[0] as! ConfirmationView
        confirmationView.priceLabel.text = String(format: "$%.2f", totalPrice)
        confirmationView.buttonClosure = {
            
            confirmationView.dismiss()
            
            let completeView = NSBundle.mainBundle().loadNibNamed("OrderCompleteView", owner: self, options: nil)[0] as! OrderCompleteView
            completeView.showInView(self.view)
            
            self.delay(2.0) {
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    
                    completeView.alpha = 0.0
                    self.restrictionView.alpha = 0.0
                    
                }, completion: { finished in
                    completeView.removeFromSuperview()
                    self.restrictionView.removeFromSuperview()
                    
                    self.addMenuItems()
                    self.totalPrice = 0.0
                    self.orderItems = NSMutableArray()
                    self.theTableView.reloadData()
                    self.updateOrderButton()
                })
            }
        }
        
        restrictionView.alpha = 1.0
        view.addSubview(restrictionView)
        confirmationView.showInView(view)
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MenuCell
        
        let menuItem = menuItems[indexPath.row] as! MenuItem
        cell.menuItem = menuItem
        
        cell.delegate = self
        cell.selectionStyle = .None
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let menuItem = menuItems[indexPath.row] as! MenuItem
        
        if !menuItem.ordered {
            menuItem.ordered = true
            menuItem.quantity = 1
            orderItems.addObject(menuItem)
            
            self.updateOrderButton()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        } else {
            self.increaseQtyForCell(tableView.cellForRowAtIndexPath(indexPath) as! MenuCell)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

extension MenuViewController : MenuCellDelegate {
    
    func menuCellDidTapPlusButton(cell: MenuCell) {
        self.increaseQtyForCell(cell)
    }
    
    func menuCellDidTapMinusButton(cell: MenuCell) {
        
        if cell.menuItem.quantity > 0 {
            
            cell.menuItem.quantity--
            
            if cell.menuItem.quantity == 0 {
                cell.menuItem.ordered = false
                orderItems.removeObject(cell.menuItem)
            } else {
                let index = orderItems.indexOfObject(cell.menuItem)
                orderItems.replaceObjectAtIndex(index, withObject: cell.menuItem)
            }
            
            self.updateOrderButton()
            theTableView.reloadRowsAtIndexPaths([theTableView.indexPathForCell(cell)!], withRowAnimation: .None)
        }
    }
}