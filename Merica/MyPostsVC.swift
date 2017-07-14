//
//  MyPostsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/14/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class MyPostsVC: UIViewController {

    @IBOutlet var myPostTableView: UITableView!
    static var myImageCache: NSCache<NSString, UIImage> = NSCache()
    var myPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readMyPostData()
    }

    func readMyPostData() {
        DataService.dataService.refPosts.observe(.value, with: { (snapshot) in
            self.myPosts = []
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    print("SNAP!: \(snap)")
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        self.myPosts.append(post)
                    }
                }
            }
            self.myPostTableView.reloadData()
        })
    }
}

extension MyPostsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 320
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.myPostCell.rawValue) as? MyPostCell else {
            return MyPostCell()
        }
        let myPost = myPosts[indexPath.row]
        if let image = MyPostsVC.myImageCache.object(forKey: myPost.postImageURL as NSString) {
            cell.myConfigCell(myPost: myPost, myImage: image)
        } else {
            cell.myConfigCell(myPost: myPost)
        }
        return cell
    }
}


