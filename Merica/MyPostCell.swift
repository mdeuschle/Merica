//
//  MyPostCell.swift
//  Merica
//
//  Created by Matt Deuschle on 7/14/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase

class MyPostCell: UITableViewCell {

    @IBOutlet var myPostTitleLabel: UILabel!
    @IBOutlet var myPostImageView: UIImageView!
    @IBOutlet var myTimeStampLabel: UILabel!
    @IBOutlet var myLocationLabel: UILabel!
    @IBOutlet var myUpVoteImage: UIImageView!
    @IBOutlet var myVoteCountLabel: UILabel!
    @IBOutlet var myDownVoteImage: UIImageView!
    @IBOutlet var myCommentsImage: UIImageView!
    @IBOutlet var myCommentsCountLabel: UILabel!
    @IBOutlet var myShareImage: UIView!
    @IBOutlet var myShareLabel: UILabel!

    var myPost: Post!
    var myUpVotesRef: DatabaseReference!
    var myDownVotesRef: DatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func myConfigCell(myPost: Post, myImage: UIImage? = nil) {
        self.myPost = myPost
        myUpVotesRef = DataService.dataService.refCurrentUser.child(DatabaseID.upVotes.rawValue).child(myPost.postKey)
        myDownVotesRef = DataService.dataService.refCurrentUser.child(DatabaseID.downVotes.rawValue).child(myPost.postKey)

        myPostTitleLabel.text = myPost.postTitle
        myTimeStampLabel.text = DateHelper.calcuateTimeStamp(dateString: myPost.timeStamp)
        myLocationLabel.text = myPost.location
        let totalVotes = myPost.upVotes - myPost.downVotes
        myVoteCountLabel.text = "\(totalVotes)"

        if myImage != nil {
            self.myPostImageView.image = myImage
        } else {
            let ref = Storage.storage().reference(forURL: myPost.postImageURL)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.myPostImageView.image = img
                            HomeVC.imageCache.setObject(img, forKey: myPost.postImageURL as NSString)
                        }
                    }
                }
            })
        }
        myUpVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.myUpVoteImage.image = #imageLiteral(resourceName: "greyUpArrow")
            } else {
                self.myUpVoteImage.image = #imageLiteral(resourceName: "greenUpArrow")
            }
        })
        myDownVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.myDownVoteImage.image = #imageLiteral(resourceName: "greyDownArrow")
            } else {
                self.myDownVoteImage.image = #imageLiteral(resourceName: "greenDownArrow")
            }
        })
    }

}
