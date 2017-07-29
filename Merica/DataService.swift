//
//  DataService.swift
//  Merica
//
//  Created by Matt Deuschle on 7/8/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let dbBase = Database.database().reference()
let storageBase = Storage.storage().reference()

class DataService {
    static let shared = DataService()
    private var _refBase = dbBase
    private var _refPosts = dbBase.child(DatabaseID.posts.rawValue)
    private var _refUsers = dbBase.child(DatabaseID.users.rawValue)
    private var _refPics = storageBase.child(DatabaseID.pics.rawValue)

    var refBase: DatabaseReference {
        return _refBase
    }
    var refPosts: DatabaseReference {
        return _refPosts
    }
    var refUsers: DatabaseReference {
        return _refUsers
    }
    var refPics: StorageReference {
        return _refPics
    }
    var refCurrentUser: DatabaseReference {
        guard let uid = KeychainWrapper.standard.string(forKey: KeyChain.uid.rawValue) else {
            print("Current user is nil")
            return DatabaseReference()
        }
        return _refUsers.child(uid)
    }

    func createFirebaseDBUser(uid: String, userData: [String: String]) {
        refUsers.child(uid).updateChildValues(userData)
    }

    func upVotesRef(postKey: String) -> DatabaseReference {
        return refCurrentUser.child(DatabaseID.upVotes.rawValue).child(postKey)
    }

    func downVotesRef(postKey: String) -> DatabaseReference {
        return refCurrentUser.child(DatabaseID.downVotes.rawValue).child(postKey)
    }
}


