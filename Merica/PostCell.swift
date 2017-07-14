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
    @IBOutlet var commentsImage: UIImageView!
    @IBOutlet var commentsCountLabel: UILabel!
    @IBOutlet var shareImage: UIView!
    @IBOutlet var shareLabel: UILabel!

    var post: Post!
    var votesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        upVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(upVotesTapped(sender:))))
        downVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(downVotesTapped(sender:))))
    }


    func upVotesTapped(sender: UITapGestureRecognizer) {
        votesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downVoteImage.isUserInteractionEnabled = false
                self.post.adjustUpVotes(didUpVote: true)
                self.votesRef.setValue(true)
            } else {
                self.downVoteImage.isUserInteractionEnabled = true
                self.post.adjustUpVotes(didUpVote: false)
                self.votesRef.removeValue()
            }
        })
    }

    func downVotesTapped(sender: UITapGestureRecognizer) {
        votesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upVoteImage.isUserInteractionEnabled = false
                self.post.adjustDownVotes(didDownVote: true)
                self.votesRef.setValue(true)
            } else {
                self.upVoteImage.isUserInteractionEnabled = true
                self.post.adjustDownVotes(didDownVote: false)
                self.votesRef.removeValue()
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
        votesRef = DataService.dataService.refCurrentUser.child(DatabaseID.votes.rawValue).child(post.postKey)

        postTitleLabel.text = post.postTitle
        timeStampLabel.text = DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
        locationLabel.text = post.location
        voteCountLabel.text = "\(post.votes)"


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
    }
}


