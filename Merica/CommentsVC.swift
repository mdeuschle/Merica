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

    }

    @IBAction func postButtonTapped(_ sender: Any) {

        commentRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.post.addComment()
                self.commentRef.setValue(self.commentsTextField.text)                
            }

        })


    }
}
//
//
//
//func upVotesTapped(sender: UITapGestureRecognizer) {
//    upVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//        if let _ = snapshot.value as? NSNull {
//            self.upVoteImage.image = #imageLiteral(resourceName: "greenUpArrow")
//            self.downVoteImage.isUserInteractionEnabled = false
//            self.post.adjustUpVotes(didUpVote: true)
//            self.upVotesRef.setValue(true)
//        } else {
//            self.upVoteImage.image = #imageLiteral(resourceName: "greyUpArrow")
//            self.downVoteImage.isUserInteractionEnabled = true
//            self.post.adjustUpVotes(didUpVote: false)
//            self.upVotesRef.removeValue()
//        }
//    })
//}
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
            return cell
        default:
            return CommentsListCell()
        }
    }
}
