//
//  ViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class MenuViewController: TipExtraViewController {
    
    let cellID = "MenuCellID"
    let kOrderConfirmationSegue = "orderConfirmationSegue"
    let kOptionsPopoverSegue = "optionsPopoverSegue"
    
    var dummyCell = MenuCell()

    @IBOutlet weak var optionsBarButton: UIBarButtonItem!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var placeOrderView: PlaceOrderView!
    
    var theOrder = Order()
    var menuItems = NSArray()
    var selectedOrderItems = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.titleView = NSBundle.mainBundle().loadNibNamed("MenuTitleView", owner: self, options: nil)[0] as? UIView
        
        let optionButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        optionButton.addTarget(self, action: Selector("optionsButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        optionButton.setImage(UIImage(named: "menu_button"), forState: .Normal)
        optionsBarButton.customView = optionButton
        
        theTableView.registerNib(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: cellID)
        theTableView.separatorInset = UIEdgeInsetsZero;
        theTableView.layoutMargins = UIEdgeInsetsZero;
        theTableView.separatorColor = UIColor.darkGrayColor()
        theTableView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        theTableView.tableFooterView = UIView()
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("MenuCell", owner: self, options: nil)[0] as! MenuCell
        
        let tapGr = UITapGestureRecognizer(target: self, action: "placeOrderTapGesture:")
        tapGr.numberOfTapsRequired = 1
        placeOrderView.addGestureRecognizer(tapGr)
        
        addMenuItems()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userDict = DefaultsManager.userDict {
            appDelegate.theUser = User(userDict: userDict)
            APIManager.setUserToken()
        } else {
            presentLogin(false)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kOrderConfirmationSegue {
            
            let navController = segue.destinationViewController as! UINavigationController
            let vc = navController.viewControllers[0] as! OrderConfirmationViewController
            vc.theOrder = theOrder
        } else if segue.identifier == kOptionsPopoverSegue {
            let controller = segue.destinationViewController
            controller.popoverPresentationController!.delegate = self
            controller.preferredContentSize = CGSize(width: 180, height: 75)
        }
    }
    
    //MARK: Actions
    
    func placeOrderTapGesture(gr: UIGestureRecognizer) {
        
        let orderItems = NSMutableArray()
        for menuItem in theOrder.orderItems as! [MenuItem] {
            let itemDict = ["drink_id": menuItem.itemID, "qty": menuItem.quantity]
            orderItems.addObject(itemDict)
        }

        SVProgressHUD.showWithStatus("Placing order")
        let orderDict = ["order": ["line_items_attributes": orderItems]]
        APIManager.placeOrder(orderDict, success: { (responseStatus, responseDict) -> () in
            SVProgressHUD.dismiss()
            if responseStatus == Utils.kSuccessStatus {
                if responseDict.objectForKey("message") != nil {
                    self.showErrorAlertWithTitle("Oops!", theMessage: responseDict.objectForKey("message") as! String)
                } else {
                    self.performSegueWithIdentifier(self.kOrderConfirmationSegue, sender: self)
                }
            } else {
                self.showErrorAlertWithTitle("Uh oh!", theMessage: "This menu is currently unavailable")
                self.resetMenu()
            }

        }) { (error) -> () in
            SVProgressHUD.dismiss()
            print(error)
            self.showDefaultErrorAlert()
        }
    }
    
    //MARK: Misc methods
    
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
        
        if DefaultsManager.userDict != nil {
            SVProgressHUD.showWithStatus("Adding\nmenu items")
            APIManager.getMenus({ (responseStatus, responseArray) -> () in
                SVProgressHUD.dismiss()
                if responseStatus == Utils.kSuccessStatus {
                    let menu = responseArray[0] as! Menu
                    if menu.serviceEnabled {
                        self.theTableView.hidden = false
                        APIManager.getItemsForMenu(menu, success: { (responseStatus, responseArray) -> () in
                            SVProgressHUD.dismiss()
                            if responseStatus == Utils.kSuccessStatus {
                                self.menuItems = responseArray
                                self.theTableView.reloadData()
                                self.selectedOrderItems = NSMutableArray()
                                self.updateOrder()
                            } else {
                                //Only expecting 'Access Denied" error here
                                self.showErrorAlertWithTitle("Access Denied", theMessage: "User not authenticated")
                                print(responseArray[0])
                            }
                            }, failure: { (error) -> () in
                                SVProgressHUD.dismiss()
                                self.showDefaultErrorAlert()
                                print(error)
                        })
                    } else {
                        self.theTableView.hidden = true
                    }
                } else {
                    //Only expecting 'Access Denied" error here
                    self.showErrorAlertWithTitle("Access Denied", theMessage: "User not authenticated")
                    print(responseArray[0])
                }
                
                }, failure: { (error) -> () in
                    SVProgressHUD.dismiss()
                    self.showDefaultErrorAlert()
                    print(error)
            })
        }
    }
    
    func resetMenu() {
        
        theOrder = Order()
        selectedOrderItems = NSMutableArray()
        updateOrder()
        
        for menuItem in menuItems as! [MenuItem] {
            menuItem.quantity = 0
            menuItem.ordered = false
        }
        
        theTableView.reloadData()
    }
    
    func presentLogin(animated: Bool) {
        let loginVc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavController") as! UINavigationController
        loginVc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(loginVc, animated: animated, completion: {
            self.resetMenu()
        })
    }
    
    func optionsButtonTapped() {
        self.performSegueWithIdentifier(kOptionsPopoverSegue, sender: self)
    }
    
    func braintreePaymentCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! MenuCell
        
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