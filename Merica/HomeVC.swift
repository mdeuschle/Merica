//
//  HomeVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, DidTapUserProfile {

    @IBOutlet var postTableView: UITableView!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var postRef: DatabaseReference!
    var handle: UInt!
    var userKey: String!
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        postRef = DataService.shared.refPosts
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: handle)
    }

    func userProfileTapped(post: Post) {
        userKey = post.userKey
        userName = post.userName
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.fromHomeToUserPosts.rawValue {
            if let destination = segue.destination as? UserPostsVC {
                destination.userKey = userKey
                destination.userName = userName
            }
        }
    }
    
    func readPostData() {
        handle = postRef.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        self.posts.append(post)
                        self.postTableView.reloadData()
                        self.posts = SortHelper.sortPosts(posts: self.posts)
                    }
                }
            }
        })
    }

    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        print("UNWIND WORKED")
        dismiss(animated: false, completion: nil)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 320
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.postCell.rawValue) as? PostCell else {
            return PostCell()
        }
        cell.parentVC = self
        cell.userProfileTappedDelegate = self
        let post = posts[indexPath.row]
        if let image = HomeVC.imageCache.object(forKey: post.postImageURL as NSString),
            let profileImage = HomeVC.imageCache.object(forKey: post.profileImageURL as NSString) {
            cell.configCell(post: post, image: image, profileImage: profileImage)
        } else {
            cell.configCell(post: post)
        }
        return cell
    }
}



