//
//  UserPostsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 8/4/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class UserPostsVC: UIViewController {

    @IBOutlet var postTableView: UITableView!

    var posts = [Post]()
    var selectedPost: Post!
    var userKey: String!
    var userName: String!
    var postData: DatabaseReference!
    var handle: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        postData = DataService.shared.refPosts
        title = userName
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postData.removeObserver(withHandle: handle)
    }

    func readPostData() {
        handle = postData.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        if post.userKey == self.userKey {
                            self.posts.append(post)
                            self.posts.sort(by: { $0.date > $1.date })
                        }
                    }
                }
            }
            self.postTableView.reloadData()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.fromUserPostsToDetail.rawValue {
            if let destination = segue.destination as? DetailVC {
                destination.post = selectedPost
            }
        }
    }
}

extension UserPostsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.userPostsCell.rawValue) as? UserPostsCell else {
            return UserPostsCell()
        }
        cell.parentVC = self
        let post = posts[indexPath.row]
        cell.configCell(post: post)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: Segue.fromUserPostsToDetail.rawValue, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120
        return UITableViewAutomaticDimension
    }
}
