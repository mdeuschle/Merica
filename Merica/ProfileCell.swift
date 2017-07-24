//
//  ProfileCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/10/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(row: Int) {
        self.textLabel?.textColor = .white
        switch row {
        case 0:
            config(label: ProfileCellLabel.posts.rawValue, image: #imageLiteral(resourceName: "greyPost"))
        case 1:
            config(label: ProfileCellLabel.upVotes.rawValue, image: #imageLiteral(resourceName: "greyUpArrow"))
        case 2:
            config(label: ProfileCellLabel.favorites.rawValue, image: #imageLiteral(resourceName: "greyFavorite"))
        case 3:
            config(label: ProfileCellLabel.logOut.rawValue, image: #imageLiteral(resourceName: "greyLogout"))
        case 4:
            config(label: ProfileCellLabel.more.rawValue, image: #imageLiteral(resourceName: "greyMore"))

        default:
            break
        }
    }

    private func config(label: String, image: UIImage) {
        cellLabel.text = label
        cellImage.image = image
    }

}




