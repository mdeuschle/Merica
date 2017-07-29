//
//  MyPostsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class MyPostsVC: UIViewController {

    @IBOutlet var postTableView: UITableView!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        readPostData()
    }

    func readPostData() {
        DataService.shared.refPosts.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    print("SNAP!: \(snap)")
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)

                        if let currentUserID = Auth.auth().currentUser?.uid {
                            if currentUserID == post.userKey {
                                self.posts.append(post)
                                self.posts.sort(by: { $0.date > $1.date })
                            }
                        }

                    }
                }
            }
            self.postTableView.reloadData()
        })
    }
}

extension MyPostsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.myPostsCell.rawValue) as? MyPostsCell else {
            return MyPostsCell()
        }
        cell.parentViewController = self
        let post = posts[indexPath.row]
        cell.configCell(post: post)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120
        return UITableViewAutomaticDimension
    }
}
