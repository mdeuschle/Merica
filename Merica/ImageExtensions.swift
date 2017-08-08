//
//  ImageExtensions.swift
//  Merica
//
//  Created by Matt Deuschle on 7/12/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(width: CGFloat) -> UIImage? {
        let height = CGFloat(ceil(width/self.size.width * self.size.height))
        let cgSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: cgSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}















