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
    case toTermsVC = "toTermsVC"
    case toMyPosts = "toMyPosts"
    case fromMyPostsToDetail = "fromMyPostsToDetail"
    case fromMapToDetail = "fromMapToDetail"
    case toMoreVC = "toMoreVC"
    case toMyUpVotes = "toMyUpVotes"
    case fromMyUpVotesToDetail = "fromMyUpVotesToDetail"
    case toMyFavorites = "toMyFavorites"
    case fromMyFavoritesToDetail = "fromMyFavoritesToDetail"
    case fromHomeToUserPosts = "fromHomeToUserPosts"
    case fromUserPostsToDetail = "fromUserPostsToDetail"
    case unwindToWelcome = "unwindToWelcome"
    case unwindToHome = "unwindToHome"
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
    case reportedPosts = "reportedPosts"
    case reportedUsers = "reportedUsers"
}

enum KeyChain: String {
    case uid = "uid"
}

enum Divider: String {
    case pipe = " | "
    case dot = " ・ "
}

enum ContentType: String {
    case imagePng = "image/png"
}

enum Alert: String {
    case error = "Error"
    case imageNotFound = "Image not found"
    case ok = "OK"
    case welcome = "Welcome to 'Merica "
    case welcomBack = "Welcome back "
    case emptyFields = "Please fill in all fields"
    case deletePost = "Delete Post"
    case delete = "Delete"
    case cancel = "Cancel"
    case locationNotFound = "Location not found"
    case unknownError = "Unknown error"
    case addTitle = "A photo this awesome deserves a title"
    case reportPost = "Report Post"
    case blockUser = "Block User"
    case noEmail = "Unable to send email"
    case objectional = "Objectional Content Reported"
    case userBlocked = "User Blocked"
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
    case userPostsCell = "userPostsCell"
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
    case est = "Est. "
    case privacyPolicy = "Privacy Policy"
    case kudos = "Kudos "
    case deleteAccount = "Delete Account"
}

enum NotificationKey: String {
    case homeTapped = "home.tab.tapped"
}

enum ViewControllerTitle: String {
    case myPosts = "My Posts"
    case myUpVotes = "My Up Votes"
    case myFavorites = "My Favorites"
    case merica = "'Merica"
    case about = "About"
}

enum LocationType: String {
    case city = "City"
    case state = "State"
}

enum URLString: String {
    case privacyPoliy = "https://sites.google.com/view/merica/privacy-policy"
}

enum Report: String {
    case email = "mdeuschle@gmail.com"
    case subject = "Flag: "
    case objectionalPost = "The follwing post is objectional: "
    case postTitle = "Post Title: "
    case postKey = "Post Key: "
}








