//
//  NoteDetailViewController.swift
//  Notes Reminder
//
//  Created by Heema Rajkarnikar on 4/25/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var noteText: UITextView!
    
    var noteArray = [Notes]()
    
    var selectedNote : Notes? {
        didSet{
            loadDetail()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadDetail(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil){

        let notePredicate = NSPredicate(format: "title MATCHES %@", selectedNote!.title!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [notePredicate,additionalPredicate])
        }else{
            request.predicate = notePredicate
        }
        
        
        do{
            noteArray = try context.fetch(request)
            
            noteText.text = "test"
            
            /*if let noteDetail = noteArray.first?.detail {
                noteText.text = noteDetail
            }else{
                noteText.text = ""
            }*/
            
        } catch {
            print("Error in fetch \(error)")
        }
        
        /*noteText.reloadInputViews()*/
        
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
