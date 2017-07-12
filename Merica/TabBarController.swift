//
//  TabBarController.swift
//  Merica
//
//  Created by Matt Deuschle on 7/12/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var didSignUp = false
    var didLogIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomePopUp(didLogIn: didLogIn, didSignUp: didSignUp)
    }

    func welcomePopUp(didLogIn: Bool, didSignUp: Bool) {
        if didSignUp || didLogIn {
            DataService.dataService.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
                if let name = snapshot.value as? String {
                    var message = ""
                    if didLogIn {
                        message = Alert.welcomBack.rawValue + name + Alert.signInThanks.rawValue
                    } else {
                        message = Alert.welcome.rawValue + name + Alert.signUpThanks.rawValue
                    }
                    self.present(UIAlertController.withMessage(message: message), animated: true, completion: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
