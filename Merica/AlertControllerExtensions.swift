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

    static func withMessageAndAction(alertTitle: String, alertMessage: String, actionButtonTitle: String, handler: @escaping ((UIAlertAction!) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let removeAction = UIAlertAction(title: actionButtonTitle,
                                         style: .destructive,
                                         handler: handler)
        alert.addAction(removeAction)
        let cancelAction = UIAlertAction(title: Alert.cancel.rawValue,
                                         style: .default,
                                         handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
}

