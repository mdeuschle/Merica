//
//  MyPostsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class MyPostsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true

    }
}

extension MyPostsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.myPostsCell.rawValue) as? MyPostsCell else {
            return MyPostsCell()
        }
        return cell
    }
}
