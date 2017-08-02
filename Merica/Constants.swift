//
//  Constants.swift
//  Merica
//
//  Created by Matt Deuschle on 7/7/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation

enum Segue: String {
    case logInSuccess = "logInSuccess"
    case signUpSuccess = "signUpSuccess"
    case toMainFeed = "toMainFeed"
    case toCommentsVC = "toCommentsVC"
    case toTermsAndConditinos = "toTermsAndConditinos"
    case toMyPosts = "toMyPosts"
    case fromMyPostsToDetail = "fromMyPostsToDetail"
    case fromMapToDetail = "fromMapToDetail"
    case toMoreVC = "toMoreVC"
    case toMyUpVotes = "toMyUpVotes"
    case fromMyUpVotesToDetail = "fromMyUpVotesToDetail"
    case toMyFavorites = "toMyFavorites"
    case fromMyFavoritesToDetail = "fromMyFavoritesToDetail"
}

enum DatabaseID: String {
    case posts = "posts"
    case users = "users"
    case pics = "pics"  
    case provider = "provider"
    case userName = "userName"
    case postTitle = "postTitle"
    case postImageURL = "postImageURL"
    case profileImageURL = "profileImageURL"
    case timeStamp = "timeStamp"
    case upVotes = "upVotes"
    case downVotes = "downVotes"
    case isFavorite = "isFavorite"
    case userKey = "userKey"
    case latitude = "latitude"
    case longitude = "longitude"
    case cityName = "cityName"
    case stateName = "stateName"
    case coordinate = "coordinate"
    case estDate = "estDate"
    case defaultProfile = "defaultProfile.png"
}

enum KeyChain: String {
    case uid = "uid"
}

enum Divider: String {
    case pipe = " | "
}

enum ContentType: String {
    case imagePng = "image/png"
}

enum Alert: String {
    case error = "Error"
    case imageNotFound = "Image not found"
    case ok = "OK"
    case welcome = "Welcome "
    case welcomBack = "Welcome back "
    case emptyFields = "Please fill in all fields"
    case signUpThanks = "!\n\nThanks for Signing Up for 'Merica."
    case deletePost = "Delete Post"
    case delete = "Delete"
    case cancel = "Cancel"
    case locationNotFound = "Location not found"
    case unknownError = "Unknown error"
    case addTitle = "A photo this awesome deserves a title"
}

enum StoryboardID: String {
    case main = "Main"
    case welcome = "WelcomeVC"
    case tabBar = "TabBarController"
}

enum ViewControllerID: String {
    case home = "HomeVC"
    case welcomeVC = "WelcomeVC"
}

enum ReusableCell: String {
    case profileCell = "ProfileCell"
    case postCell = "PostCell"
    case myPostsCell = "MyPostsCell"
    case moreCell = "moreCell"
    case detailCell = "detailCell"
    case myUpVotesCell = "myUpVotesCell"
    case myFavoritesCell = "myFavoritesCell"
}

enum ReusableID: String {
    case mapView = "MapView"
}

enum ProfileCellLabel: String {
    case logOut = "Log out"
    case posts = "My Posts"
    case favorites = "My Favorites"
    case upVotes = "My Up Votes"
    case more = "More"
    case est = "Est: "
    case terms = "Terms & Conditions"
}

enum NotificationKey: String {
    case homeTapped = "home.tab.tapped"
}

enum ViewControllerTitle: String {
    case myPosts = "My Posts"
    case myUpVotes = "My Up Votes"
    case myFavorites = "My Favorites"
    case merica = "'Merica"
}

enum LocationType: String {
    case city = "City"
    case state = "State"
}






