//
//  CommentsCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class CommentsCell: UITableViewCell {

    @IBOutlet var postTitleLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(post: Post) {
        postTitleLabel.text = post.postTitle
        timeStampLabel.text = DateHelper.calcuateTimeStamp(dateString: post.timeStamp)
        let location = post.cityName + Divider.pipe.rawValue + post.stateName
        locationLabel.text = location
        let ref = Storage.storage().reference(forURL: post.postImageURL)
        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("Unable to download image from Firebase storage")
            } else {
                print("Image downloaded from Firebase storage")
                if let imageData = data {
                    if let img = UIImage(data: imageData) {
                        self.postImageView.image = img
                    }
                }
            }
        })
    }
}
