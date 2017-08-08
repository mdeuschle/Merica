//
//  MoreCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var cellLabel: UILabel!

    let logOut = CellLabel(cellLabel: ProfileCellLabel.logOut.rawValue, cellImage: #imageLiteral(resourceName: "greyLogout"))
    let privacyPolicy = CellLabel(cellLabel: ProfileCellLabel.privacyPolicy.rawValue, cellImage: #imageLiteral(resourceName: "help"))

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(row: Int) {
        self.textLabel?.textColor = .white
        switch row {
        case 0:
            config(cellLabel: logOut)
        case 1:
            config(cellLabel: privacyPolicy)
        default:
            break
        }
    }

    private func config(cellLabel: CellLabel) {
        self.cellLabel.text = cellLabel.cellLabel
        self.cellImage.image = cellLabel.cellImage
    }
}
