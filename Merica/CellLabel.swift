//
//  CellLabel.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

class CellLabel {

    private var _cellLabel: String?
    private var _cellImage: UIImage?
    var cellLabel: String {
        return _cellLabel ?? ""
    }
    var cellImage: UIImage {
        return _cellImage ?? UIImage()
    }
    init(cellLabel: String, cellImage: UIImage) {
        _cellLabel = cellLabel
        _cellImage = cellImage
    }
}

