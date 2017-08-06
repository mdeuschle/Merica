//
//  AppDelegate.swift
//  Merica
//
//  Created by Matt Deuschle on 7/6/17.
//  Copyright © 2017 Matt Deuschle. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isWelcomeRoot: Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let storyboard = UIStoryboard(name: StoryboardID.main.rawValue, bundle: nil)
        var initialViewController: UIViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = KeychainWrapper.standard.string(forKey: KeyChain.uid.rawValue) {
            print("ID found in keychain")
            isWelcomeRoot = false
            initialViewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.tabBar.rawValue)
        } else {
            isWelcomeRoot = true
            initialViewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.welcome.rawValue)
        }

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        return true
    }

    func scheduleNotification(post: Post, message: String) {
        let userID = Auth.auth().currentUser?.uid
        if post.userKey == userID && post.upVotes < 10 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = post.postTitle
            content.body = message
            content.sound = UNNotificationSound.default()
            if let path = Bundle.main.path(forResource: randomGifGenerator(), ofType: "gif") {
                let url = URL(fileURLWithPath: path)
                do {
                    let attachment = try UNNotificationAttachment(identifier: "gif", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("The attachment was not loaded.")
                }
            }
            let request = UNNotificationRequest(identifier: NotificationID.textNotification.rawValue, content: content, trigger: trigger)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("notification error: \(error)")
                }
            }
        }
    }

    func randomGifGenerator() -> String {
        return "gif" + String(Int(arc4random_uniform(8) + 1))
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

