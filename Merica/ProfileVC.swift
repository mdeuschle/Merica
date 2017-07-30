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
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        DataService.shared.refCurrentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.title = ViewControllerTitle.hi.rawValue + name
            }
        })
        DataService.shared.refCurrentUser.child(DatabaseID.estDate.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let timeStamp = snapshot.value as? String {
                self.memeberSinceLabel.text =  ProfileCellLabel.est.rawValue + timeStamp
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
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
            vc.isMyFavorites = true
        default:
            break
        }
    }
    
    
}









