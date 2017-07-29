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

    let myPosts = CellLabel(cellLabel: ProfileCellLabel.posts.rawValue, cellImage: #imageLiteral(resourceName: "greyPost"))
    let myUpVotes = CellLabel(cellLabel: ProfileCellLabel.upVotes.rawValue, cellImage: #imageLiteral(resourceName: "greyUpArrow"))
    let myFavorites = CellLabel(cellLabel: ProfileCellLabel.favorites.rawValue, cellImage: #imageLiteral(resourceName: "greyFavorite"))
    let more = CellLabel(cellLabel: ProfileCellLabel.more.rawValue, cellImage: #imageLiteral(resourceName: "greyMore"))

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(row: Int) {
        self.textLabel?.textColor = .white
        switch row {
        case 0:
            config(cellLabel: myPosts)
        case 1:
            config(cellLabel: myUpVotes)
        case 2:
            config(cellLabel: myFavorites)
        case 3:
            config(cellLabel: more)
        default:
            break
        }
    }

    private func config(cellLabel: CellLabel) {
        self.cellLabel.text = cellLabel.cellLabel
        self.cellImage.image = cellLabel.cellImage
    }
}




