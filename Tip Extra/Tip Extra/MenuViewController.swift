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
    let kOrderConfirmationSegue = "orderConfirmationSegue"
    
    var dummyCell = MenuCell()

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var placeOrderView: PlaceOrderView!
    
    var theOrder = Order.new()
    var menuItems = NSArray()
    var selectedOrderItems = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.titleView = NSBundle.mainBundle().loadNibNamed("MenuTitleView", owner: self, options: nil)[0] as? UIView
        
        theTableView.registerNib(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: cellID)
        theTableView.separatorInset = UIEdgeInsetsZero;
        theTableView.layoutMargins = UIEdgeInsetsZero;
        theTableView.separatorColor = UIColor.darkGrayColor()
        theTableView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("MenuCell", owner: self, options: nil)[0] as! MenuCell
        
        let tapGr = UITapGestureRecognizer(target: self, action: "placeOrderTapGesture:")
        tapGr.numberOfTapsRequired = 1
        placeOrderView.addGestureRecognizer(tapGr)
        
        self.addMenuItems()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kOrderConfirmationSegue {
            
            let navController = segue.destinationViewController as! UINavigationController
            let vc = navController.viewControllers[0] as! OrderConfirmationViewController
            vc.theOrder = theOrder
        } else if segue.identifier == "PopoverSegue" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 180, height: 75)
            }
        }
    }
    
    //MARK: Private methods
    
    func updateOrder() {
        
        theOrder.orderItems = selectedOrderItems
        
        var orderString = "$0.00"
        if theOrder.total > 0 {
            placeOrderView.alpha = 1.0
            placeOrderView.userInteractionEnabled = true
            orderString = String(format: "$%.2f", theOrder.total)
        } else {
            placeOrderView.alpha = 0.5
            placeOrderView.userInteractionEnabled = false
        }
        
        placeOrderView.priceLabel.text = orderString
    }
    
    func addMenuItems() {
        let menuItem = MenuItem(name: "Jack and Coke", price: 4.00)
        let menuItem2 = MenuItem(name: "Corona", price: 5.00)
        let menuItem3 = MenuItem(name: "Martini", price: 10.00)
        
        menuItems = [menuItem, menuItem2, menuItem3]
        selectedOrderItems = NSMutableArray()
        theTableView.reloadData()
        updateOrder()
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
    
    func placeOrderTapGesture(gr: UIGestureRecognizer) {
        performSegueWithIdentifier(kOrderConfirmationSegue, sender: self)
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
        cell.contentView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

extension MenuViewController : MenuCellDelegate {
    
    func menuCellDidSwipeLeft(cell: MenuCell) {
        
        let menuItem = cell.menuItem
        
        if !menuItem.ordered {
            menuItem.ordered = true
            menuItem.quantity = 1
            selectedOrderItems.addObject(menuItem)
            
            self.updateOrder()
            theTableView.reloadRowsAtIndexPaths([theTableView.indexPathForCell(cell)!], withRowAnimation: .None)
        } else {
            cell.menuItem.quantity++
            
            let index = selectedOrderItems.indexOfObject(cell.menuItem)
            selectedOrderItems.replaceObjectAtIndex(index, withObject: cell.menuItem)
            
            self.updateOrder()
            theTableView.reloadRowsAtIndexPaths([theTableView.indexPathForCell(cell)!], withRowAnimation: .None)
        }
    }
    
    func menuCellDidSwipeRight(cell: MenuCell) {
        
        if cell.menuItem.quantity > 0 {
            
            cell.menuItem.quantity--
            
            if cell.menuItem.quantity == 0 {
                cell.menuItem.ordered = false
                selectedOrderItems.removeObject(cell.menuItem)
            } else {
                let index = selectedOrderItems.indexOfObject(cell.menuItem)
                selectedOrderItems.replaceObjectAtIndex(index, withObject: cell.menuItem)
            }
            
            self.updateOrder()
            theTableView.reloadRowsAtIndexPaths([theTableView.indexPathForCell(cell)!], withRowAnimation: .None)
        }
    }
}

extension MenuViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}