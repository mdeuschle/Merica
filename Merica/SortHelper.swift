//
//  SortHelper.swift
//  Merica
//
//  Created by Matt Deuschle on 7/27/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import Foundation

class SortHelper {
    static func sortPosts(posts: [Post]) -> [Post] {
        var olderPosts = posts
        olderPosts.sort(by: { $0.date > $1.date })
        var recentPosts = [Post]()
        let currentDate = Date()
        let dayComponent: Set = [Calendar.Component.day]
        for post in olderPosts {
            let components = Calendar.current.dateComponents(dayComponent, from: post.date, to: currentDate)
            if let daysFromToday = components.day {
                if daysFromToday < 2 {
                    recentPosts.append(post)
                    olderPosts.removeFirst()
                }
                recentPosts.sort(by: { $0.upVotes > $1.upVotes })
            }
        }
        if olderPosts.count > 100 {
            olderPosts.removeLast()
        }
        recentPosts += olderPosts
        return recentPosts
    }
}
