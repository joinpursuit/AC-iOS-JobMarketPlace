//
//  ProfileViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Profile"
    }

}
