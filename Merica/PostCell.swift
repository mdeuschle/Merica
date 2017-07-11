//
//  PostCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/10/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
