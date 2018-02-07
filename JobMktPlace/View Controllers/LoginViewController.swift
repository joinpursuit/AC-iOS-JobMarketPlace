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
    @IBOutlet weak var loginMessageLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private var authUserService = AuthUserService()
    private var isNewUser = true
    
    private var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginMessageLabel.text = ""
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        view.endEditing(true)
        guard let emailText = emailTextField.text else { loginMessageLabel.text = "email is nil"; return }
        guard !emailText.isEmpty else { loginMessageLabel.text = "email is empty"; return }
        guard let passwordText = passwordTextField.text else { loginMessageLabel.text = "password is nil"; return }
        guard !passwordText.isEmpty else { loginMessageLabel.text = "password is empty"; return }
        if isNewUser {
            authUserService.createUser(email: emailText, password: passwordText)
        } else {
            authUserService.signIn(email: emailText, password: passwordText)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        print("didCreateUser: \(user)")
        let tabController = TabBarController.storyboardInstance()
        present(tabController, animated: true, completion: nil)
    }
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        loginMessageLabel.text = error.localizedDescription
    }
    func didSignIn(_ userService: AuthUserService, user: User) {
        let tabController = TabBarController.storyboardInstance()
        present(tabController, animated: true, completion: nil)
    }
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
        loginMessageLabel.text = error.localizedDescription
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loginMessageLabel.text = ""
    }
}
