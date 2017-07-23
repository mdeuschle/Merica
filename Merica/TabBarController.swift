//
//  TabBarController.swift
//  Merica
//
//  Created by Matt Deuschle on 7/12/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var didSignUp = false
    var didLogIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        welcomePopUp(didLogIn: didLogIn, didSignUp: didSignUp)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 2, 3:
            UIApplication.shared.statusBarStyle = .default
            UINavigationBar.appearance().barTintColor = .mintGreen()
        default:
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    func welcomePopUp(didLogIn: Bool, didSignUp: Bool) {
        if didSignUp || didLogIn {
            DataService.shared.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
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
