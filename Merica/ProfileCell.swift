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
            config(label: ProfileCellLabel.logOut.rawValue, image: #imageLiteral(resourceName: "battery"))
        default:
            config(label: "Take 2", image: #imageLiteral(resourceName: "battery"))
        }
    }

    private func config(label: String, image: UIImage) {
        self.textLabel?.text = label
        self.imageView?.image = image

    }

}




