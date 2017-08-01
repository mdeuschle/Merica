//
//  TabBarController.swift
//  Merica
//
//  Created by Matt Deuschle on 7/12/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var didSignUp = false
    var didLogIn = false
    var currentUserRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        welcomePopUp(didLogIn: didLogIn, didSignUp: didSignUp)
        currentUserRef = DataService.shared.refCurrentUser
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func welcomePopUp(didLogIn: Bool, didSignUp: Bool) {
        if didSignUp || didLogIn {
            currentUserRef.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
                if let name = snapshot.value as? String {
                    var message = ""
                    if didLogIn {
                        message = Alert.welcomBack.rawValue + name + "!"
                    } else {
                        message = Alert.welcome.rawValue + name + Alert.signUpThanks.rawValue
                    }
                    self.present(UIAlertController.withMessage(message: message), animated: true, completion: nil)
                }
            })
        }
    }
}
