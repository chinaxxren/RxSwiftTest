//
//  AppDelegate.swift
//  RxSwiftDemo
//
//  Created by 赵江明 on 2022/1/11.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let navController = UINavigationController.init(rootViewController: ViewController.init())
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
}

