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

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
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
        if indexPath.row == 0 {
            KeychainWrapper.standard.removeObject(forKey: KeyChain.uid.rawValue)
            do {
                try Auth.auth().signOut()
                navigationController?.popViewController(animated: true)
            } catch {
                present(UIAlertController.withError(error: error),
                        animated: true,
                        completion: nil)
            }
        }
    }
}
