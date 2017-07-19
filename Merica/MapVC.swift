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
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var posts = [Post]()
    var postAnnotation: MKPointAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()
        postAnnotation = MKPointAnnotation()
        getPosts {
            self.dropPins()
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PostAnnotation) {
            return nil
        }
        var annotatedView = mapView.dequeueReusableAnnotationView(withIdentifier: ReusableID.mapView.rawValue)
        if annotatedView == nil {
            annotatedView = MKAnnotationView(annotation: annotation, reuseIdentifier: ReusableID.mapView.rawValue)
            annotatedView?.canShowCallout = true
            annotatedView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            annotatedView?.annotation = annotation
        }
        let postAnnotation = annotation as! PostAnnotation
        if postAnnotation.mapImage != nil {
            annotatedView?.image = postAnnotation.mapImage!
            annotatedView?.layer.borderWidth = 2.0
            annotatedView?.layer.borderColor = UIColor.red.cgColor
        }
        else {
            annotatedView?.image = #imageLiteral(resourceName: "greenMap")
        }
        return annotatedView
    }

    func dropPins() {
        for post in posts {
            let newPin = PostAnnotation()
            let coordinate = CLLocationCoordinate2DMake(post.latitude, post.longitude)
            newPin.coordinate = coordinate
            newPin.title = post.postTitle
            newPin.subtitle = post.cityName
            newPin.mapPost = post
            let ref = Storage.storage().reference(forURL: post.postImageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    self.present(UIAlertController.withError(error: error!), animated: true, completion: nil)
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            if let resizedImage = img.resize(width: 40) {
                                newPin.mapImage = resizedImage
                                self.mapView.addAnnotation(newPin)
                            }
                        }
                    }
                }
            })
        }
    }
}




