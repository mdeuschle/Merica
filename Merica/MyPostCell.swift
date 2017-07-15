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
        myUpVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(myUpVotesTapped(sender:))))
        myDownVoteImage.addGestureRecognizer(tapGestureGenerator(selector: #selector(myDownVotesTapped(sender:))))
    }

    func myUpVotesTapped(sender: UITapGestureRecognizer) {
        myUpVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.myUpVoteImage.image = #imageLiteral(resourceName: "greenUpArrow")
                self.myDownVoteImage.isUserInteractionEnabled = false
                self.myPost.adjustUpVotes(didUpVote: true)
                self.myUpVotesRef.setValue(true)
            } else {
                self.myUpVoteImage.image = #imageLiteral(resourceName: "greyUpArrow")
                self.myDownVoteImage.isUserInteractionEnabled = true
                self.myPost.adjustUpVotes(didUpVote: false)
                self.myUpVotesRef.removeValue()
            }
        })
    }

    func myDownVotesTapped(sender: UITapGestureRecognizer) {
        myDownVotesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.myDownVoteImage.image = #imageLiteral(resourceName: "greenDownArrow")
                self.myUpVoteImage.isUserInteractionEnabled = false
                self.myPost.adjustDownVotes(didDownVote: true)
                self.myDownVotesRef.setValue(true)
            } else {
                self.myDownVoteImage.image = #imageLiteral(resourceName: "greyDownArrow")
                self.myUpVoteImage.isUserInteractionEnabled = true
                self.myPost.adjustDownVotes(didDownVote: false)
                self.myDownVotesRef.removeValue()
            }
        })
    }

    func tapGestureGenerator(selector: Selector?) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap = UITapGestureRecognizer(target: self, action: selector)
        tap.numberOfTapsRequired = 1
        return tap
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
