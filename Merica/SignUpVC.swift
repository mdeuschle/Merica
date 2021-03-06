//
//  SignUpVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/7/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController {

    @IBOutlet var mericaLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var termsLabel: UILabel!
    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        notifications()
        tap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.termsTapped))
        termsLabel.addGestureRecognizer(tap)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func termsTapped() {
        if let url = URL(string: URLString.privacyPoliy.rawValue) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        if segue.identifier == Segue.signUpSuccess.rawValue {
            if let destination = segue.destination as? TabBarController {
                destination.didSignUp = true
            }
        }
    }

    func completeSignUp(id: String, userData: [String: String]) {
        DataService.shared.createFirebaseDBUser(uid: id, userData: userData)
        let keychain = KeychainWrapper.standard.set(id, forKey: KeyChain.uid.rawValue)
        print("DATA saved to keychain \(keychain)")
        emailTextField.text = ""
        userNameTextField.text = ""
        performSegue(withIdentifier: Segue.signUpSuccess.rawValue, sender: nil)
    }

    func performSignUp() {
        if let email = emailTextField.text,
            let userName = userNameTextField.text,
            let password = passwordTextField.text {
            if !email.isEmpty && !userName.isEmpty && !password.isEmpty {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.present(UIAlertController.withError(error: error!), animated: true, completion: nil)
                    } else {
                        if let user = user {
                            let profileRef = DataService.shared.refPics.child(DatabaseID.defaultProfile.rawValue)
                            profileRef.downloadURL { url, error in
                                if let error = error {
                                    self.present(UIAlertController.withError(error: error), animated: true, completion: nil)
                                } else {
                                    if let url = url {
                                        let userData = [DatabaseID.provider.rawValue: user.providerID,
                                                        DatabaseID.userName.rawValue: userName,
                                                        DatabaseID.estDate.rawValue: DateHelper.dateToMedString(),
                                                        DatabaseID.profileImageURL.rawValue: url.absoluteString]
                                        self.completeSignUp(id: user.uid, userData: userData)
                                    }
                                }
                            }
                        }
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

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSignUp()
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        logoImage.isHidden = true
        mericaLabel.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            switch textField {
            case emailTextField:
                userNameTextField.becomeFirstResponder()
            case userNameTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                performSignUp()
            default:
                textField.resignFirstResponder()
            }
        }
        return true
    }
}














