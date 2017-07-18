//
//  LocationService.swift
//  Merica
//
//  Created by Matt Deuschle on 7/18/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import MapKit

class LocationService {

    static let shared = LocationService()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let status = CLLocationManager.authorizationStatus()

    func getLocation(handler: @escaping (_ address: [String: Any]?, _ error: Error?, _ lat: Double?, _ lon: Double?) -> ()) {
        locationManager.requestWhenInUseAuthorization()
        if status == .authorizedWhenInUse {
            if let currentLocation = locationManager.location {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { placemarks, error in
                    if let err = error {
                        handler(nil, err, nil, nil)
                        print("Location Error: \(err)")
                    } else {
                        let places = placemarks
                        var placeMark: CLPlacemark!
                        placeMark = places?.first
                        guard let address = placeMark.addressDictionary as? [String: Any] else {
                            return
                        }
                        handler(address, nil, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                    }
                })
            } else {
                print("Location Error")
            }
        }
    }
}


