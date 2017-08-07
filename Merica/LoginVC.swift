//
//  LoginVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/7/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var mericaLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        notifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func showKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func hideKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.logInSuccess.rawValue {
            if let destination = segue.destination as? TabBarController {
                destination.didLogIn = true
            }
        }
    }

    func performLogin() {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            if !email.isEmpty && !password.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.present(UIAlertController.withError(error: error!),
                                     animated: true,
                                     completion: nil)
                    } else {
                        print("Sign in success!")
                        if let user = user {
                            KeychainWrapper.standard.set(user.uid, forKey: KeyChain.uid.rawValue)
                        } else {
                            self.present(UIAlertController.withMessage(message: Alert.error.rawValue),
                                         animated: true,
                                         completion: nil)
                        }
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: Segue.logInSuccess.rawValue, sender: self)
                    }
                })
            } else {
                present(UIAlertController.withMessage(message: Alert.emptyFields.rawValue),
                        animated: true,
                        completion: nil)
            }
        } else {
            present(UIAlertController.withMessage(message: Alert.emptyFields.rawValue),
                    animated: true,
                    completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performLogin()
    }
}

extension LoginVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        logoImage.isHidden = true
        mericaLabel.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            } else {
                performLogin()
            }
        }
        return true
    }
}







