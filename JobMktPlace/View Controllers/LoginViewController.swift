//
//  LoginViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private var authUserService = AuthUserService()
    private var isNewUser = true

    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
    }
    
    public static func storyboardInstance() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }
    
    // updates the UI for the Login Screen
    @IBAction func toggleAuthentication(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        if buttonTitle == "sign in" {
            signInButton.setTitle("sign up", for: .normal)
            submitButton.setTitle("login", for: .normal)
            isNewUser = false
        } else {
            signInButton.setTitle("sign in", for: .normal)
            submitButton.setTitle("create account", for: .normal)
            isNewUser = true
        }
    }
    
    // either creates new user or sign existing user
    @IBAction private func authActionButtonPressed() {
        guard let emailText = emailTextField.text else { print("email is nil"); return }
        guard !emailText.isEmpty else { print("email is empty"); return }
        guard let passwordText = passwordTextField.text else { print("password is nil"); return }
        guard !passwordText.isEmpty else { print("password is empty"); return }
        if isNewUser {
            authUserService.createUser(email: emailText, password: passwordText)
        } else {
            authUserService.signIn(email: emailText, password: passwordText)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        print("didCreateUser: \(user)")
        let tabController = TabBarController.storyboardInstance()
        present(tabController, animated: true, completion: nil)
    }
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        showAlert(title: "Error Creating User", message: error.localizedDescription)
    }
    func didSignIn(_ userService: AuthUserService, user: User) {
        let tabController = TabBarController.storyboardInstance()
        present(tabController, animated: true, completion: nil)
    }
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
        showAlert(title: "Error Signing in User", message: error.localizedDescription)
    }
}
