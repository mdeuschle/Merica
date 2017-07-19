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
    let status = CLLocationManager.authorizationStatus()

    func getLocation(currentLocation: CLLocation?, handler: @escaping (_ address: [String: Any]?, _ error: Error?, _ lat: Double?, _ lon: Double?) -> ()) {
        if status == .authorizedWhenInUse {
            if let currentLoc = currentLocation {
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(currentLoc, completionHandler: { placemarks, error in
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
                        handler(address, nil, currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
                    }
                })
            } else {
                print("Location Error")
            }
        }
    }
}


