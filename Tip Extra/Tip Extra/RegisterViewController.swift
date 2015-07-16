//
//  RegisterViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let cardInfoSegue = "cardInfoSegue"

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: TipExtraTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: ActivityButton!
    @IBOutlet weak var confirmTextField: TipExtraTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Actions
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(cardInfoSegue, sender: self)
    }
}
