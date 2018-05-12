//
//  ReminderViewController.swift
//  Notes Reminder
//
//  Created by joshi on 5/12/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import EventKit

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    var eventStore: EKEventStore!
    var datePicker: UIDatePicker! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        //datePicker.addTarget(self, action: "addDate", for: UIControlEvents.valueChanged)
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        dateTextField.inputView = datePicker
        //reminderTextView.becomeFirstResponder()
        
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker){
        self.dateTextField.text = self.datePicker.date.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
