//
//  ColorExtension.swift
//  Merica
//
//  Created by Matt Deuschle on 7/18/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithRGBHex(hex24: UInt) -> UIColor {
        return UIColor(
            red:    (CGFloat)((hex24 & 0xFF0000) >> 16) / 255.0,
            green:  (CGFloat)((hex24 & 0x00FF00) >> 8) / 255.0,
            blue:   (CGFloat)((hex24 & 0x0000FF) >> 0) / 255.0,
            alpha:  1.0)
    }
    class func mintGreen() -> UIColor
    {
        return colorWithRGBHex(hex24: 0x64ECE5)
    }
}
