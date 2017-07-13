//
//  PostVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var postTextField: UITextField!

    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        notifications()
    }

    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.showKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.hideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func showKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func hideKeyboard(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        } else {
            present(UIAlertController.withMessage(message: "Image not found"), animated: true, completion: nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
    //            let imageUID = NSUUID().uuidString
    //            let metaData = FIRStorageMetadata()
    //            metaData.contentType = "image/jpeg"
    //            DataService.shared.refPostsImages.child(imageUID).put(imageData, metadata: metaData) {
    //                metaData, error in
    //                if error != nil {
    //                    print("Unable to upload to Firebase")
    //                } else {
    //                    print("Upload to Firebase storage")
    //                    if let downloadURL = metaData?.downloadURL()?.absoluteString {
    //
    //                        DataService.shared.refProfileImages.child("\(DataService.shared.refUserCurrent.key)").downloadURL { (profileURL, err) in
    //                            if let err = err {
    //                                print("OOPS: \(err.localizedDescription)")
    //                            } else {
    //                                print("PROF: \(profileURL!.description)")
    ////                                    self.postToFireBase(imageURL: downloadURL, profileURL: profileURL!.description)
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        if let navigation = self.navigationController {
    //            navigation.popViewController(animated: true)
    //        }
    //        self.tabBarController?.selectedIndex = 0

//    func postToFireBase(imageURL: String, profileURL: String) {
//        if let captionText = selectPicTextView.text {
//            let postDic: [String: AnyObject] = [
//                Constant.PostKeyType.imageURL.rawValue: imageURL as AnyObject,
//                Constant.PostKeyType.caption.rawValue: captionText as AnyObject,
//                Constant.PostKeyType.upVotes.rawValue: 0 as AnyObject,
//                Constant.PostKeyType.downVotes.rawValue: 0 as AnyObject,
//                Constant.PostKeyType.userName.rawValue: currentUserName as AnyObject,
//                Constant.PostKeyType.timeStamp.rawValue: DateHelper.convertDateToString() as AnyObject,
//                Constant.PostKeyType.profileImageURL.rawValue: profileURL as AnyObject,
//                Constant.PostKeyType.favorite.rawValue: false as AnyObject
//            ]
//            DataService.shared.refPosts.childByAutoId().setValue(postDic)
//            selectPicTextView.text = ""
//        }
//    }

    func postToFirebse(imageURL: String) {
        if let postText = postTextField.text {
            let postDic: [String: Any] = [
                DatabaseID.postImageURL.rawValue: imageURL as Any,
                DatabaseID.postTitle.rawValue: postText as Any,
                DatabaseID.timeStamp.rawValue: DateHelper.convertDateToString() as Any,
                DatabaseID.location.rawValue: "" as Any,
                DatabaseID.isUpvoted.rawValue: false as Any,
                DatabaseID.upVotesCount.rawValue: 0 as Any,
                DatabaseID.isDownvoted.rawValue: false as Any,
                DatabaseID.commentsCount.rawValue: 0 as Any,
            ]
            DataService.dataService.refPosts.childByAutoId().setValue(postDic)
            self.tabBarController?.selectedIndex = 0
        }
    }

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)


    }

    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {

        if let image = selectedImage {
            if let reSizedImage = image.resize(width: 300) {
                if let imageData = UIImagePNGRepresentation(reSizedImage) {
                    let imageID = NSUUID().uuidString
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/png"
                    DataService.dataService.refPics.child(imageID).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                        if error != nil {
                            self.present(UIAlertController.withError(error: error!), animated: true, completion: nil)
                        } else {
                            print("Uploaded Image to Firebase Storage!")
                            if let url = metaData?.downloadURL()?.absoluteString {
                                self.postToFirebse(imageURL: url)
                            }
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


}




















