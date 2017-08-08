//
//  CircleView.swift
//  Merica
//
//  Created by Matt Deuschle on 8/1/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}

