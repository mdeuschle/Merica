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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        welcomePopUp(didLogIn: didLogIn, didSignUp: didSignUp)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func welcomePopUp(didLogIn: Bool, didSignUp: Bool) {
        if didSignUp || didLogIn {
            DataService.shared.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
                if let name = snapshot.value as? String {
                    var message = ""
                    if didLogIn {
                        message = Alert.welcomBack.rawValue + name + "!"
                    } else {
                        message = Alert.welcome.rawValue + name
                    }
                    self.present(UIAlertController.withMessage(message: message), animated: true, completion: nil)
                }
            })
        }
    }
}
