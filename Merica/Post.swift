//
//  Post.swift
//  Merica
//
//  Created by Matt Deuschle on 7/11/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase

class Post {

    private var _postTitle: String!
    private var _postImageURL: String?
    private var _timeStamp: String?
    private var _location: String?
    private var _votes: Int!
    private var _comments: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!

    var postTitle: String {
        return _postTitle ?? ""
    }
    var postImageURL: String {
        return _postImageURL ?? ""
    }
    var timeStamp: String {
        return _timeStamp ?? ""
    }
    var location: String {
        return _location ?? ""
    }
    var votes: Int {
        return _votes
    }
    var comments: Int {
        return _comments
    }
    var postKey: String {
        return _postKey ?? ""
    }

    init(postTitle: String, postImageURL: String, timeStamp: String, location: String, votes: Int, comments: Int) {
        _postTitle = postTitle
        _postImageURL = postImageURL
        _timeStamp = timeStamp
        _location = location
        _votes = votes
        _comments = comments
    }

    init(postKey: String, postDic: [String: Any]) {
        _postKey = postKey
        if let postTitle = postDic[DatabaseID.postTitle.rawValue] as? String {
            _postTitle = postTitle
        }
        if let postImageURL = postDic[DatabaseID.postImageURL.rawValue] as? String {
            _postImageURL = postImageURL
        }
        if let timeStamp = postDic[DatabaseID.timeStamp.rawValue] as? String {
            _timeStamp = timeStamp
        }
        if let location = postDic[DatabaseID.location.rawValue] as? String {
            _location = location
        }
        if let votes = postDic[DatabaseID.votes.rawValue] as? Int {
            _votes = votes
        }
        if let comments = postDic[DatabaseID.comments.rawValue] as? Int {
            _comments = comments
        }
        _postRef = DataService.dataService.refPosts.child(_postKey)
    }

    func adjustUpVotes(didUpVote: Bool) {
        if didUpVote {
            _votes = _votes + 1
        } else {
            _votes = votes - 1
        }
        _postRef.child(DatabaseID.votes.rawValue).setValue(_votes)
    }

    func adjustDownVotes(didDownVote: Bool) {
        if didDownVote {
            _votes = _votes - 1
        } else {
            _votes = votes + 1
        }
        _postRef.child(DatabaseID.votes.rawValue).setValue(_votes)
    }
}














