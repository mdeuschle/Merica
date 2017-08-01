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

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = DataService.shared.refCurrentUser
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        configImagePicker()

        //        currentUser.updateChildValues([DatabaseID.userName.rawValue: "Fred"])

    }

    func configImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            profileImage.image = image
        } else {
            present(UIAlertController.withMessage(message: Alert.imageNotFound.rawValue), animated: true, completion: nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        readUserData()
        tabBarController?.tabBar.isHidden = false
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
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print("EDIT TAPPED")
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
}


//
//    func postToFirebse(imageURL: String, lat: Double, lon: Double, cityName: String, stateName: String) {
//        if postTextField.text == "" {
//            present(UIAlertController.withMessage(message: Alert.addTitle.rawValue), animated: true, completion: nil)
//        } else {
//            if let postText = postTextField.text {
//                let postDic: [String: Any] = [
//                    DatabaseID.postImageURL.rawValue: imageURL as Any,
//                    DatabaseID.postTitle.rawValue: postText as Any,
//                    DatabaseID.timeStamp.rawValue: DateHelper.convertDateToString() as Any,
//                    DatabaseID.upVotes.rawValue: 0 as Any,
//                    DatabaseID.downVotes.rawValue: 0 as Any,
//                    DatabaseID.isFavorite.rawValue: false as Any,
//                    DatabaseID.latitude.rawValue: lat as Any,
//                    DatabaseID.longitude.rawValue: lon as Any,
//                    DatabaseID.cityName.rawValue: cityName as Any,
//                    DatabaseID.stateName.rawValue: stateName as Any,
//                    DatabaseID.userKey.rawValue: KeychainWrapper.standard.string(forKey: KeyChain.uid.rawValue) as Any
//                ]
//                postRef.childByAutoId().setValue(postDic)
//                self.tabBarController?.selectedIndex = 0
//            }
//            postTextField.text = ""
//            imageView.image = #imageLiteral(resourceName: "greyPhoto")
//        }
//    }
//
//    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
//        present(imagePicker, animated: true, completion: nil)
//}
//






