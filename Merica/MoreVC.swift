//
//  MoreVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MoreVC: UIViewController {

    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
}

extension MoreVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.moreCell.rawValue) as? MoreCell else {
            return MoreCell()
        }
        cell.configCell(row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            do {
                try Auth.auth().signOut()
                KeychainWrapper.standard.removeObject(forKey: KeyChain.uid.rawValue)
                if let isWelcomeRoot = appDelegate.isWelcomeRoot {
                    if isWelcomeRoot {
                        performSegue(withIdentifier: Segue.unwindToWelcome.rawValue, sender: self)
                    } else {
                        let storyboard = UIStoryboard(name: StoryboardID.main.rawValue, bundle: nil)
                        if let vc = storyboard.instantiateViewController(withIdentifier: StoryboardID.welcome.rawValue) as? WelcomeVC {
                            appDelegate.window?.rootViewController = vc
                            performSegue(withIdentifier: Segue.unwindToHome.rawValue, sender: self)
                        }
                    }
                }
            } catch {
                present(UIAlertController.withError(error: error),
                        animated: true,
                        completion: nil)
            }
        case 1:
            performSegue(withIdentifier: Segue.toTermsVC.rawValue, sender: self)
        default:
            break
        }
    }
}


