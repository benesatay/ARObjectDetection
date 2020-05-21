//
//  SignInViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 18.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var resetPasswordOutlet: UIButton!
    
    @IBOutlet weak var textFieldView: UIView!
    override func viewDidLoad() {
        self.activityIndicator.isHidden = true
        super.viewDidLoad()
        editTextFieldView()
        setupText()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            setAlertWithAction(title: "Warning", message: "Email or password can not be null!")
            return
        }
        self.activityIndicator.isHidden = false
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            guard error == nil else {
                self.setAlertWithAction(title: "Warning", message: error?.localizedDescription ?? "Error")
                self.activityIndicator.isHidden = true
                return
            }
            self.signIn()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        self.activityIndicator.isHidden = false
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            setAlertWithAction(title: "Warning", message: "Email or password can not be null!" + "\n" + "Enter your email and password to top and click here!")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            guard error == nil else {
                self.setAlertWithAction(title: "Warning", message: error?.localizedDescription ?? "Error")
                return
            }
            self.signIn()
        }
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        resetPassword()
    }
    
    func editTextFieldView() {
        textFieldView.layer.cornerRadius = 5
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupText() {
        emailTextField.placeholder = NSLocalizedString("Email", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        signInLabel.text = NSLocalizedString("Sign In", comment: "")
        signUpOutlet.setTitle(NSLocalizedString("Create an Account", comment: ""), for: .normal)
        resetPasswordOutlet.setTitle(NSLocalizedString("Reset Password", comment: ""), for: .normal)
    }
    
    func signIn() {
        let customTabBarNavigationController = UINavigationController(rootViewController: CustomTabBarViewController())
        UIApplication.shared.keyWindow?.rootViewController = customTabBarNavigationController
    }
    
    func resetPassword() {
        if emailTextField.text?.isEmpty == true {
            setAlertWithAction(title: "Warning", message: "Enter your email to top and try again!")
        } else {
            self.activityIndicator.isHidden = false
            guard let userEmail = emailTextField.text else { return }
            Auth.auth().sendPasswordReset(withEmail: userEmail) { (Error) in
                self.setAlertWithAction(title: "Success", message: "Reset Password Link was sent to your email!")
            }
            self.activityIndicator.isHidden = true
        }
    }
}

extension SignInViewController {
    // hide keyboard when the user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
