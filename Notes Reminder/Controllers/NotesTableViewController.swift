//
//  NotesTableViewController.swift
//  Notes Reminder
//
//  Created by Heema Rajkarnikar on 4/24/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var noteArray = [Notes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()

    }

    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let note = noteArray[indexPath.row]
        
        cell.textLabel?.text = note.title
        

        return cell
    }


    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNoteDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteDetailViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = noteArray[indexPath.row]
        }
    }
    

    @IBAction func addNote(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Note", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
            
            let newNote = Notes(context: self.context)
            newNote.title = textField.text!
            self.noteArray.append(newNote)
            self.saveNotes()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Note"
            textField = alertTextField
        }
        
        alert.addAction(action)

        
        present(alert, animated: true, completion: nil)
    }
    
    func saveNotes() {
        
        do {
            try context.save()
        }catch{
            print("Error in saving \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest()){
        
        do{
            noteArray = try context.fetch(request)
        } catch {
            print("Error in fetch \(error)")
        }
        
        tableView.reloadData()
    }
}
