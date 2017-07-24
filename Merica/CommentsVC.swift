//
//  CommentsVC.swift
//  Merica
//
//  Created by Matt Deuschle on 7/19/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
class CommentsVC: UIViewController {

    @IBOutlet var commentsTextField: UITextField!

    var post: Post!
    var commentRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        notifications()

    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tabBarController?.tabBar.isHidden = false
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

    func addComment() {
        if let comment = commentsTextField.text {
            commentRef.observeSingleEvent(of: .value, with: { snapshot in
                if comment != "" {
                    self.commentRef.setValue(comment)
                    self.commentsTextField.resignFirstResponder()
                }
            })
        }
    }

    @IBAction func postButtonTapped(_ sender: Any) {
        if commentsTextField.text != "" {
            addComment()
        }
    }
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        commentRef = DataService.shared.refCurrentUser.child(DatabaseID.comment.rawValue).child(post.postKey)

        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.commentsCell.rawValue) as? CommentsCell else {
                return CommentsCell()
            }
            cell.configCell(post: post)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCell.commentsListCell.rawValue) as? CommentsListCell else {
                return CommentsListCell()
            }
            cell.configCell(post: post)
            return cell
        default:
            return CommentsListCell()
        }
    }
}

extension CommentsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            addComment()
        }
        return true
    }
}






