//
//  DatePickerView.swift
//  Tip Extra
//
//  Created by Hunter Whittle on 7/17/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate {
    func datePickerViewDidChange(dateString: String)
    func datePickerDoneButtonTapped()
}

class DatePickerView: UIView {
    
    @IBOutlet weak var thePicker: UIPickerView!
    
    var delegate: DatePickerViewDelegate! = nil
    
    let kMonthComponentIndex = 0
    let kYearComponentIndex = 1
    
    let monthArray = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let yearArray = NSMutableArray()
    
    var selectedMonth = ""
    var selectedYear = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thePicker.dataSource = self
        thePicker.delegate = self

        let gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let comps = gregorian?.components(.CalendarUnitYear, fromDate: NSDate())
        let year = comps?.year
        
        for var i=year!; i<year!+20; i++ {
            yearArray.addObject("\(i)")
        }
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        delegate.datePickerDoneButtonTapped()
    }
}

extension DatePickerView: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numOfRows = 1
        
        if component == kMonthComponentIndex {
            numOfRows = 12
        } else if component == kYearComponentIndex {
            numOfRows = 20
        }
        
        return numOfRows
    }
}

extension DatePickerView: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var title = "Row"
        
        if component == kMonthComponentIndex {
            title = monthArray[row]
        } else if component == kYearComponentIndex {
            title = yearArray[row] as! String
        }
        
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if component == kMonthComponentIndex {
            selectedMonth = monthArray[row]
        } else if component == kYearComponentIndex {
            selectedYear = yearArray[row] as! String
        }
        
        let dateString = "\(selectedMonth) / \(selectedYear)"
        delegate.datePickerViewDidChange(dateString)
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(75.0)
    }
}
