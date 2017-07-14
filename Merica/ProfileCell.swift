//
//  ProfileCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/10/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(row: Int) {
        self.textLabel?.textColor = .white
        switch row {
        case 0:
            config(label: ProfileCellLabel.posts.rawValue, image: #imageLiteral(resourceName: "greyPost"))
        case 1:
            config(label: ProfileCellLabel.upVotes.rawValue, image: #imageLiteral(resourceName: "greyUpArrow"))
        case 2:
            config(label: ProfileCellLabel.comments.rawValue, image: #imageLiteral(resourceName: "greyComments"))
        case 3:
            config(label: ProfileCellLabel.logOut.rawValue, image: #imageLiteral(resourceName: "greyLogout"))
        case 4:
            config(label: ProfileCellLabel.more.rawValue, image: #imageLiteral(resourceName: "greyMore"))

        default:
            break
        }
    }

    private func config(label: String, image: UIImage) {
        self.textLabel?.text = label
        self.imageView?.image = image

    }

}




