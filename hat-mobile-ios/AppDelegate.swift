/**
 * Copyright (C) 2017 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import Crashlytics
import Fabric
import UIKit

// MARK: Class

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    
    var window: UIWindow?
    let locationManager: UpdateLocations = UpdateLocations.shared
    
    // MARK: - App Delegate methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        // if app was closed by iOS (low mem, etc), then receives a location update, and respawns your app, letting it know it respawned due to a location service
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            
            locationManager.resumeLocationServices()
        }
        
        // change tab bar item font
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!], for: UIControlState.normal)
        
        // change bar button item font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 17)!], for: UIControlState.normal)
        
        // define the interval for background fetch interval
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        // register for user notifications
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        self.window?.tintColor = .appBase
        
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().barTintColor = .teal
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans", size: 20)!]
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!], for: UIControlState.normal)
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let taskID = beginBackgroundUpdateTask()
        let syncHelper = SyncDataHelper()
        if syncHelper.checkNextBlockToSync() == true {
            
            completionHandler(.newData)
        } else {
            
            completionHandler(.noData)
        }
        self.endBackgroundUpdateTask(taskID: taskID)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // purge old data
        self.purgeUsingPredicate()
        self.endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier.init())
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        _ = self.beginBackgroundUpdateTask()
    }
    
    // MARK: - oAuth handler function
    
    /*
     Callback handler oAuth
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let urlHost: String = url.host {
            
            if urlHost == Constants.Auth.localAuthHost {
                
                let result = KeychainHelper.getKeychainValue(key: "logedIn")
                if result == "expired" {
                    
                    NotificationCenter.default.post(name: Notification.Name("reauthorisedUser"), object: url)
                } else if result == "false" {
                    
                    let notification = Notification.Name(Constants.Auth.notificationHandlerName)
                    NotificationCenter.default.post(name: notification, object: url)
                    _ = KeychainHelper.setKeychainValue(key: "logedIn", value: "true")
                }
            } else if urlHost == "dataplugsapphost" {
                
                let notification = Notification.Name("dataPlugMessage")
                NotificationCenter.default.post(name: notification, object: url)
            }
        }
        return true
    }
    
    // MARK: - Purge data
    
    /**
     Check if we need to purge old data. 7 Days
     */
    private func purgeUsingPredicate() {
        
        let lastWeek = Date().addingTimeInterval(FutureTimeInterval.init(days: Constants.PurgeData.olderThan, timeType: TimeType.past).interval)
        let predicate = NSPredicate(format: "dateAdded <= %@", lastWeek as CVarArg)
        
        // use _ to get rid of result is unused warnings
        _ = RealmHelper.purge(predicate)
    }
    
    // MARK: - Background Task Functions
    
    // background task
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }
    
    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        
        UIApplication.shared.endBackgroundTask(taskID)
    }
}
