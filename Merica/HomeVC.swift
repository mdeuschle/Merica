//
//  HomeVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class HomeVC: UIViewController, DidTapUserProfile, ReportPost {

    @IBOutlet var postTableView: UITableView!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var postRef: DatabaseReference!
    var reportedPostRef: DatabaseReference!
    var handle: UInt!
    var reportedPostHandle: UInt!
    var userKey: String!
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        postRef = DataService.shared.refPosts
        reportedPostRef = DataService.shared.reportedPosts
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: handle)
        reportedPostRef.removeObserver(withHandle: reportedPostHandle)
    }

    func userProfileTapped(post: Post) {
        userKey = post.userKey
        userName = post.userName
    }

    func reportButtonTapped(post: Post) {
        present(UIAlertController.actionSheet(handler1: { (action1) in
            self.reportedPostRef.childByAutoId().setValue(post.postKey)
            print("ACTION 1 Tapped")
        }, handler2: { (action2) in
            print("ACTION 2 Tapped")
        }), animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
        postRef.removeObserver(withHandle: handle)
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
        cell.reportButtonDelegate = self
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



