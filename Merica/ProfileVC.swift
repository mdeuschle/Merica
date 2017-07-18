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

        DataService.shared.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.title = ViewControllerTitle.hi.rawValue + name
            }
        })
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
            filteredFeed(navTitle: ViewControllerTitle.myPosts.rawValue, selectedIndex: 0)
        case 1:
            filteredFeed(navTitle: ViewControllerTitle.myUpVotes.rawValue, selectedIndex: 1)
        case 2:
            print("Comments")
        case 3:
            KeychainWrapper.standard.removeObject(forKey: KeyChain.uid.rawValue)
            do {

                try Auth.auth().signOut()

                //TODO: Figure out how to go back to login

                presentingViewController?.dismiss(animated: true, completion: nil)

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

    func filteredFeed(navTitle: String, selectedIndex: Int) {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = true
        let navController = self.tabBarController?.viewControllers![0] as! UINavigationController
        let vc = navController.topViewController as! HomeVC
        vc.title = navTitle
        vc.readPostData()
        switch selectedIndex {
        case 0:
            vc.isMyPosts = true
        case 1:
            vc.isMyUpVotes = true
        case 2:
            vc.isMyComments = true
        default:
            break
        }
    }


}









