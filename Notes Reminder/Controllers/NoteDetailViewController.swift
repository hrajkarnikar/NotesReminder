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

class NoteDetailViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    let imagePicker = UIImagePickerController()
    
    
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
        imagePicker.delegate = self
        
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ReminderViewController

        destinationVC.getNoteText(noteText: noteText.text)
        
    }
    

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
        performSegue(withIdentifier: "addReminder", sender: self)
        
    }
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //create and NSTextAttachment and add your image to it.
        let attachment = NSTextAttachment()
        attachment.image = image
        //calculate new size.  (-20 because I want to have a litle space on the right of picture)
        let newImageWidth = (noteText.bounds.size.width - 20 )
        let scale = newImageWidth/image.size.width
        let newImageHeight = image.size.height * scale
        //resize this
        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)
        //put your NSTextAttachment into and attributedString
        let attString = NSAttributedString(attachment: attachment)
        //add this attributed string to the current position.
        noteText.textStorage.insert(attString, at: noteText.selectedRange.location)
        picker.dismiss(animated: true, completion: nil)
    }
}
