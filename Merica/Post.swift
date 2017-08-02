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
    private var _userName: String!
    private var _postImageURL: String?
    private var _timeStamp: String?
    private var _upVotes: Int!
    private var _downVotes: Int!
    private var _isFavorite: Bool!
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
    var userName: String {
        return _userName ?? ""
    }
    var postImageURL: String {
        return _postImageURL ?? ""
    }
    var timeStamp: String {
        return _timeStamp ?? ""
    }
    var upVotes: Int {
        return _upVotes
    }
    var downVotes: Int {
        return _downVotes
    }
    var isFavorite: Bool {
        return _isFavorite
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
    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateFromString = formatter.date(from: _timeStamp!) {
            return dateFromString
        } else {
            return Date()
        }
    }

    init(postTitle: String, userName: String, postImageURL: String, timeStamp: String, upVotes: Int, downVotes: Int, isFavorite: Bool, latitude: Double, longitude: Double, cityName: String, stateName: String, comment: String, postUser: String, userKey: String) {
        _postTitle = postTitle
        _userName = userName
        _postImageURL = postImageURL
        _timeStamp = timeStamp
        _upVotes = upVotes
        _downVotes = downVotes
        _isFavorite = isFavorite
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
        if let userName = postDic[DatabaseID.userName.rawValue] as? String {
            _userName = userName
        }
        if let postImageURL = postDic[DatabaseID.postImageURL.rawValue] as? String {
            _postImageURL = postImageURL
        }
        if let timeStamp = postDic[DatabaseID.timeStamp.rawValue] as? String {
            _timeStamp = timeStamp
        }
        if let upVotes = postDic[DatabaseID.upVotes.rawValue] as? Int {
            _upVotes = upVotes
        }
        if let downVotes = postDic[DatabaseID.downVotes.rawValue] as? Int {
            _downVotes = downVotes
        }
        if let isFavorite = postDic[DatabaseID.isFavorite.rawValue] as? Bool {
            _isFavorite = isFavorite
        }
        if let latitude = postDic[DatabaseID.latitude.rawValue] as? Double {
            _latitude = latitude
        }
        if let longitude = postDic[DatabaseID.longitude.rawValue] as? Double {
            _longitude = longitude
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

    func adjustFavorites(didFavorite: Bool) {
        if didFavorite {
            _isFavorite = true
        } else {
            _isFavorite = false
        }
        _postRef.child(DatabaseID.isFavorite.rawValue).setValue(_isFavorite)
    }
}














