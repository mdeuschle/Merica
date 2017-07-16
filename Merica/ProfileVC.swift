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

    @IBOutlet var mericaPoints: UILabel!
    @IBOutlet var memeberSinceLabel: UILabel!
    @IBOutlet var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.title = name
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toMyPosts.rawValue {
            if let destination = segue.destination as? HomeVC {
                destination.isFromProfile = true
            }
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            tabBarController?.tabBar.isHidden = true
            performSegue(withIdentifier: Segue.toMyPosts.rawValue, sender: self)
        case 1:
            print("Up Votes")
        case 2:
            print("Comments")
        case 3:
            KeychainWrapper.standard.removeObject(forKey: KeyChain.uid.rawValue)
            do {
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            } catch {
                present(UIAlertController.withError(error: error),
                        animated: true,
                        completion: nil)
            }
        case 4:
            print("More")
        default:
            print("Default")
        }
    }
}








