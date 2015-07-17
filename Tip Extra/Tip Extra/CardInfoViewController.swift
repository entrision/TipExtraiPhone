//
//  CardInfoViewController.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/14/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class CardInfoViewController: UIViewController {

    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expDateTextField: UITextField!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var finishButton: ActivityButton!
    
    var datePickerView = DatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        expDateTextField.delegate = self
        
        datePickerView = NSBundle.mainBundle().loadNibNamed("DatePickerView", owner: self, options: nil)[0] as! DatePickerView
        datePickerView.frame = CGRectMake(0, 0, datePickerView.frame.size.width, datePickerView.frame.size.height)
        datePickerView.delegate = self
        expDateTextField.inputView = datePickerView
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
}

extension CardInfoViewController: DatePickerViewDelegate {
    
    func datePickerViewDidChange(dateString: String) {
        self.expDateTextField.text = dateString
    }
    
    func datePickerDoneButtonTapped() {
        expDateTextField.resignFirstResponder()
    }
}
