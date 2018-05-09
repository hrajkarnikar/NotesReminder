//
//  NoteDetailViewController.swift
//  Notes Reminder
//
//  Created by Heema Rajkarnikar on 4/25/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    
    
    @IBOutlet weak var noteText: UITextView!
    
    var noteArray = [Notes]()
    
    var name = ""
    
    var selectedNote : Notes? {
        didSet{
            loadDetail()
        }
    }
    
    func updateView(itemData: Notes) {
        name = itemData.title!
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.delegate = self
        
        loadDetail()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("did end editing")
        noteArray.first?.detail = noteText.text
        saveNotes()
    }
    
    func saveNotes() {
        
        do {
            try context.save()
        }catch{
            print("Error in saving \(error)")
        }
        
        
    }
    
    
    
    func loadDetail(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil){

        let notePredicate = NSPredicate(format: "title MATCHES %@", name)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [notePredicate,additionalPredicate])
        }else{
            request.predicate = notePredicate
        }
        
        
        do{
            noteArray = try context.fetch(request)
            
            //noteText!.text = "test"
            
            if let noteDetail = noteArray.first?.detail {
                noteText.text = noteDetail
            }else{
                noteText.text = ""
            }
            
        } catch {
            print("Error in fetch \(error)")
        }
        
        /*noteText.reloadInputViews()*/
        navigationItem.title = name

    
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let text = noteText.text!
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
        //self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func reminderButtonPressed(_ sender: UIBarButtonItem) {
        
        
    }
}
