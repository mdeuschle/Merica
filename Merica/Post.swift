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
    private var _isUpvoted: Bool?
    private var _upVotesCount: Int?
    private var _isDownvoted: Bool?
    private var _commentsCount: Int?
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
    var isUpvoted: Bool {
        return _isUpvoted ?? false
    }
    var upVotesCount: Int {
        return _upVotesCount ?? 0
    }
    var isDownvoted: Bool {
        return _isDownvoted ?? false
    }
    var commentsCount: Int {
        return _commentsCount ?? 0
    }
    var postKey: String {
        return _postKey ?? ""
    }

    init(postTitle: String, postImageURL: String, timeStamp: String, location: String, isUpvoted: Bool, upVotesCount: Int, isDownvoted: Bool, commentsCount: Int) {
        _postTitle = postTitle
        _postImageURL = postImageURL
        _timeStamp = timeStamp
        _location = location
        _isUpvoted = isUpvoted
        _upVotesCount = upVotesCount
        _isDownvoted = isDownvoted
        _commentsCount = commentsCount
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
        if let isUpvoted = postDic[DatabaseID.isUpvoted.rawValue] as? Bool {
            _isUpvoted = isUpvoted
        }
        if let upVotesCount = postDic[DatabaseID.upVotesCount.rawValue] as? Int {
            _upVotesCount = upVotesCount
        }
        if let isDownvoted = postDic[DatabaseID.isDownvoted.rawValue] as? Bool {
            _isDownvoted = isDownvoted
        }
        if let commentsCount = postDic[DatabaseID.commentsCount.rawValue] as? Int {
            _commentsCount = commentsCount
        }
        _postRef = DataService.dataService.refPosts.child(_postKey)
    }
}















