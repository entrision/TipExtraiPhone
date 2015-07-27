//
//  OrderConfirmationViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/21/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    let cellID = "MenuCellID"
    
    var theOrder: Order?
    
    var dummyCell = MenuCell()
    var orderTotalView = OrderTotalView()
    
    @IBOutlet weak var theTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "ORDER CONFIRMATION"
        
        theTableView.registerNib(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: cellID)
        theTableView.separatorStyle = .None
        theTableView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        
        orderTotalView = NSBundle.mainBundle().loadNibNamed("OrderTotalView", owner: self, options: nil)[0] as! OrderTotalView
        orderTotalView.frame = CGRectMake(0, 0, orderTotalView.frame.size.width, orderTotalView.frame.size.height)
        orderTotalView.totalLabel.text = String(format: "$%.2f", theOrder!.total)
        orderTotalView.dismissButton.addTarget(self, action: Selector("dismissButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        theTableView.tableFooterView = orderTotalView
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("MenuCell", owner: self, options: nil)[0] as! MenuCell
    }
    
    //MARK: Actions
    
    func dismissButtonTapped() {
        let navController = presentingViewController as! UINavigationController
        let presentingVc = navController.viewControllers[0] as! MenuViewController
        presentingVc.resetMenu()
        
        dismissViewControllerAnimated(true, completion:nil)
    }
}

extension OrderConfirmationViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theOrder!.orderItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MenuCell
        
        if let order = theOrder {
            
            let orderItem = order.orderItems[indexPath.row] as! MenuItem
            cell.menuItem = orderItem
        }
        
        cell.qtyLabel.layer.borderWidth = 0.0
        cell.selectionStyle = .None
        cell.contentView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        
        return cell
    }
}

extension OrderConfirmationViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}