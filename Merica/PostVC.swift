//
//  PostVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import CoreLocation
import MapKit

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, SpinnerPresenter {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var postTextField: UITextField!

    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    var currentLocation: CLLocation!
    var locationManager: CLLocationManager!
    var postRef: DatabaseReference!
    var picsRef: StorageReference!
    var currentUser: DatabaseReference!
    var spinner = UIActivityIndicatorView()
    var name = ""
    var profileURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configImagePicker()
        currentLocation = CLLocation()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        postRef = DataService.shared.refPosts
        picsRef = DataService.shared.refPics
        currentUser = DataService.shared.refCurrentUser
        currentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.name = name
            }
        })
        currentUser.child(DatabaseID.profileImageURL.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let profileURL = snapshot.value as? String {
                self.profileURL = profileURL
            }
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedImage = nil
        hideSpinner()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        present(UIAlertController.withError(error: error), animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.first {
            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {
                locationManager.stopUpdatingLocation()
            }
        }
    }

    func configImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .popover
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            imagePicker.mediaTypes = mediaTypes
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = image
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        } else {
            present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func postToFirebse(profileURL: String, imageURL: String, lat: Double, lon: Double, cityName: String, stateName: String) {
        if postTextField.text == "" {
            present(UIAlertController.withMessage(message: Alert.addTitle.rawValue), animated: true, completion: nil)
        } else {
            if let postText = self.postTextField.text {
                let postDic: [String: Any] = [
                    DatabaseID.profileImageURL.rawValue: profileURL as Any,
                    DatabaseID.postImageURL.rawValue: imageURL as Any,
                    DatabaseID.postTitle.rawValue: postText as Any,
                    DatabaseID.userName.rawValue: name as Any,
                    DatabaseID.timeStamp.rawValue: DateHelper.convertDateToString() as Any,
                    DatabaseID.upVotes.rawValue: 0 as Any,
                    DatabaseID.downVotes.rawValue: 0 as Any,
                    DatabaseID.latitude.rawValue: lat as Any,
                    DatabaseID.longitude.rawValue: lon as Any,
                    DatabaseID.cityName.rawValue: cityName as Any,
                    DatabaseID.stateName.rawValue: stateName as Any,
                    DatabaseID.userKey.rawValue: KeychainWrapper.standard.string(forKey: KeyChain.uid.rawValue) as Any
                ]
                self.postRef.childByAutoId().setValue(postDic)
                self.tabBarController?.selectedIndex = 0
                self.imageView.image = #imageLiteral(resourceName: "greyPhoto")
                self.postTextField.text = ""
            }
        }
    }

    func postTapped() {
        showSpinner()
        if let image = selectedImage {
            if let reSizedImage = image.resize(width: 300) {
                if let imageData = UIImagePNGRepresentation(reSizedImage) {
                    let imageID = NSUUID().uuidString
                    let metaData = StorageMetadata()
                    metaData.contentType = ContentType.imagePng.rawValue
                    picsRef.child(imageID).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                        if error != nil {
                            self.present(UIAlertController.withError(error: error!), animated: true, completion: nil)
                        } else {
                            LocationService.shared.getLocation(currentLocation: self.currentLocation, handler: { address, error, latitude, longitude in
                                if let adrs = address,
                                    let city = adrs[LocationType.city.rawValue] as? String,
                                    let state = adrs[LocationType.state.rawValue] as? String,
                                    let lat = latitude,
                                    let lon = longitude,
                                    let url = metaData?.downloadURL()?.absoluteString {
                                    self.postToFirebse(profileURL: self.profileURL, imageURL: url, lat: lat, lon: lon, cityName: city, stateName: state)
                                } else {
                                    if let err = error {
                                        self.present(UIAlertController.withError(error: err), animated: true, completion: nil)
                                    }
                                }
                            })
                        }
                    })
                } else {
                    present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
                }
            } else {
                present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
            }
        } else {
            present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
        }
    }

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.barButtonItem = sender
    }

    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        postTapped()
    }
}

extension PostVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            postTapped()
        }
        return true
    }
}

















