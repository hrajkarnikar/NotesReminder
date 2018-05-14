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
    
    var eventStore = EKEventStore()
    var datePicker: UIDatePicker!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })

        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        //datePicker.addTarget(self, action: "addDate", for: UIControlEvents.valueChanged)
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        dateTextField.inputView = datePicker
        //reminderTextView.becomeFirstResponder()
        
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker){
        self.dateTextField.text = self.datePicker.date.description
        dateTextField.resignFirstResponder()
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
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        createReminder()
    }
    
    
    
    func createReminder(){
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = "test"
        
        let greg = Calendar(identifier: .gregorian)
        let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        
        let dateComponents = greg.dateComponents(components, from: datePicker.date)
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let dueDateComponents = appDelegate.dateComponentFromNSDate(datePicker.date)
        reminder.dueDateComponents = dateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        do {
            try self.eventStore.save(reminder, commit: true)
            navigationController?.popViewController(animated: true)

        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
}
