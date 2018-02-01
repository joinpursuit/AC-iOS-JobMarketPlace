//
//  AddJobViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class AddJobViewController: UITableViewController {
    
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public static func storyboardInstance() -> AddJobViewController {
        let storyboard = UIStoryboard(name: "AddJob", bundle: nil)
        let addJobViewController = storyboard.instantiateViewController(withIdentifier: "AddJobViewController") as! AddJobViewController
        return addJobViewController
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
