//
//  MyFavoritesVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class MyFavoritesVC: UIViewController {

    @IBOutlet var postTableView: UITableView!

    var posts = [Post]()
    var reportedUsers = [String]()
    var selectedPost: Post!
    var favoritesRef: DatabaseReference!
    var postRef: DatabaseReference!
    var currentUser: DatabaseReference!
    var favoritesHandler: UInt!
    var postHandler: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        postRef = DataService.shared.refPosts
        currentUser = DataService.shared.refCurrentUser
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: postHandler)
        if let ref = favoritesRef, let handler = favoritesHandler {
            ref.removeObserver(withHandle: handler)
        }
    }

    func readPostData() {
        postHandler = postRef.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        self.favoritesRef = DataService.shared.favoriteRef(postKey: post.postKey)
                        self.favoritesRef.observeSingleEvent(of: .value, with: { (favoriteSnap) in
                            if let isFavorite = favoriteSnap.value as? Bool {
                                if isFavorite {


                                    self.getReportedUser {
                                        if self.reportedUsers.contains(post.userKey) {
                                            self.posts.sort(by: { $0.date > $1.date })
                                            self.postTableView.reloadData()
                                            self.favoritesHandler = self.favoritesRef.observe(.value, with: { (snapshot) in })
                                        } else {
                                            self.posts.append(post)
                                            self.posts.sort(by: { $0.date > $1.date })
                                            self.postTableView.reloadData()
                                            self.favoritesHandler = self.favoritesRef.observe(.value, with: { (snapshot) in })
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.fromMyFavoritesToDetail.rawValue {
            if let destination = segue.destination as? DetailVC {
                destination.post = selectedPost
            }
        }
    }
}

extension MyFavoritesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.myFavoritesCell.rawValue) as? MyFavoritesCell else {
            return MyFavoritesCell()
        }
        cell.parentVC = self
        let post = posts[indexPath.row]
        cell.configCell(post: post)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: Segue.fromMyFavoritesToDetail.rawValue, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120
        return UITableViewAutomaticDimension
    }
}
