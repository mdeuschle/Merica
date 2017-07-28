//
//  HomeVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet var postTableView: UITableView!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var posts = [Post]()
    var isMyPosts = false
    var isMyUpVotes = false
    var isMyFavorites = false
    var backButton: UIBarButtonItem!
    var upVotesRef: DatabaseReference!
    var favoritesRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        readPostData()
        configBackButton()
    }

    func configBackButton() {
        backButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(HomeVC.backButtonTapped))
        backButton.isEnabled = false
        navigationItem.leftBarButtonItem = backButton
    }

    func backButtonTapped() {
        tabBarController?.selectedIndex = 3
        tabBarController?.tabBar.isHidden = false
        title = ViewControllerTitle.merica.rawValue
        isMyPosts = false
        isMyUpVotes = false
        isMyFavorites = false
        readPostData()
    }

    func enableBackButton(enableButton: Bool) {
        if enableButton {
            backButton.image = #imageLiteral(resourceName: "greyBack")
            backButton.isEnabled = true
        } else {
            backButton.image = UIImage()
            backButton.isEnabled = false
        }
    }

    func readPostData() {
        DataService.shared.refPosts.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    print("SNAP!: \(snap)")
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)

                        self.upVotesRef = DataService.shared.refCurrentUser.child(DatabaseID.upVotes.rawValue).child(post.postKey)
                        self.favoritesRef = DataService.shared.refCurrentUser.child(DatabaseID.isFavorite.rawValue).child(post.postKey)

                        switch (self.isMyPosts, self.isMyUpVotes, self.isMyFavorites) {
                        case (true, false, false):
                            self.enableBackButton(enableButton: true)
                            if let currentUserID = Auth.auth().currentUser?.uid {
                                if currentUserID == post.userKey {
                                    self.posts.append(post)
                                    self.posts.sort(by: { $0.date > $1.date })
                                }
                            }
                        case (false, true, false):
                            self.enableBackButton(enableButton: true)
                            self.upVotesRef.observeSingleEvent(of: .value, with: { (upVoteSnap) in
                                if let upVote = upVoteSnap.value as? Bool {
                                    if upVote {
                                        self.posts.append(post)
                                        self.posts.sort(by: { $0.date > $1.date })
                                        self.postTableView.reloadData()
                                        print("MY POST: \(post.postTitle)")
                                    }
                                }
                            })

                        case (false, false, true):

                            self.enableBackButton(enableButton: true)
                            self.favoritesRef.observeSingleEvent(of: .value, with: { (favSnap) in
                                if let favorite = favSnap.value as? Bool {
                                    if favorite {
                                        self.posts.append(post)
                                        self.posts.sort(by: { $0.date > $1.date })
                                        self.postTableView.reloadData()
                                        print("MY POST: \(post.postTitle)")
                                    }
                                }
                            })

//
//                            self.enableBackButton(enableButton: true)
//                            if post.isFavorite {
//                                self.posts.append(post)
//                                self.posts.sort(by: { $0.date > $1.date })
//                            }
                        default:
                            self.enableBackButton(enableButton: false)
                            self.posts.append(post)
                            self.posts = SortHelper.sortPosts(posts: self.posts)
                        }
                    }
                }
            }
            self.postTableView.reloadData()
        })
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate, ShareButtonTapped {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 320
        return UITableViewAutomaticDimension
    }

    func shareButtonTapped(title: String, image: UIImage) {
        let vc = UIActivityViewController(activityItems: [title, image], applicationActivities: nil)
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.postCell.rawValue) as? PostCell else {
            return PostCell()
        }
        cell.shareButtonDelegate = self
        cell.disableViews(isMyUpVotes: isMyUpVotes, isMyFavorites: isMyFavorites)
        let post = posts[indexPath.row]
        if let image = HomeVC.imageCache.object(forKey: post.postImageURL as NSString) {
            cell.configCell(post: post, image: image)
        } else {
            cell.configCell(post: post)
        }
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(HomeVC.removePost(recognizer:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }

    func removePost(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began && isMyPosts {
            if let cell = recognizer.view as? UITableViewCell {
                if let indexPath = postTableView.indexPath(for: cell) {
                    let post = posts[indexPath.row]
                    present(UIAlertController.withMessageAndAction(alertTitle: Alert.deletePost.rawValue,
                                                                   alertMessage: post.postTitle,
                                                                   actionButtonTitle: Alert.delete.rawValue,
                                                                   handler: { action in
                                                                    self.posts.remove(at: indexPath.row)
                                                                    DataService.shared.refPosts.child(post.postKey).removeValue()
                                                                    self.postTableView.reloadData()
                    }), animated: true, completion: nil)
                }
            }
        }
    }
}



