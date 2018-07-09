//
//  AppDelegate.swift
//  TestNetworkSwift
//
//  Created by Matvey Kravtsov on 05/07/2018.
//  Copyright © 2018 Matvey Kravtsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window?.rootViewController = MainViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
}

