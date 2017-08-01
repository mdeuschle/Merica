//
//  MyUpVotesVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class MyUpVotesVC: UIViewController {

    @IBOutlet var postTableView: UITableView!
    var posts = [Post]()
    var selectedPost: Post!
    var postRef: DatabaseReference!
    var upVotesRef: DatabaseReference!
    var postHandler: UInt!
    var upVotesHandler: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        postRef = DataService.shared.refPosts
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readPostData()
        postHandler = postRef.observe(.value, with: { (snapshot) in })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: postHandler)
        if let ref = upVotesRef, let handler = upVotesHandler {
            ref.removeObserver(withHandle: handler)
        }
    }

    func readPostData() {
        postRef.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        self.upVotesRef = DataService.shared.upVotesRef(postKey: post.postKey)
                        self.upVotesRef.observeSingleEvent(of: .value, with: { (upVoteSnap) in
                            if let isUpVote = upVoteSnap.value as? Bool {
                                if isUpVote {
                                    self.posts.append(post)
                                    self.posts.sort(by: { $0.date > $1.date })
                                    self.postTableView.reloadData()
                                    self.upVotesHandler = self.upVotesRef.observe(.value, with: { (snapshot) in })
                                }
                            }
                        })
                    }
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.fromMyUpVotesToDetail.rawValue {
            if let destination = segue.destination as? DetailVC {
                destination.post = selectedPost
                destination.isMyUpVote = true
            }
        }
    }
}

extension MyUpVotesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.myUpVotesCell.rawValue) as? MyUpVotesCell else {
            return MyUpVotesCell()
        }
        cell.parentVC = self
        let post = posts[indexPath.row]
        cell.configCell(post: post)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: Segue.fromMyUpVotesToDetail.rawValue, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120
        return UITableViewAutomaticDimension
    }
}
