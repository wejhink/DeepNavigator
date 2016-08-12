//
//  NavigationMap.swift
//  DeepNavigator
//
//  Created by Jhink Solutions on 7/12/16.
//  Copyright © 2016 Jhink Solutions. All rights reserved.
//

import UIKit

import DeepNavigator

struct NavigationMap {

    static func initialize() {
        Navigator.map("navigator://user/<username>", UserViewController.self)
        Navigator.map("http://<path:_>", WebViewController.self)
        Navigator.map("https://<path:_>", WebViewController.self)
        Navigator.map("navigator://alert", self.alert)
    }

    private static func alert(URL: DeepConvertible, values: [String: AnyObject]) -> Bool {
        let title = URL.queryParameters["title"]
        let message = URL.queryParameters["message"]
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        Navigator.present(alertController)
        return true
    }

}
