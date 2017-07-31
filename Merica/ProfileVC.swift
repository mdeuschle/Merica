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

    @IBOutlet var memeberSinceLabel: UILabel!
    @IBOutlet var userTableView: UITableView!
    var currentUser: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = DataService.shared.refCurrentUser
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        currentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.title = ViewControllerTitle.hi.rawValue + name
            }
            DataService.shared.refCurrentUser.removeAllObservers()
        })
        currentUser.child(DatabaseID.estDate.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let timeStamp = snapshot.value as? String {
                self.memeberSinceLabel.text =  ProfileCellLabel.est.rawValue + timeStamp
            }
            DataService.shared.refCurrentUser.removeAllObservers()
        })
        tabBarController?.tabBar.isHidden = false
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            performSegue(withIdentifier: Segue.toMyPosts.rawValue, sender: self)
        case 1:
            performSegue(withIdentifier: Segue.toMyUpVotes.rawValue, sender: self)
        case 2:
            performSegue(withIdentifier: Segue.toMyFavorites.rawValue, sender: self)
        case 3:
            performSegue(withIdentifier: Segue.toMoreVC.rawValue, sender: self)
        default:
            print("Default")
        }
    }
}









