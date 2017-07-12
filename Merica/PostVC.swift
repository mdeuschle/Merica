//
//  PostVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/9/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit

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

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)

    }

    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
    }
    

}




















