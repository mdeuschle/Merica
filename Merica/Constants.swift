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
}

enum DatabaseID: String {
    case posts = "posts"
    case users = "users"
    case pics = "pics"
    case provider = "provider"
    case userName = "userName"
    case postTitle = "postTitle"
    case postImageURL = "postImageURL"
    case timeStamp = "timeStamp"
    case location = "location"
    case upVotes = "upVotes"
    case downVotes = "downVotes"
    case comments = "comments"
    case userKey = "userKey"
}

enum KeyChain: String {
    case uid = "uid"
}

enum Alert: String {
    case error = "Error"
    case imageNotFound = "Image not found"
    case ok = "OK"
    case welcome = "Welcome "
    case welcomBack = "Welcome back "
    case emptyFields = "Please fill in all fields"
    case signUpThanks = "!\n\nThanks for Signing Up for 'Merica."
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
    case myPostCell = "myPostCell"
}

enum ProfileCellLabel: String {
    case logOut = "Log out"
    case posts = "Posts"
    case comments = "Comments"
    case upVotes = "Up Votes"
    case more = "More"
}

enum NotificationKey: String {
    case homeTapped = "home.tab.tapped"
}

enum ViewControllerTitle: String {
    case myPosts = "My Posts"
    case hi = "Hi, "
    case merica = "'Merica"
}


