//
//  AlertControllerExtensions.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func withError(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: Alert.error.rawValue,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.ok.rawValue, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }

    static func withMessage(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.ok.rawValue, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
}



