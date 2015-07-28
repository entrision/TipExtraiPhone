//
//  LogoutViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/28/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButtonTapped(sender: AnyObject) {

        dismissViewControllerAnimated(true, completion: nil)
        
        let navController = self.presentingViewController as! UINavigationController
        let menuController = navController.viewControllers[0] as! MenuViewController
        menuController.presentLogin(true)
        
        APIManager.logout({ (responseStatus, responseDict) -> () in
        }, failure: { (error) -> () in
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
