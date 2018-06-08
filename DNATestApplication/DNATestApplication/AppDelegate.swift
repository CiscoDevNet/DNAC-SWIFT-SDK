//
//  AppDelegate.swift
//  DNATestApplication
//
//  Copyright (c) 2018 Cisco.
//
// This software is licensed to you under the terms of the Cisco Sample
// Code License, Version 1.0 (the "License"). You may obtain a copy of the
// License at
//
// https://developer.cisco.com/docs/licenses
//
// All use of the material herein must be in accordance with the terms of
// the License. All rights not expressly granted by the License are
// reserved. Unless required by applicable law or agreed to separately in
// writing, software distributed under the License is distributed on an "AS
// IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
// or implied.
//
// All rights reserved.
//

import UIKit
import DNAAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DNALoginViewControllerDelegate {
 
    //MARK: DNALoginViewControllerDelegate Method
    
    func didStartAuthenticating() {
        print("App: didStartAuthenticating")
    }
    
    func authenticationDidSucceed() {
        print("App: authenticationDidSucceed")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dashboardNavController = storyboard.instantiateViewController(withIdentifier: "DashboardNavController")
        self.window?.rootViewController = dashboardNavController
    }
    
    func authenticationDidFail() {
        print("authenticationDidFail")
    }
    
    //MARK: AppDelegate Method
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Creating window since we have disconneced the storyboard and dont have a initial view controller set.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //Getting DNALoginController instance
        let loginVC:DNALoginViewController = DNAAuthenticationManager.shared.getDNALoginController()
        loginVC.delegate = self //Set DNALoginViewControllerDelegate to receive callbacks.
        
        window?.rootViewController = loginVC //Using DNALoginController instance and using it as root
        window?.makeKeyAndVisible()
        return true
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

