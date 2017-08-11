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
    var isMyPost = false
    var postRef: DatabaseReference!
    var handle: UInt!

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
        postRef = DataService.shared.refPosts
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: handle)
    }

    func reportButtonTapped(post: Post) {
        present(UIAlertController.actionSheet(handler1: { (action1) in
            print("ACTION 1 Tapped")
        }, handler2: { (action2) in
            print("ACTION 2 Tapped")
        }), animated: true, completion: nil)
    }

    func readPostData() {
        handle = postRef.observe(.value, with: { (snapshot) in
            if let _ = snapshot.children.allObjects as? [DataSnapshot] {
                self.detailTableView.reloadData()
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

