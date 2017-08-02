//
//  PostCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/10/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var upVoteImage: UIImageView!
    @IBOutlet var voteCountLabel: UILabel!
    @IBOutlet var downVoteImage: UIImageView!
    @IBOutlet var favoriteImage: UIImageView!
    @IBOutlet var saveLabel: UILabel!

    var post: Post!
    var upVotesRef: DatabaseReference!
    var downVotesRef: DatabaseReference!
    var favoriteRef: DatabaseReference!
    weak var parentVC = UIViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        upVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(upVotesTapped(sender:))))
        downVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(downVotesTapped(sender:))))
        favoriteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(favoriteTapped(sender:))))
        saveLabel.addGestureRecognizer(tapGestureGenerator(selector: #selector(favoriteTapped(sender:))))
    }

    func favoriteTapped(sender: UITapGestureRecognizer) {
        favoriteRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.favoriteImage.image = #imageLiteral(resourceName: "redFavorite")
                self.post.adjustFavorites(didFavorite: true)
                self.favoriteRef.setValue(true)
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

    func configCell(post: Post, image: UIImage? = nil) {
        self.post = post
        upVotesRef = DataService.shared.upVotesRef(postKey: post.postKey)
        downVotesRef = DataService.shared.downVotesRef(postKey: post.postKey)
        favoriteRef = DataService.shared.favoriteRef(postKey: post.postKey)
        postTitleLabel.text = post.postTitle
        self.timeStampLabel.text = post.userName + Divider.dot.rawValue + DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
        let location = post.cityName + Divider.pipe.rawValue + post.stateName
        locationLabel.text = location
        let totalVotes = post.upVotes - post.downVotes
        voteCountLabel.text = "\(totalVotes)"
        if image != nil {
            self.postImageView.image = image
        } else {
            let ref = Storage.storage().reference(forURL: post.postImageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImageView.image = img
                            HomeVC.imageCache.setObject(img, forKey: post.postImageURL as NSString)
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
    }

    @IBAction func shareTapped(_ sender: UIButton) {
        if let title = postTitleLabel.text, let image = postImageView.image {
            let vc = UIActivityViewController(activityItems: [title, image], applicationActivities: nil)
            parentVC?.present(vc, animated: true)
        }
    }
}



