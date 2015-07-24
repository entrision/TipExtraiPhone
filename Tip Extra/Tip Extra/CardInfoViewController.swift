//
//  CardInfoViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class CardInfoViewController: UIViewController {

    @IBOutlet weak var cardNameTextField: TipExtraTextField!
    @IBOutlet weak var cardNumberTextField: TipExtraTextField!
    @IBOutlet weak var expDateTextField: TipExtraTextField!
    @IBOutlet weak var securityCodeTextField: TipExtraTextField!
    @IBOutlet weak var finishButton: ActivityButton!
    @IBOutlet weak var cardNameErrorLabel: UILabel!
    @IBOutlet weak var cardNumberErrorLabel: UILabel!
    @IBOutlet weak var expDateErrorLabel: UILabel!
    @IBOutlet weak var securityCodeErrorLabel: UILabel!
    
    var datePickerView = DatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardNameTextField.delegate = self
        cardNumberTextField.delegate = self
        expDateTextField.delegate = self
        securityCodeTextField.delegate = self
        
        datePickerView = NSBundle.mainBundle().loadNibNamed("DatePickerView", owner: self, options: nil)[0] as! DatePickerView
        datePickerView.frame = CGRectMake(0, 0, datePickerView.frame.size.width, datePickerView.frame.size.height)
        datePickerView.delegate = self
        expDateTextField.inputView = datePickerView
    }
    
    //MARK: Actions

    @IBAction func finishButtonTapped(sender: AnyObject) {
    
        if !isValidEntry() {
            return
        }
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Misc methods
    
    func isValidEntry() -> Bool {
        
        var isValid = true
        
        cardNameErrorLabel.hidden = isValid
        cardNumberErrorLabel.hidden = isValid
        expDateErrorLabel.hidden = isValid
        securityCodeErrorLabel.hidden = isValid
        
        if cardNameTextField.text == "" {
            isValid = false
            cardNameErrorLabel.hidden = isValid
            cardNameErrorLabel.text = "Please enter the name on your card"
        }
        if cardNumberTextField.text == "" {
            isValid = false
            cardNumberErrorLabel.hidden = isValid
            cardNumberErrorLabel.text = "Please enter a valid card number"
        }
        if expDateTextField.text == "" {
            isValid = false
            expDateErrorLabel.hidden = isValid
            expDateErrorLabel.text = "Please select your card's expiration date"
        }
        if securityCodeTextField.text == "" {
            isValid = false
            securityCodeErrorLabel.hidden = isValid
            securityCodeErrorLabel.text = "Invalid security code"
        }
        
        return isValid
    }
}

extension CardInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == expDateTextField {
            
            if textField.text == "" {
                datePickerView.thePicker.selectRow(0, inComponent: 0, animated: true)
                datePickerView.thePicker.selectRow(0, inComponent: 1, animated: true)
                datePickerView.pickerView(datePickerView.thePicker, didSelectRow: 0, inComponent: 0)
                datePickerView.pickerView(datePickerView.thePicker, didSelectRow: 0, inComponent: 1)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == cardNameTextField {
            cardNameErrorLabel.hidden = textField.text != ""
        } else if textField == cardNumberTextField {
            cardNumberErrorLabel.hidden = textField.text != ""
        } else if textField == expDateTextField {
            expDateErrorLabel.hidden = textField.text != ""
        } else if textField == securityCodeTextField {
            securityCodeErrorLabel.hidden = textField.text != ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension CardInfoViewController: DatePickerViewDelegate {
    
    func datePickerViewDidChange(dateString: String) {
        self.expDateTextField.text = dateString
    }
    
    func datePickerDoneButtonTapped() {
        expDateTextField.resignFirstResponder()
    }
}
