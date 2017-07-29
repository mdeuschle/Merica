//
//  DetailVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/29/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController {

    @IBOutlet var detailTableView: UITableView!
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.detailCell.rawValue) as? DetailCell else {
            return DetailCell()
        }
        cell.parentVC = self
        if let image = HomeVC.imageCache.object(forKey: post.postImageURL as NSString) {
            cell.configCell(post: post, image: image)
        } else {
            cell.configCell(post: post)
        }
        return cell
    }
}

