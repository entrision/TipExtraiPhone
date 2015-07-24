//
//  LoginViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class LoginViewController: TipExtraViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: ActivityButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //DEVELOPMENT
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        self.emailTextField.text = "hunter@entrision.com"
        self.passwordTextField.text = "password"
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        if !isValidEntry() {
            return
        }
        
        view.endEditing(true)
        let loginDict = ["user": ["email": emailTextField.text.lowercaseString,
            "password": passwordTextField.text]]
        
        loginButton.startAnimating()
        APIManager.loginWithDict(loginDict, success: { (responseStatus, responseDict) -> () in
            
            self.loginButton.stopAnimating()
            if responseStatus == Utils.kSuccessStatus {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                
                for var i=0; i<responseDict.count; i++ {
                    let key = responseDict.allKeys[i] as! String
                    if key == Utils.kLoginKey {
                        let errorMessage = (responseDict.objectForKey(Utils.kLoginKey) as! NSArray)[0] as! String
                        self.loginErrorLabel.text = errorMessage
                        self.loginErrorLabel.hidden = false
                    }
                    if key == Utils.kEmailKey {
                        let errorMessage = (responseDict.objectForKey(Utils.kEmailKey) as! NSArray)[0] as! String
                        self.emailErrorLabel.text = "Email \(errorMessage)"
                        self.emailErrorLabel.hidden = false
                    }
                    if key == Utils.kPasswordKey {
                        let errorMessage = (responseDict.objectForKey(Utils.kPasswordKey) as! NSArray)[0] as! String
                        self.passwordErrorLabel.text = "Password \(errorMessage)"
                        self.passwordErrorLabel.hidden = false
                    }
                }
            }
            
        }) { (error) -> () in
            self.loginButton.stopAnimating()
            self.showDefaultErrorAlert()
        }
        
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    func isValidEntry() -> Bool {
        
        var isValid = true
        
        if emailTextField.text == "" {
            isValid = false
            emailErrorLabel.hidden = isValid
            emailErrorLabel.text = "Please enter your email"
        }
        if passwordTextField.text == "" {
            isValid = false
            passwordErrorLabel.hidden = isValid
            passwordErrorLabel.text = "Please enter your password"
        }
        
        return isValid
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == emailTextField {
            emailErrorLabel.hidden = textField.text != ""
        } else if textField == passwordTextField {
            passwordErrorLabel.hidden = textField.text != ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
