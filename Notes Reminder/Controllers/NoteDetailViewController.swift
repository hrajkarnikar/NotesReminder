//
//  NoteDetailViewController.swift
//  Notes Reminder
//
//  Created by Heema Rajkarnikar on 4/25/18.
//  Copyright © 2018 Heema Rajkarnikar. All rights reserved.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {
    
    
    
    var selectedNote : Notes? {
        didSet{
            
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
