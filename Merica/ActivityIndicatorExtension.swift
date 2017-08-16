//
//  ActivityIndicatorExtension.swift
//  Merica
//
//  Created by Matt Deuschle on 8/15/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import UIKit

public protocol SpinnerPresenter {
    var spinner: UIActivityIndicatorView { get }
    func showSpinner()
    func hideSpinner()
}

public extension SpinnerPresenter where Self: UIViewController {
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinner.activityIndicatorViewStyle = .whiteLarge
            self.spinner.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            self.spinner.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.spinner)
            self.spinner.startAnimating()
        }
    }

    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
        }
    }
}
