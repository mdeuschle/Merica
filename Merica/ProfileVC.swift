//
//  ProfileVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var memeberSinceLabel: UILabel!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var profileImage: UIImageView!

    var currentUser: DatabaseReference!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    var picsRef: StorageReference!
    var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = DataService.shared.refCurrentUser
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        configImagePicker()
        picsRef = DataService.shared.refPics
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileVC.editTapped))
        navigationItem.rightBarButtonItem = editButton
        profileImage.image = #imageLiteral(resourceName: "greyProfile")
    }

    func configImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }

    override func viewWillAppear(_ animated: Bool) {
        readUserData()
        readProfilePic()
        tabBarController?.tabBar.isHidden = false
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        } else {
            present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
        }
        imagePicker.dismiss(animated: true, completion: uploadNewProfileImage)
    }

    func readUserData() {
        currentUser.child(DatabaseID.userName.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                self.title = name
            }
        })
        currentUser.child(DatabaseID.estDate.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let timeStamp = snapshot.value as? String {
                self.memeberSinceLabel.text =  ProfileCellLabel.est.rawValue + timeStamp
            }
        })
    }

    func readProfilePic() {
        currentUser.child(DatabaseID.profileImageURL.rawValue).observeSingleEvent(of: .value, with: { (snapshot) in
            if let url = snapshot.value as? String {
                let ref = Storage.storage().reference(forURL: url)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        self.present(UIAlertController.withMessage(message: Alert.unknownError.rawValue), animated: true, completion: nil)
                    } else {
                        if let imageData = data {
                            if let img = UIImage(data: imageData) {
                                self.profileImage.image = img
                            }
                        }
                    }
                })
            }
        })
    }

    func editTapped() {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.profileCell.rawValue) as? ProfileCell else {
            return UITableViewCell()
        }
        cell.configCell(row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: Segue.toMyPosts.rawValue, sender: self)
        case 1:
            performSegue(withIdentifier: Segue.toMyUpVotes.rawValue, sender: self)
        case 2:
            performSegue(withIdentifier: Segue.toMyFavorites.rawValue, sender: self)
        case 3:
            performSegue(withIdentifier: Segue.toMoreVC.rawValue, sender: self)
        default:
            print("Default")
        }
    }

    func uploadNewProfileImage() {
        if let image = selectedImage {
            if let reSizedImage = image.resize(width: 100) {
                if let imageData = UIImagePNGRepresentation(reSizedImage) {
                    let imageID = NSUUID().uuidString
                    let metadata = StorageMetadata()
                    metadata.contentType = ContentType.imagePng.rawValue
                    picsRef.child(imageID).putData(imageData, metadata: metadata, completion: { (metaData, error) in
                        if let error = error {
                            self.present(UIAlertController.withError(error: error), animated: true, completion: nil)
                        } else {
                            if let url = metaData?.downloadURL()?.absoluteString {
                                self.currentUser.updateChildValues([DatabaseID.profileImageURL.rawValue: url])
                                self.readProfilePic()
                            }
                        }
                    })
                }
            }
        }
    }
}






