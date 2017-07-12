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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(post: Post, image: UIImage? = nil) {
        self.post = post
        postTitleLabel.text = post.postTitle

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
                            HomeVC.imageCache.setObject(img, forKey: post.postImageURL as? String)
                        }
                    }
                }
            })
        }
    }
}


