//
//  AppDelegate.swift
//  SwiftyChatExample
//
//  Created by Hussein Jaber on 2/10/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import UIKit
import SwiftyChat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let controller = ChatViewController()
        let root = UINavigationController(rootViewController: controller)
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        return true
    }



}

