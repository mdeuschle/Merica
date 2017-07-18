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
    private var _upVotes: Int!
    private var _downVotes: Int!
    private var _comments: Int!
    private var _latitude: Double?
    private var _longitude: Double?
    private var _cityName: String?
    private var _stateName: String?
    private var _postKey: String!
    private var _userKey: String!
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
    var upVotes: Int {
        return _upVotes
    }
    var downVotes: Int {
        return _downVotes
    }
    var comments: Int {
        return _comments
    }
    var latitude: Double {
        return _latitude ?? 0.0
    }
    var longitude: Double {
        return _longitude ?? 0.0
    }
    var cityName: String {
        return _cityName ?? ""
    }
    var stateName: String {
        return _stateName ?? ""
    }
    var postKey: String {
        return _postKey ?? ""
    }
    var userKey: String {
        return _userKey
    }

    init(postTitle: String, postImageURL: String, timeStamp: String, location: String, upVotes: Int, downVotes: Int, comments: Int, latitude: Double, longitude: Double, cityName: String, stateName: String, userKey: String) {
        _postTitle = postTitle
        _postImageURL = postImageURL
        _timeStamp = timeStamp
        _location = location
        _upVotes = upVotes
        _downVotes = downVotes
        _comments = comments
        _latitude = latitude
        _longitude = longitude
        _cityName = cityName
        _stateName = stateName
        _userKey = userKey
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
        if let upVotes = postDic[DatabaseID.upVotes.rawValue] as? Int {
            _upVotes = upVotes
        }
        if let downVotes = postDic[DatabaseID.downVotes.rawValue] as? Int {
            _downVotes = downVotes
        }
        if let latitude = postDic[DatabaseID.latitude.rawValue] as? Double {
            _latitude = latitude
        }
        if let longitude = postDic[DatabaseID.longitude.rawValue] as? Double {
            _longitude = longitude
        }
        if let comments = postDic[DatabaseID.comments.rawValue] as? Int {
            _comments = comments
        }
        if let cityName = postDic[DatabaseID.cityName.rawValue] as? String {
            _cityName = cityName
        }
        if let stateName = postDic[DatabaseID.stateName.rawValue] as? String {
            _stateName = stateName
        }
        if let userKey = postDic[DatabaseID.userKey.rawValue] as? String {
            _userKey = userKey
        }
        _postRef = DataService.shared.refPosts.child(_postKey)
    }

    func adjustUpVotes(didUpVote: Bool) {
        if didUpVote {
            _upVotes = _upVotes + 1
        } else {
            _upVotes = upVotes - 1
        }
        _postRef.child(DatabaseID.upVotes.rawValue).setValue(_upVotes)
    }

    func adjustDownVotes(didDownVote: Bool) {
        if didDownVote {
            _downVotes = _downVotes + 1
        } else {
            _downVotes = downVotes - 1
        }
        _postRef.child(DatabaseID.downVotes.rawValue).setValue(_downVotes)
    }
}














