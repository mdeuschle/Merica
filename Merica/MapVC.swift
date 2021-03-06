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
    var reportedUsers = [String]()
    var postRef: DatabaseReference!
    var storageRef: StorageReference!
    var currentUser: DatabaseReference!
    var handle: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        postRef = DataService.shared.refPosts
        currentUser = DataService.shared.refCurrentUser
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        getPosts()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postRef.removeObserver(withHandle: handle)
    }

    func getPosts() {
        handle = postRef.observe(.value, with: { snapShot in
            self.posts = []
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot] {
                for snap in snapShot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postDic: postDic)

                        self.getReportedUser {
                            if !self.reportedUsers.contains(post.userKey) {
                                self.posts.append(post)
                                self.dropPins()
                            }
                        }
                    }
                }
            }
        })
    }

    func getReportedUser(handler: @escaping () -> ()) {
        currentUser.child(DatabaseID.reportedUsers.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snaps {
                    self.reportedUsers.append(snap.key)
                }
                handler()
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
            annotatedView?.layer.borderWidth = 3.0
            annotatedView?.layer.borderColor = UIColor.lightRed().cgColor
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
            newPin.subtitle = post.cityName + Divider.pipe.rawValue + post.stateName
            newPin.mapPost = post
            storageRef = Storage.storage().reference(forURL: post.postImageURL)
            storageRef.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    self.present(UIAlertController.withError(error: error!), animated: true, completion: nil)
                } else {
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

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: Segue.fromMapToDetail.rawValue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC, let selectedPost = mapView.selectedAnnotations.first as? PostAnnotation {
            destination.post = selectedPost.mapPost
        }
    }
}




