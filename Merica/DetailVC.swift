//
//  DetailVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController {

    @IBOutlet var detailTableView: UITableView!
    @IBOutlet var deleteButton: UIBarButtonItem!

    var post: Post!
    var isMyPost = false
    var isMyUpVote = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        let cityAndState = post.cityName + Divider.pipe.rawValue + post.stateName
        title = cityAndState
        if isMyPost {
            navigationItem.rightBarButtonItem = deleteButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        if isMyPost {
            present(UIAlertController.withMessageAndAction(alertTitle: Alert.deletePost.rawValue,
                                                           alertMessage: post.postTitle,
                                                           actionButtonTitle: Alert.delete.rawValue,
                                                           handler: { action in
                                                            DataService.shared.refPosts.child(self.post.postKey).removeValue()
                                                            self.navigationController?.popViewController(animated: true)

            }), animated: true, completion: nil)
        }
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.detailCell.rawValue) as? DetailCell else {
            return DetailCell()
        }
        cell.parentVC = self
        if let image = HomeVC.imageCache.object(forKey: post.postImageURL as NSString) {
            cell.configCell(post: post, image: image)
        } else {
            cell.configCell(post: post)
        }
        return cell
    }
}

