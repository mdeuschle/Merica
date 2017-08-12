//
//  DetailVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController, ReportDetailPost {

    @IBOutlet var detailTableView: UITableView!
    @IBOutlet var deleteButton: UIBarButtonItem!

    var post: Post!
    var reportedUsers = [String]()
    var isMyPost = false
    var postRef: DatabaseReference!
    var reportedPost: DatabaseReference!
    var reportedUserRef: DatabaseReference!
    var currentUser: DatabaseReference!

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
        reportedPost = DataService.shared.reportedPosts
        currentUser = DataService.shared.refCurrentUser
    }

    func reportButtonTapped(post: Post) {
        reportedUserRef = DataService.shared.reportedUserRef(userKey: post.userKey)
        present(UIAlertController.actionSheet(handler1: { (action1) in
            self.reportedPost.childByAutoId().setValue(post.postKey)
            self.present(UIAlertController.withMessageAndTitle(title: Alert.objectional.rawValue, message: "\(post.postTitle)"), animated: true, completion: nil)
        }, handler2: { (action2) in
            self.reportedUserRef.setValue(true)
            self.present(UIAlertController.withMessageAndTitle(title: Alert.userBlocked.rawValue, message: "\(post.userName)"), animated: true, completion: self.removeBlockedUser)
        }), animated: true, completion: nil)
    }

    func removeBlockedUser() {
        getReportedUser { 
            if self.reportedUsers.contains(self.post.userKey) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func getReportedUser(handler: @escaping () -> ()) {
        currentUser.child(DatabaseID.reportedUsers.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snaps {
                    self.reportedUsers.append(snap.key)
                }
                handler()
            }
        })
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 320
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.detailCell.rawValue) as? DetailCell else {
            return DetailCell()
        }
        cell.parentVC = self
        cell.reportButtonDelegate = self
        cell.configCell(post: post)
        return cell
    }
}

