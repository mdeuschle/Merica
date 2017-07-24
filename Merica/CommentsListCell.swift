//
//  CommentsListCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class CommentsListCell: UITableViewCell {

    @IBOutlet var nameAndTimeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var upVoteImage: UIImageView!
    @IBOutlet var upVoteCount: UILabel!
    @IBOutlet var downVoteImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configCell(post: Post) {
        
        

    }
}
