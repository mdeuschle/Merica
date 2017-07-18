//
//  MapVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var posts = [Post]()
    var postAnnotation: MKPointAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()
        postAnnotation = MKPointAnnotation()
    }
}




