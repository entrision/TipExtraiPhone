//
//  RegisterViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class RegisterViewController: TipExtraViewController {
    
    let cardInfoSegue = "cardInfoSegue"

    @IBOutlet weak var firstNameTextField: TipExtraTextField!
    @IBOutlet weak var lastNameTextField: TipExtraTextField!
    @IBOutlet weak var emailTextField: TipExtraTextField!
    @IBOutlet weak var passwordTextField: TipExtraTextField!
    @IBOutlet weak var continueButton: ActivityButton!
    @IBOutlet weak var confirmTextField: TipExtraTextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
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
        
        if !isValidEntry() {
            return
        }
        
        let userDict = ["user": ["first_name": firstNameTextField.text,
            "last_name": lastNameTextField.text,
            "email": emailTextField.text,
            "password": passwordTextField.text]]
        
        continueButton.startAnimating()
        APIManager.createUser(userDict, success: { (responseStatus, responseDict) -> () in
            
            self.continueButton.stopAnimating()
            if responseStatus == Utils.kSuccessStatus {
                self.performSegueWithIdentifier(self.cardInfoSegue, sender: self)
            } else {
                
                for var i=0; i<responseDict.count; i++ {
                    let key = responseDict.allKeys[i] as! String
                    if key == Utils.kFirstNameKey {
                        let errorMessage = (responseDict.objectForKey(Utils.kFirstNameKey) as! NSArray)[0] as! String
                        self.firstNameErrorLabel.text = "First name \(errorMessage)"
                        self.firstNameErrorLabel.hidden = false
                    }
                    if key == Utils.kLastNameKey {
                        let errorMessage = (responseDict.objectForKey(Utils.kLastNameKey) as! NSArray)[0] as! String
                        self.lastNameErrorLabel.text = "Last name \(errorMessage)"
                        self.lastNameErrorLabel.hidden = false
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
            self.continueButton.stopAnimating()
            self.showDefaultErrorAlert()
            println(error)
        }
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Misc methods
    
    func isValidEntry() -> Bool {
        
        var isValid = true
        
        if firstNameTextField.text == "" {
            isValid = false
            firstNameErrorLabel.hidden = isValid
            firstNameErrorLabel.text = "Please enter your first name"
        }
        if lastNameTextField.text == "" {
            isValid = false
            lastNameErrorLabel.hidden = isValid
            lastNameErrorLabel.text = "Please enter your last name"
        }
        if emailTextField.text == "" {
            isValid = false
            emailErrorLabel.hidden = isValid
            emailErrorLabel.text = "Please enter your email address"
        }
        if passwordTextField.text == "" {
            isValid = false
            passwordErrorLabel.hidden = isValid
            passwordErrorLabel.text = "Please enter a password"
        }
        if confirmTextField.text == "" {
            isValid = false
            confirmErrorLabel.hidden = isValid
            confirmErrorLabel.text = "Please enter your password again"
        }
        if passwordTextField.text != confirmTextField.text {
            isValid = false
            confirmErrorLabel.hidden = isValid
            confirmErrorLabel.text = "Passwords do not match"
        }
        
        return isValid
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == firstNameTextField {
            if firstNameErrorLabel.hidden == false {
                if textField.text != "" {
                    firstNameErrorLabel.hidden = true
                }
            }
        } else if textField == lastNameTextField {
            if lastNameErrorLabel.hidden == false {
                if textField.text != "" {
                    lastNameErrorLabel.hidden = true
                }
            }
        } else if textField == emailTextField {
            if emailErrorLabel.hidden == false {
                if textField.text != "" {
                    emailErrorLabel.hidden = true
                }
            }
        } else if textField == passwordTextField {
            if passwordErrorLabel.hidden == false {
                if textField.text != "" {
                    passwordErrorLabel.hidden = true
                }
            }
        } else if textField == confirmTextField {
            if confirmErrorLabel.hidden == false {
                if textField.text != "" {
                    confirmErrorLabel.hidden = true
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
