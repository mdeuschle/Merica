//
//  TermsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/28/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.


import WebKit

class TermsVC: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewControllerTitle.about.rawValue
        if let url = URL(string: URLString.privacyPoliy.rawValue) {
            webView.load(URLRequest(url: url))
        }
    }
}


