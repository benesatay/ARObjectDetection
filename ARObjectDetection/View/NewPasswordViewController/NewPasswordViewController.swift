//
//  NewPasswordViewController.swift
//  ARObjectDetection
//
//  Created by Bahadır Enes Atay on 20.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import Firebase

class NewPasswordViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    override func viewDidLoad() {
        activityIndicator.isHidden = true
        super.viewDidLoad()
        setupNavigationBarItems()
        editTextFieldView()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        reAuthenticate(onSuccess: {
            self.setAlertWithoutAction(title: "Success", message: "Password Updated")
        })
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        resetPassword()
    }
    
    func reAuthenticate(onSuccess: @escaping () -> Void) {
        guard let oldPassword = oldPasswordTextField.text else { return }
        guard let newPassword = newPasswordTextField.text else { return }
        let user = Auth.auth().currentUser
        guard let email = user?.email else { return }
        self.activityIndicator.isHidden = false
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        user?.reauthenticate(with: credential, completion: { (data, error) in
            if error == nil {
                user?.updatePassword(to: newPassword, completion: { (error) in
                    if error == nil {
                        onSuccess()
                    }
                })
            }
            self.activityIndicator.isHidden = true
        })
    }
    
    func resetPassword() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        self.activityIndicator.isHidden = false
        Auth.auth().sendPasswordReset(withEmail: currentUserEmail) { (Error) in
            if Error == nil {
                self.setAlertWithAction(title: "Success", message: "Reset Password Link was sent to your email!")
            }
            self.activityIndicator.isHidden = true
        }
    }
    
    func editTextFieldView() {
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupNavigationBarItems() {
        let backButton = UIBarButtonItem()
        backButton.title = NSLocalizedString("Back", comment: "")
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
