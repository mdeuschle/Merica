//
//  CommentsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {

    @IBOutlet var commentsTextField: UITextField!
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func postButtonTapped(_ sender: Any) {

    }
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.commentsCell.rawValue) as? CommentsCell else {
                return CommentsCell()
            }
            cell.configCell(post: post)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.commentsListCell.rawValue) as? CommentsListCell else {
                return CommentsListCell()
            }
            return cell
        default:
            return CommentsListCell()
        }
    }
}
