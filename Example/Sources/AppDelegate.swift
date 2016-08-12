//
//  AppDelegate.swift
//  Example
//
//  Created by Jhink Solutions on 7/12/16.
//  Copyright © 2016 Jhink Solutions. All rights reserved.
//

import UIKit

import DeepNavigator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let window = self.window else { return false }
        window.makeKeyAndVisible()
        window.backgroundColor = .whiteColor()
        window.rootViewController = UINavigationController(rootViewController: UserListViewController())

        // Initialize navigation map
        NavigationMap.initialize()

        if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
            Navigator.presentURL(URL)
        }

        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        // Try open URL first
        if Navigator.openURL(url) {
            NSLog("Navigator: Open \(url)")
            return true
        }

        // Try present URL
        if Navigator.presentURL(url, wrap: true) != nil {
            NSLog("Navigator: Present \(url)")
            return true
        }

        return false
    }

}
