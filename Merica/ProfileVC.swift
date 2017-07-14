//
//  ProfileVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var mericaPoints: UILabel!
    @IBOutlet var memeberSinceLabel: UILabel!
    @IBOutlet var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.usernameLabel.text = name
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.profileCell.rawValue) as? ProfileCell else {
            return UITableViewCell()
        }
        cell.configCell(row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Posts")
            performSegue(withIdentifier: Segue.toMyPosts.rawValue, sender: self)
        case 1:
            print("Up Votes")
        case 2:
            print("Comments")
        case 3:
            KeychainWrapper.standard.removeObject(forKey: KeyChain.uid.rawValue)
            do {
                try Auth.auth().signOut()
            } catch {
                present(UIAlertController.withError(error: error),
                        animated: true,
                        completion: nil)
            }
            performSegue(withIdentifier: Segue.toWelcomeVC.rawValue, sender: self)
        case 4:
            print("More")
        default:
            print("Default")
        }
    }
}








