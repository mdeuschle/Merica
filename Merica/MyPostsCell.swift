//
//  MyPostsCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class MyPostsCell: UITableViewCell {

    @IBOutlet var myPostTitleLabel: UILabel!
    @IBOutlet var myUpVoteImage: UIImageView!
    @IBOutlet var myVoteCountLabel: UILabel!
    @IBOutlet var myDownVoteImage: UIImageView!
    @IBOutlet var myFavoriteImage: UIImageView!
    @IBOutlet var mySaveLabel: UILabel!
    @IBOutlet var myShareLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
