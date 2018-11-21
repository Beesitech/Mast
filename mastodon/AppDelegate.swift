//
//  AppDelegate.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import OneSignal
import Disk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectViewMain = UIView()
    
    var blurEffect0 = UIBlurEffect()
    var blurEffectView0 = UIVisualEffectView()
    
    var oneTime = false
    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if 1 == 1 {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "createNoti"), object: self)
//            completionHandler(.newData)
//        } else {
//            completionHandler(.failed)
//        }
//    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == "com.shi.Mast.confetti" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriConfetti()
        } else if userActivity.activityType == "com.shi.Mast.light" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriLight()
        } else if userActivity.activityType == "com.shi.Mast.dark" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriDark()
        } else if userActivity.activityType == "com.shi.Mast.dark2" {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriDark2()
        } else {
            let viewController = window?.rootViewController as! ViewController
            viewController.siriOled()
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("RECRECREC")
        
        let request = Notifications.all(range: .default)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.notifications = stat
                
                for x in StoreStruct.notifications {
                    if x.type == .mention {
                        StoreStruct.notificationsMentions.append(x)
                        DispatchQueue.main.async {
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                            StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadNewest"), object: nil)
                        }
                    }
                }
                
            }
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.shi.Mast.feed" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch11"), object: self)
            completionHandler(true)
        } else if shortcutItem.type == "com.shi.Mast.notifications" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch22"), object: self)
            completionHandler(true)
        } else if shortcutItem.type == "com.shi.Mast.profile" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch33"), object: self)
            completionHandler(true)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switch44"), object: self)
            completionHandler(false)
        }
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Response ==> \(url.absoluteString)")
        let x = url.absoluteString
        let y = x.split(separator: "=")
        StoreStruct.authCode = y[1].description
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
        return true
    }

    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
        case .pad:
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.backgroundColor = Colours.white
            
            let splitViewController =  UISplitViewController()
            let rootViewController = PadViewController()
            
            let splitViewController2 =  UISplitViewController()
            let rootViewController2 = PadTimelinesViewController()
            let rootNavigationController2 = UINavigationController(rootViewController: rootViewController2)
            
            let splitViewController3 =  UISplitViewController()
            let rootViewController3 = PadLocalTimelinesViewController()
            let detailViewController3 = PadFedViewController()
            let rootNavigationController3 = UINavigationController(rootViewController: rootViewController3)
            let detailNavigationController3 = UINavigationController(rootViewController: detailViewController3)
            
            splitViewController3.viewControllers = [rootNavigationController3, detailNavigationController3]
            splitViewController3.preferredPrimaryColumnWidthFraction = 0.5
            if UIDevice.current.orientation.isPortrait {
                splitViewController3.preferredDisplayMode = .allVisible
            } else {
                splitViewController3.preferredDisplayMode = .primaryHidden
            }
            
            splitViewController2.viewControllers = [rootNavigationController2, splitViewController3]
            splitViewController2.preferredPrimaryColumnWidthFraction = 0.5
            splitViewController2.preferredDisplayMode = .allVisible
            
            splitViewController.viewControllers = [rootViewController, splitViewController2]
            splitViewController.minimumPrimaryColumnWidth = 80
            splitViewController.maximumPrimaryColumnWidth = 80
            splitViewController.preferredDisplayMode = .allVisible
            
            splitViewController.view.backgroundColor = Colours.white
            splitViewController2.view.backgroundColor = Colours.white
            splitViewController3.view.backgroundColor = Colours.white
            rootNavigationController2.view.backgroundColor = Colours.white
            rootNavigationController3.view.backgroundColor = Colours.white
            detailNavigationController3.view.backgroundColor = Colours.white
            self.window!.rootViewController = splitViewController
            self.window!.makeKeyAndVisible()
            
            
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().backgroundColor = Colours.white
            UINavigationBar.appearance().barTintColor = Colours.black
            UINavigationBar.appearance().tintColor = Colours.black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        default:
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
        }
        
        
        
        SwiftyGiphyAPI.shared.apiKey = SwiftyGiphyAPI.publicBetaKey
        
        
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "4f67f45a-7d0f-4e7d-8624-0ec148f064ed",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        
        WatchSessionManager.sharedManager.startSession()
        
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colours.grayLight2], for: .normal)
//        BarButtonItemAppearance.setBackgroundVerticalPositionAdjustment(-100, for: .default)
//        BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 36, vertical: -2), for:UIBarMetrics.default)
        BarButtonItemAppearance.tintColor = Colours.grayLight2
        
        
        window?.tintColor = Colours.tabSelected
        
        
        
        do {
            StoreStruct.statusesHome = try Disk.retrieve("home.json", from: .documents, as: [Status].self)
            StoreStruct.statusesLocal = try Disk.retrieve("local.json", from: .documents, as: [Status].self)
            StoreStruct.statusesFederated = try Disk.retrieve("fed.json", from: .documents, as: [Status].self)
            StoreStruct.notifications = try Disk.retrieve("noti.json", from: .documents, as: [Notificationt].self)
            StoreStruct.notificationsMentions = try Disk.retrieve("ment.json", from: .documents, as: [Notificationt].self)
            StoreStruct.currentUser = try Disk.retrieve("use.json", from: .documents, as: Account.self)
        } catch {
            print("Couldn't load")
        }
        
        return true
    }
    
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        UserDefaults.standard.set(StoreStruct.currentUser.username, forKey: "userN")
        do {
            try Disk.save(StoreStruct.currentUser, to: .documents, as: "use.json")
            
            try Disk.save(StoreStruct.statusesHome, to: .documents, as: "home.json")
            try Disk.save(StoreStruct.statusesLocal, to: .documents, as: "local.json")
            try Disk.save(StoreStruct.statusesFederated, to: .documents, as: "fed.json")
            
            try Disk.save(StoreStruct.notifications, to: .documents, as: "noti.json")
            try Disk.save(StoreStruct.notificationsMentions, to: .documents, as: "ment.json")
        } catch {
            print("Couldn't save")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "startStream"), object: self)
        
        
        if self.oneTime == false {
            if (UserDefaults.standard.object(forKey: "biometrics") == nil) || (UserDefaults.standard.object(forKey: "biometrics") as! Int == 0) {} else {
                self.biometricAuthenticationClicked(self)
                self.oneTime = true
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    func biometricAuthenticationClicked(_ sender: Any) {
        
        let win = window
        blurEffectViewMain.frame = UIScreen.main.bounds
        blurEffectViewMain.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        win!.addSubview(blurEffectViewMain)
        
        blurEffect0 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView0 = UIVisualEffectView(effect: blurEffect0)
        blurEffectView0.frame = UIScreen.main.bounds
        blurEffectView0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        win!.addSubview(blurEffectView0)
        
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            
            self.blurEffectViewMain.removeFromSuperview()
            self.blurEffectView0.removeFromSuperview()
            
        }, failure: { [weak self] (error) in
            self?.showPasscodeAuthentication(message: "Error")
        })
    }
    func showPasscodeAuthentication(message: String) {
        BioMetricAuthenticator.authenticateWithPasscode(reason: message, success: {
            
            self.blurEffectViewMain.removeFromSuperview()
            self.blurEffectView0.removeFromSuperview()
            
        }) { (error) in
            print(error.message())
            self.biometricAuthenticationClicked(self)
        }
    }
}

