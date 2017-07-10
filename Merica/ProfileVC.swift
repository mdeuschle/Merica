//
//  ProfileVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var mericaPoints: UILabel!
    @IBOutlet var memeberSinceLabel: UILabel!
    @IBOutlet var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.dataService.refCurrentUser.child("userName").observeSingleEvent(of: .value, with: { (snapshot) in
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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.textColor = .white

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Logout"
            cell.imageView?.image = #imageLiteral(resourceName: "battery")
        default:
            cell.textLabel?.text = "Logout"
            cell.imageView?.image = #imageLiteral(resourceName: "battery")
        }
        return cell
    }

}










