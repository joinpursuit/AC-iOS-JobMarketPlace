//
//  JobsFeedViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class JobsFeedViewController: UIViewController {

    private var authUserService = AuthUserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Jobs"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "sign out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJob))
    }
    
    @objc private func signOut() {
        authUserService.signOut()
    }
    
    @objc private func addJob() {
        //DBService.manager.addJob(title: "Need Swift help!!!!", description: "I can't understand custom delegation :-((((((")
        //DBService.manager.addJob(title: "Leaking faucet, NEED PLUMBER", description: "I am experiencing a leaky faucet. Please Help! Estimations are welcome")
        let addJobVC = AddJobViewController.storyboardInstance()
        addJobVC.modalTransitionStyle = .crossDissolve
        addJobVC.modalPresentationStyle = .overCurrentContext
        let navController = UINavigationController(rootViewController: addJobVC)
        present(navController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension JobsFeedViewController: AuthUserServiceDelegate {
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginViewController.storyboardInstance()
        tabBarController?.tabBar.isHidden = true
        navigationController?.viewControllers = [loginVC]
    }
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        showAlert(title: "Error Signing Out", message: error.localizedDescription)
    }
}


