//
//  ReminderViewController.swift
//  Notes Reminder
//
//  Created by joshi on 5/12/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import EventKit

class ReminderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var repeatTextField: UITextField!
    
    var eventStore = EKEventStore()
    var datePicker: UIDatePicker!
    var noteCopy: String = ""
    var dayOfTheWeek: EKRecurrenceDayOfWeek? = nil
    
    let daysOfTheWeek = NSCalendar.current.shortWeekdaySymbols
    //[EKRecurrenceDayOfWeek(.monday), EKRecurrenceDayOfWeek(.tuesday)]
    
    func getNoteText(noteText: String) {
        noteCopy = noteText
    }
   
    
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
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        dateTextField.inputView = datePicker
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        repeatTextField.inputView = pickerView
        
        
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker){
        self.dateTextField.text = self.datePicker.date.description
        dateTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysOfTheWeek.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysOfTheWeek[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repeatTextField.text = daysOfTheWeek[row]
        repeatTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        createReminder()
    }
    
    
    
    func createReminder(){
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = noteCopy
        
        let greg = Calendar(identifier: .gregorian)
        let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        
        let dateComponents = greg.dateComponents(components, from: datePicker.date)
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let dueDateComponents = appDelegate.dateComponentFromNSDate(datePicker.date)
        reminder.dueDateComponents = dateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        if repeatTextField.text == "Mon"{
            dayOfTheWeek = EKRecurrenceDayOfWeek(.monday)
        }else if repeatTextField.text == "Tue" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.tuesday)
        }else if repeatTextField.text == "Wed" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.wednesday)
        }else if repeatTextField.text == "Thu" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.thursday)
        }else if repeatTextField.text == "Fri" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.friday)
        }else if repeatTextField.text == "Sat" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.saturday)
        }else if repeatTextField.text == "Sun" {
            dayOfTheWeek = EKRecurrenceDayOfWeek(.sunday)
        }
        
        
        let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [dayOfTheWeek!], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        
        reminder.recurrenceRules = [recurrenceRule]
        
        do {
            try self.eventStore.save(reminder, commit: true)
            navigationController?.popViewController(animated: true)

        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
}
