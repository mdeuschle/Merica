//
//  MapVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var posts = [Post]()
    var postAnnotation: MKPointAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()
        postAnnotation = MKPointAnnotation()
        getPosts {
            for post in self.posts {
                print("MAP POST: \(post.postTitle)")
            }
        }
    }

    func getPosts(handler: @escaping () -> ()) {
        DataService.shared.refPosts.observe(.value, with: { snapShot in
            self.posts = []
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)
                        self.posts.append(post)
                        handler()
                    }
                }
            }
        })
    }
}




