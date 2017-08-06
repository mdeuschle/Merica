//
//  PostCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/10/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

protocol DidTapUserProfile {
    func userProfileTapped(post: Post)
}

class PostCell: UITableViewCell {

    @IBOutlet var userView: CircleView!
    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var upVoteImage: UIImageView!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var downVoteImage: UIImageView!
    @IBOutlet var favoriteImage: UIImageView!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var logoImage: UIImageView!

    var post: Post!
    var upVotesRef: DatabaseReference!
    var downVotesRef: DatabaseReference!
    var favoriteRef: DatabaseReference!
    var currentUser: DatabaseReference!
    var isTopPostRef: DatabaseReference!
    weak var parentVC = UIViewController()
    var userProfileTappedDelegate: DidTapUserProfile?
    weak var appDelegate: AppDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        upVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(upVotesTapped(sender:))))
        downVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(downVotesTapped(sender:))))
        favoriteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(favoriteTapped(sender:))))
        saveLabel.addGestureRecognizer(tapGestureGenerator(selector: #selector(favoriteTapped(sender:))))
        userView.addGestureRecognizer(tapGestureGenerator(selector: #selector(userTapped(sender:))))
        currentUser = DataService.shared.refCurrentUser
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        logoImage.isHidden = true
    }

    func userTapped(sender: UITapGestureRecognizer) {
        if let delegate = userProfileTappedDelegate, let vc = parentVC {
            delegate.userProfileTapped(post: post)
            vc.performSegue(withIdentifier: Segue.fromHomeToUserPosts.rawValue, sender: vc)
        }
    }

    func favoriteTapped(sender: UITapGestureRecognizer) {
        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.favoriteImage.image = #imageLiteral(resourceName: "redFavorite")
                self.post.adjustFavorites(didFavorite: true)
                self.favoriteRef.setValue(true)
                self.appDelegate?.scheduleNotification(post: self.post, message: NotificationMessage.favorite.rawValue)
            } else {
                self.favoriteImage.image = #imageLiteral(resourceName: "greyFavorite")
                self.post.adjustFavorites(didFavorite: false)
                self.favoriteRef.removeValue()
            }
        })
    }

    func upVotesTapped(sender: UITapGestureRecognizer) {
        upVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upVoteImage.image = #imageLiteral(resourceName: "greenUpArrow")
                self.downVoteImage.isUserInteractionEnabled = false
                self.post.adjustUpVotes(didUpVote: true)
                self.upVotesRef.setValue(true)
                self.appDelegate?.scheduleNotification(post: self.post, message: NotificationMessage.upvote.rawValue)
            } else {
                self.upVoteImage.image = #imageLiteral(resourceName: "greyUpArrow")
                self.downVoteImage.isUserInteractionEnabled = true
                self.post.adjustUpVotes(didUpVote: false)
                self.upVotesRef.removeValue()
            }
        })
    }

    func downVotesTapped(sender: UITapGestureRecognizer) {
        downVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downVoteImage.image = #imageLiteral(resourceName: "greenDownArrow")
                self.upVoteImage.isUserInteractionEnabled = false
                self.post.adjustDownVotes(didDownVote: true)
                self.downVotesRef.setValue(true)
            } else {
                self.downVoteImage.image = #imageLiteral(resourceName: "greyDownArrow")
                self.upVoteImage.isUserInteractionEnabled = true
                self.post.adjustDownVotes(didDownVote: false)
                self.downVotesRef.removeValue()
            }
        })
    }

    func tapGestureGenerator(selector: Selector?) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap = UITapGestureRecognizer(target: self, action: selector)
        tap.numberOfTapsRequired = 1
        return tap
    }

    func configCell(post: Post, posts: [Post], image: UIImage? = nil, profileImage: UIImage? = nil) {
        self.post = post
        upVotesRef = DataService.shared.upVotesRef(postKey: post.postKey)
        downVotesRef = DataService.shared.downVotesRef(postKey: post.postKey)
        favoriteRef = DataService.shared.favoriteRef(postKey: post.postKey)
        isTopPostRef = DataService.shared.topPostRef(postKey: post.postKey)
        postTitleLabel.text = post.postTitle
        timeStampLabel.text = post.userName + Divider.dot.rawValue + DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
        let location = post.cityName + Divider.pipe.rawValue + post.stateName
        locationLabel.text = location
        let totalVotes = post.upVotes - post.downVotes
        voteCountLabel.text = "\(totalVotes)"
        if post === posts.first {
            logoImage.isHidden = false
            self.post.adjustTopPost(isTopPost: true)
            isTopPostRef.setValue(true)
        }
        if image != nil {
            self.postImageView.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.postImageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download post image from Firebase storage")
                } else {
                    print("Post image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImageView.image = img
                            HomeVC.imageCache.setObject(img, forKey: post.postImageURL as NSString)
                        }
                    }
                }
            })
        }
        if profileImage != nil {
            self.userView.image = profileImage
        } else {
            let profileRef = Storage.storage().reference(forURL: post.profileImageURL)
            profileRef.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download profile image from Firebase storage")
                } else {
                    print("profile image downloaded from Firebase storage")
                    if let profileImage = data {
                        if let profileImg = UIImage(data: profileImage) {
                            self.userView.image = profileImg
                            HomeVC.imageCache.setObject(profileImg, forKey: post.profileImageURL as NSString)
                        }
                    }
                }
            })
        }
        upVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upVoteImage.image = #imageLiteral(resourceName: "greyUpArrow")
            } else {
                self.upVoteImage.image = #imageLiteral(resourceName: "greenUpArrow")
            }
        })
        downVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downVoteImage.image = #imageLiteral(resourceName: "greyDownArrow")
            } else {
                self.downVoteImage.image = #imageLiteral(resourceName: "greenDownArrow")
            }
        })
        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.favoriteImage.image = #imageLiteral(resourceName: "greyFavorite")
            } else {
                self.favoriteImage.image = #imageLiteral(resourceName: "redFavorite")
            }
        })
        isTopPostRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.logoImage.isHidden = true
            } else {
                self.logoImage.isHidden = false
            }
        })
    }

    @IBAction func shareTapped(_ sender: UIButton) {
        if let title = postTitleLabel.text, let image = postImageView.image {
            let vc = UIActivityViewController(activityItems: [title, image], applicationActivities: nil)
            parentVC?.present(vc, animated: true)
        }
    }
}






