//
//  ViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import SafariServices
import StatusAlert
import SJFluidSegmentedControl
import OneSignal
import SAConfettiView
import WatchConnectivity
import Disk

class ViewController: UITabBarController, UITabBarControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SJFluidSegmentedControlDataSource, SJFluidSegmentedControlDelegate, OSSubscriptionObserver, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("active: \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("deactivate")
    }
    
    var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    
    var screenshotLabel = UILabel()
    var screenshot = UIImage()
    var identity = CGAffineTransform.identity
    let view0pinch = UIView()
    let view1pinch = UIImageView()
    var doOnce = true
    var doOncePinch = true
    var doOnceScreen = true
    
    var segmentedControl: SJFluidSegmentedControl!
    var typeOfSearch = 0
    var newestText = ""
    
    var tabOne = UINavigationController()
    var tabTwo = UINavigationController()
    var tabThree = UINavigationController()
    var tabFour = UINavigationController()
    
    var firstView = FirstViewController()
    var secondView = SecondViewController()
    var thirdView = ThirdViewController()
    var fourthView = FourthViewController()
    
    var statusBarView = UIView()
    var bgView = UIView()
    var settingsButton = MNGExpandedTouchAreaButton()
    var searchButton = MNGExpandedTouchAreaButton()
    
    var loginBG = UIView()
    var loginLogo = UIImageView()
    var loginLabel = UILabel()
    var textField = PaddedTextField()
    var safariVC: SFSafariViewController?
    
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    var tableView = UITableView()
    var tableViewLists = UITableView()
    let volumeBar = VolumeBar.shared
    
    func siriLight() {
        UIApplication.shared.statusBarStyle = .default
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(0, forKey: "theme")
        self.genericStuff()
    }
    
    func siriDark() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(1, forKey: "theme")
        self.genericStuff()
    }
    
    func siriDark2() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(2, forKey: "theme")
        self.genericStuff()
    }
    
    func siriOled() {
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        UserDefaults.standard.set(3, forKey: "theme")
        self.genericStuff()
    }
    
    func siriConfetti() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
    }
    
    func genericStuff() {
        
        self.firstView.loadLoadLoad()
        self.secondView.loadLoadLoad()
        self.thirdView.loadLoadLoad()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
        
        self.view.backgroundColor = Colours.white
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.white
        
        self.tabBar.barTintColor = Colours.white
        self.tabBar.backgroundColor = Colours.white
        self.tabBar.unselectedItemTintColor = Colours.tabUnselected
        self.tabBar.tintColor = Colours.tabSelected
        
        self.firstView.view.backgroundColor = Colours.white
        self.secondView.view.backgroundColor = Colours.white
        self.thirdView.view.backgroundColor = Colours.white
        self.fourthView.view.backgroundColor = Colours.white
        
        self.tabOne.navigationBar.backgroundColor = Colours.white
        self.tabOne.navigationBar.barTintColor = Colours.white
        self.tabTwo.navigationBar.backgroundColor = Colours.white
        self.tabTwo.navigationBar.barTintColor = Colours.white
        self.tabThree.navigationBar.backgroundColor = Colours.white
        self.tabThree.navigationBar.barTintColor = Colours.white
        self.tabFour.navigationBar.backgroundColor = Colours.white
        self.tabFour.navigationBar.barTintColor = Colours.white
        
        statusBarView.backgroundColor = Colours.white
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func setupSiri() {
            let activity1 = NSUserActivity(activityType: "com.shi.Mast.light")
            activity1.title = "Switch to light mode".localized
            activity1.userInfo = ["state" : "light"]
            activity1.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity1.isEligibleForPrediction = true
                activity1.persistentIdentifier = "com.shi.Mast.light"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity1
            activity1.becomeCurrent()
        
        delay(1.5) {
            let activity2 = NSUserActivity(activityType: "com.shi.Mast.dark")
            activity2.title = "Switch to dark mode".localized
            activity2.userInfo = ["state" : "dark"]
            activity2.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity2.isEligibleForPrediction = true
                activity2.persistentIdentifier = "com.shi.Mast.dark"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity2
            activity2.becomeCurrent()
        }
        
        delay(1.5) {
            let activity21 = NSUserActivity(activityType: "com.shi.Mast.dark2")
            activity21.title = "Switch to extra dark mode".localized
            activity21.userInfo = ["state" : "dark2"]
            activity21.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity21.isEligibleForPrediction = true
                activity21.persistentIdentifier = "com.shi.Mast.dark2"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity21
            activity21.becomeCurrent()
        }
        
        delay(3) {
            let activity3 = NSUserActivity(activityType: "com.shi.Mast.oled")
            activity3.title = "Switch to true black dark mode".localized
            activity3.userInfo = ["state" : "oled"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.shi.Mast.oled"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
        
        delay(4.5) {
            let activity3 = NSUserActivity(activityType: "com.shi.Mast.confetti")
            activity3.title = "Confetti time".localized
            activity3.userInfo = ["state" : "confetti"]
            activity3.isEligibleForSearch = true
            if #available(iOS 12.0, *) {
                activity3.isEligibleForPrediction = true
                activity3.persistentIdentifier = "com.shi.Mast.confetti"
            } else {
                // Fallback on earlier versions
            }
            self.view.userActivity = activity3
            activity3.becomeCurrent()
        }
    }
    
    @objc func logged() {
        
        self.loginBG.removeFromSuperview()
        self.loginLogo.removeFromSuperview()
        self.loginLabel.removeFromSuperview()
        self.textField.removeFromSuperview()
        self.safariVC!.dismiss(animated: true, completion: nil)
        
        var request = URLRequest(url: URL(string: "https://\(StoreStruct.returnedText)/oauth/token?grant_type=authorization_code&code=\(StoreStruct.authCode)&redirect_uri=\(StoreStruct.redirect!)&client_id=\(StoreStruct.clientID)&client_secret=\(StoreStruct.clientSecret)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    
                    DispatchQueue.main.async {
                        var customStyle = VolumeBarStyle.likeInstagram
                        customStyle.trackTintColor = Colours.cellQuote
                        customStyle.progressTintColor = Colours.grayDark
                        customStyle.backgroundColor = Colours.white
                        self.volumeBar.style = customStyle
                        //self.volumeBar.start()
                        //self.volumeBar.showInitial()
                    }
                    
                    
                    StoreStruct.accessToken = (json["access_token"] as! String)
                    StoreStruct.client.accessToken = StoreStruct.accessToken
                    
                    UserDefaults.standard.set(StoreStruct.clientID, forKey: "clientID")
                    UserDefaults.standard.set(StoreStruct.clientSecret, forKey: "clientSecret")
                    UserDefaults.standard.set(StoreStruct.authCode, forKey: "authCode")
                    UserDefaults.standard.set(StoreStruct.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(StoreStruct.returnedText, forKey: "returnedText")
                    
                    let request = Timelines.home()
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.statusesHome = stat
                            StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                        }
                    }
                    
                    
                    let request2 = Accounts.currentUser()
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            StoreStruct.currentUser = stat
                            
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "refProf"), object: nil)
                            }
                        }
                    }
                    
                    
                    
                    
                    // onboarding
                    if (UserDefaults.standard.object(forKey: "onb") == nil) || (UserDefaults.standard.object(forKey: "onb") as! Int == 0) {
                    DispatchQueue.main.async {
                        self.bulletinManager.prepare()
                        self.bulletinManager.presentBulletin(above: self, animated: true, completion: nil)
                    }
                    }
                    
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
    }
    
    
    
    
    
    
    
    lazy var bulletinManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Welcome to Mast")
        page.image = UIImage(named: "iconb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You're almost ready to go.\nLet's configure some things first."
        page.actionButtonTitle = "Configure"
        page.nextItem = makeNotPage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            item.manager?.push(item: self.makeNotPage())
        }
        
        let rootItem: BulletinItem = page
        return BulletinManager(rootItem: rootItem)
    }()
    
    func makeNotPage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Notifications")
        page.image = UIImage(named: "notib")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "Mast can send you realtime push notifications for toots you're mentioned in, boosted toots, liked toots, as well as for new followers."
        page.actionButtonTitle = "Subscribe"
        page.alternativeButtonTitle = "No thanks"
        page.nextItem = makeSiriPage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            
            OneSignal.add(self as OSSubscriptionObserver)
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            
            item.manager?.push(item: self.makeSiriPage())
        }
        
        page.alternativeHandler = { item in
            print("Action button tapped")
            item.manager?.push(item: self.makeSiriPage())
        }
        
        return page
    }
    
    func makeSiriPage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Theme it Your Way")
        page.image = UIImage(named: "themeb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You can change the theme via the app's settings section, or long-hold anywhere in the app to cycle through them (this action can be changed).\n\nYou can also use Siri to do the same (Settings > Siri & Search > All Shortcuts)."
        page.actionButtonTitle = "Got it!"
        page.nextItem = makeDonePage()
        
        page.actionHandler = { item in
            print("Action button tapped")
            item.manager?.push(item: self.makeDonePage())
        }
        
        return page
    }
    
    func makeDonePage() -> PageBulletinItem {
        
        let page = PageBulletinItem(title: "Setup Complete")
        page.image = UIImage(named: "doneb")
        page.shouldCompactDescriptionText = true
        page.descriptionText = "You're all ready to go.\nHappy tooting!"
        page.actionButtonTitle = "Get Started"
        //page.isDismissable = true
        
        page.actionHandler = { item in
            print("Action button tapped")
            
            item.manager?.dismissBulletin(animated: true)
            
            UserDefaults.standard.set(1, forKey: "bulletindone")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.volumeBar.start()
                self.volumeBar.showInitial()
            })
        }
        
        return page
    }
    
    
    
    
    
    
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            let x00 = StoreStruct.client.baseURL
            let x11 = StoreStruct.accessToken
            let player = playerId
            StoreStruct.playerID = playerId
            
            let url = URL(string: "http://188.166.84.187:3000/register")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let myParams = "instance_url=\(x00)&access_token=\(x11)&device_token=\(player)"
            let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
            let postLength = String(format: "%d", postData!.count)
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
            
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == self.viewControllers?.last {
            return false
        }
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 && StoreStruct.currentPage == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop1"), object: nil)
        }
        if item.tag == 2 && StoreStruct.currentPage == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop2"), object: nil)
        }
        if item.tag == 3 && StoreStruct.currentPage == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop3"), object: nil)
        }
        if item.tag == 3 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLeft"), object: nil)
        }
        if item.tag == 4 {
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let imp = UIImpactFeedbackGenerator()
                imp.impactOccurred()
            }
            let controller = ComposeViewController()
            controller.inReply = []
            controller.inReplyText = ""
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    
    @objc func switch11() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 0
    }
    @objc func switch22() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 1
    }
    @objc func switch33() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 2
    }
    @objc func switch44() {
        let controller = ComposeViewController()
        controller.inReply = []
        controller.inReplyText = ""
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func confettiCreate() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateRe() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.colors = [UIColor(red: 89/250, green: 207/250, blue: 99/250, alpha: 1.0), UIColor(red: 84/250, green: 202/250, blue: 94/250, alpha: 1.0), UIColor(red: 79/250, green: 97/250, blue: 89/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateLi() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView)
        confettiView.intensity = 1
        confettiView.colors = [UIColor(red: 255/250, green: 177/250, blue: 61/250, alpha: 1.0), UIColor(red: 250/250, green: 172/250, blue: 56/250, alpha: 1.0), UIColor(red: 245/250, green: 168/250, blue: 51/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func reloadLists() {
        self.tableViewLists.reloadData()
    }
    
    @objc func startindi() {
        self.ai.alpha = 1
        self.ai.startAnimating()
    }
    
    @objc func stopindi() {
        self.ai.alpha = 0
        self.ai.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colours.white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logged), name: NSNotification.Name(rawValue: "logged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch11), name: NSNotification.Name(rawValue: "switch11"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch22), name: NSNotification.Name(rawValue: "switch22"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch33), name: NSNotification.Name(rawValue: "switch33"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.switch44), name: NSNotification.Name(rawValue: "switch44"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeLight), name: NSNotification.Name(rawValue: "light"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight), name: NSNotification.Name(rawValue: "night"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight2), name: NSNotification.Name(rawValue: "night2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeBlack), name: NSNotification.Name(rawValue: "black"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreate), name: NSNotification.Name(rawValue: "confettiCreate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateRe), name: NSNotification.Name(rawValue: "confettiCreateRe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.confettiCreateLi), name: NSNotification.Name(rawValue: "confettiCreateLi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeTopStuff), name: NSNotification.Name(rawValue: "themeTopStuff"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadLists), name: NSNotification.Name(rawValue: "reloadLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startindi), name: NSNotification.Name(rawValue: "startindi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopindi), name: NSNotification.Name(rawValue: "stopindi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.touchList), name: NSNotification.Name(rawValue: "touchList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.signOut), name: NSNotification.Name(rawValue: "signOut"), object: nil)
        
        
        
        
        if (UserDefaults.standard.object(forKey: "themeaccent") == nil) || (UserDefaults.standard.object(forKey: "themeaccent") as! Int == 0) {
            Colours.tabSelected = StoreStruct.colArray[0]
        } else {
            Colours.tabSelected = StoreStruct.colArray[UserDefaults.standard.object(forKey: "themeaccent") as! Int]
        }
        
        if (UserDefaults.standard.object(forKey: "instancesLocal") == nil) {
            
        } else {
            StoreStruct.instanceLocalToAdd = UserDefaults.standard.object(forKey: "instancesLocal") as! [String]
        }
        
        
        
        
        self.tabBar.barTintColor = Colours.white
        self.tabBar.backgroundColor = Colours.white
        self.tabBar.isTranslucent = false
        self.tabBar.unselectedItemTintColor = Colours.tabUnselected
        self.tabBar.tintColor = Colours.tabSelected
        
        statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = Colours.white
        view.addSubview(statusBarView)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        
        
        
        
        if UserDefaults.standard.object(forKey: "accessToken") == nil {} else {
            var customStyle = VolumeBarStyle.likeInstagram
            customStyle.trackTintColor = Colours.cellQuote
            customStyle.progressTintColor = Colours.grayDark
            customStyle.backgroundColor = Colours.white
            volumeBar.style = customStyle
            
            if UserDefaults.standard.object(forKey: "bulletindone") == nil {} else {
                self.volumeBar.start()
                self.volumeBar.showInitial()
            }
        }
        
        
        
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellfs")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell00")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell002")
        self.tableViewLists.register(ListCell.self, forCellReuseIdentifier: "cell002l")
        self.tableViewLists.register(ListCell2.self, forCellReuseIdentifier: "cell002l2")
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longAction(sender:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
        
        
        
        self.view0pinch.frame = self.view.frame
        self.view1pinch.frame = self.view.frame
        self.screenshotLabel.frame = (CGRect(x: 40, y: 70, width: self.view.bounds.width - 80, height: 50))
        self.screenshotLabel.text = "Let go to toot screenshot"
        self.screenshotLabel.textColor = UIColor.white
        self.screenshotLabel.textAlignment = .center
        self.screenshotLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(Colours.fontSize1))
        self.screenshotLabel.alpha = 0
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchAction(sender:)))
        view.addGestureRecognizer(pinchGesture)
        
        self.createTabBar()
        self.setupSiri()
        self.delegate = self
        
        
        if UserDefaults.standard.object(forKey: "clientID") == nil {} else {
            StoreStruct.clientID = UserDefaults.standard.object(forKey: "clientID") as! String
        }
        if UserDefaults.standard.object(forKey: "clientSecret") == nil {} else {
            StoreStruct.clientSecret = UserDefaults.standard.object(forKey: "clientSecret") as! String
        }
        if UserDefaults.standard.object(forKey: "authCode") == nil {} else {
            StoreStruct.authCode = UserDefaults.standard.object(forKey: "authCode") as! String
        }
        if UserDefaults.standard.object(forKey: "returnedText") == nil {} else {
            StoreStruct.returnedText = UserDefaults.standard.object(forKey: "returnedText") as! String
        }
        if UserDefaults.standard.object(forKey: "accessToken") == nil {
            self.createLoginView()
        } else {
            
            
            OneSignal.add(self as OSSubscriptionObserver)
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            
            
            
            StoreStruct.accessToken = UserDefaults.standard.object(forKey: "accessToken") as! String
            StoreStruct.client = Client(
                baseURL: "https://\(StoreStruct.returnedText)",
                accessToken: StoreStruct.accessToken
            )
            
            
            
            if StoreStruct.statusesHome.isEmpty {
            let request = Timelines.home()
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.statusesHome = stat
                    StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
                }
            }
            }
            
            
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.currentUser = stat
                }
            }
            
            
        }
        
        
        
        let request = Instances.customEmojis()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    StoreStruct.emotiFace = stat
                }
                
                for y in stat {
                    let attributedString = NSAttributedString(string: "    \(y.shortcode)")
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: y.staticURL.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-9), width: Int(30), height: Int(30))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    let result = NSMutableAttributedString()
                    result.append(attrStringWithImage)
                    result.append(attributedString)
                    
                    StoreStruct.mainResult.append(result)
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    @objc func pinchAction(sender:UIPinchGestureRecognizer) {
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
            
            if sender.state == .began {
                
                
                
                self.identity = self.view1pinch.transform
                
                
                if self.doOncePinch == true {
                    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
                    layer.render(in: UIGraphicsGetCurrentContext()!)
                    self.screenshot = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    
                    if (UserDefaults.standard.object(forKey: "screenshotcol") == nil) || (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 0) {
                        self.view0pinch.backgroundColor = Colours.tabSelected
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 1) {
                        self.view0pinch.backgroundColor = UIColor(red: 53/250, green: 53/250, blue: 64/250, alpha: 1.0)
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 2) {
                        self.view0pinch.backgroundColor = UIColor(red: 36/250, green: 33/250, blue: 37/250, alpha: 1.0)
                    } else if (UserDefaults.standard.object(forKey: "screenshotcol") as! Int == 3) {
                        self.view0pinch.backgroundColor = UIColor(red: 0/250, green: 0/250, blue: 0/250, alpha: 1.0)
                    }
                    self.view1pinch.image = self.screenshot
                    self.view1pinch.layer.shadowColor = UIColor.black.cgColor
                    self.view1pinch.layer.shadowOffset = CGSize(width:0, height:5)
                    self.view1pinch.layer.shadowRadius = 12
                    self.view1pinch.layer.shadowOpacity = 0.2
                    
                    
                    if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                        case 2688:
                            print("iPhone Xs Max")
                            self.view1pinch.layer.cornerRadius = 42
                        case 2436, 1792:
                            print("iPhone X")
                            self.view1pinch.layer.cornerRadius = 42
                        default:
                            self.view1pinch.layer.cornerRadius = 0
                        }
                    }
                    self.view1pinch.layer.masksToBounds = true
                    
                    
                    self.view.addSubview(self.view0pinch)
                    self.view.addSubview(self.view1pinch)
                    self.view0pinch.addSubview(self.screenshotLabel)
                    
                    self.doOncePinch = false
                }
                
            }
            if sender.state == .changed {
                print(sender.scale)
                
                
                if sender.scale < 0.9 {
                    if self.doOnceScreen == true {
                        self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: -200)
                        springWithDelay(duration: 0.5, delay: 0.0, animations: {
                            self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.screenshotLabel.alpha = 0.6
                        })
                        self.doOnceScreen = false
                    }
                } else {
                    if self.doOnceScreen == false {
                        self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.3, delay: 0.0, animations: {
                            self.screenshotLabel.transform = CGAffineTransform(translationX: 0, y: -200)
                            self.screenshotLabel.alpha = 0
                        })
                        self.doOnceScreen = true
                    }
                }
                
                
                if sender.scale < 0.8 {
                    
                    if doOnce == true {
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let impact = UIImpactFeedbackGenerator()
                            impact.impactOccurred()
                        }
                        
//                        if (UserDefaults.standard.object(forKey: "screenshotpinch") as! Int == 0) {
//                            UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
//                        }
                        
                        doOnce = false
                    }
                    
                    
                }
                
                
                if sender.scale > 1 {
                    
                } else {
                    DispatchQueue.main.async {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.view1pinch.transform = self.identity.scaledBy(x: sender.scale, y: sender.scale)
                        })
                    }
                }
                
            }
            if sender.state == .ended {
                
                DispatchQueue.main.async {
                    springWithCompletion(duration: 0.2, animations: {
                        self.view0pinch.frame = self.view.frame
                        self.view1pinch.frame = self.view.frame
                    }, completion: { finished in
                        
                        self.view0pinch.removeFromSuperview()
                        self.view1pinch.removeFromSuperview()
                        self.doOnce = true
                        self.doOncePinch = true
                        let controller = ComposeViewController()
                        controller.inReply = []
                        controller.inReplyText = ""
                        controller.selectedImage1.image = self.screenshot
                        self.present(controller, animated: true, completion: nil)
                    })
                }
                
            }
        
    }
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            if StoreStruct.instanceLocalToAdd.count > 0 {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            if self.typeOfSearch == 2 {
                return StoreStruct.statusSearchUser.count
            } else {
                return StoreStruct.statusSearch.count
            }
        } else {
            if section == 0 {
                return StoreStruct.allLists.count + 2
            } else {
                return StoreStruct.instanceLocalToAdd.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
//        if StoreStruct.statusSearch[indexPath.row].mediaAttachments.isEmpty {
            
            if self.typeOfSearch == 2 {
                print("oomp")
            if StoreStruct.statusSearchUser.count > 0 {
                print("oomp1")
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellfs", for: indexPath) as! FollowersCell
                cell.configure(StoreStruct.statusSearchUser[indexPath.row])
                cell.profileImageView.tag = indexPath.row
                //cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                cell.profileImageView.tag = indexPath.row
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
                }
            } else {
            
            if StoreStruct.statusSearch.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                    cell.configure(StoreStruct.statusSearch[indexPath.row])
                    cell.profileImageView.tag = indexPath.row
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = UIColor.white
                    cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                    cell.toot.textColor = UIColor.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell00", for: indexPath) as! MainFeedCell
                cell.profileImageView.tag = indexPath.row
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                cell.userTag.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.date.textColor = UIColor.white.withAlphaComponent(0.6)
                cell.toot.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            }
            }
        } else {
            if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
                cell.userName.text = "View Other Instance's Timeline"
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = Colours.tabSelected
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            } else if indexPath.row == 1 {
                    let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
                    cell.userName.text = "Create New List +"
                    cell.backgroundColor = Colours.grayDark3
                    cell.userName.textColor = Colours.tabSelected
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.grayDark3
                    cell.selectedBackgroundView = bgColorView
                    return cell
            } else {
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l", for: indexPath) as! ListCell
                cell.delegate = self
                cell.configure(StoreStruct.allLists[indexPath.row - 2])
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
            }
            } else {
                
                let cell = tableViewLists.dequeueReusableCell(withIdentifier: "cell002l2", for: indexPath) as! ListCell2
                cell.delegate = self
                cell.configure(StoreStruct.instanceLocalToAdd[indexPath.row])
                cell.backgroundColor = Colours.grayDark3
                cell.userName.textColor = UIColor.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.grayDark3
                cell.selectedBackgroundView = bgColorView
                return cell
                
            }
        }
            
    }
    
    
    func members(ind: Int) {
        self.dismissOverlayProper()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        if indexPath.section == 0 {
        
        guard indexPath.row > 1 else { return nil }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        let more = SwipeAction(style: .default, title: nil) { action, indexPath in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                impact.impactOccurred()
            }
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Edit List Name".localized), image: UIImage(named: "list")) { (action, ind) in
                    print(action, ind)
                    let controller = NewListViewController()
                    controller.listID = StoreStruct.allLists[indexPath.row - 2].id
                    controller.editListName = StoreStruct.allLists[indexPath.row - 2].title
                    self.present(controller, animated: true, completion: nil)
                }
                .action(.default("View List Members".localized), image: UIImage(named: "profile")) { (action, ind) in
                    print(action, ind)
                    StoreStruct.allListRelID = StoreStruct.allLists[indexPath.row - 2].id
                    self.dismissOverlayProper()
                    if StoreStruct.currentPage == 0 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers"), object: self)
                    } else if StoreStruct.currentPage == 1 {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers2"), object: self)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "goMembers3"), object: self)
                    }
                }
                .action(.default("Delete List".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)
                    
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let notification = UINotificationFeedbackGenerator()
                        notification.notificationOccurred(.success)
                    }
                    
                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                    statusAlert.title = "Deleted".localized
                    statusAlert.contentColor = Colours.grayDark
                    statusAlert.message = StoreStruct.allLists[indexPath.row - 2].title
                    statusAlert.show()
                    
                    let request = Lists.delete(id: StoreStruct.allLists[indexPath.row - 2].id)
                    StoreStruct.client.run(request) { (statuses) in
                        DispatchQueue.main.async {
                            StoreStruct.allLists.remove(at: indexPath.row - 2)
                            self.tableViewLists.reloadData()
                        }
                    }
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .show(on: self)
            
            
            if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                cell.hideSwipe(animated: true)
            }
        }
        more.backgroundColor = Colours.grayDark3
        more.image = UIImage(named: "more2")
        more.transitionDelegate = ScaleTransition.default
        more.textColor = Colours.tabUnselected
        return [more]
            
        } else {
            
            
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            
            let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    impact.impactOccurred()
                }
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Remove Instance Timeline".localized), image: UIImage(named: "block")) { (action, ind) in
                        print(action, ind)
                        
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Removed".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = StoreStruct.instanceLocalToAdd[indexPath.row]
                        statusAlert.show()
                        
                        StoreStruct.instanceLocalToAdd.remove(at: indexPath.row)
                        UserDefaults.standard.set(StoreStruct.instanceLocalToAdd, forKey: "instancesLocal")
                        //cbackhere
                        self.tableViewLists.reloadData()
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? FollowersCell {
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.grayDark3
            more.image = UIImage(named: "more2")
            more.transitionDelegate = ScaleTransition.default
            more.textColor = Colours.tabUnselected
            return [more]
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        options.buttonSpacing = 0
        options.buttonPadding = 0
        options.maximumButtonWidth = 60
        options.backgroundColor = Colours.grayDark3
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if tableView == self.tableView {
            self.dismissOverlayProperSearch()
            
            if self.typeOfSearch == 2 {
                StoreStruct.searchIndex = indexPath.row
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser2"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchUser3"), object: self)
                }
            } else {
                StoreStruct.searchIndex = indexPath.row
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search2"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "search3"), object: self)
                }
            }
            
        } else {
            self.dismissOverlayProper()
            
            if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                // other instance
                let controller = NewInstanceViewController()
                controller.editListName = ""
                self.present(controller, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                // create new list
                let controller = NewListViewController()
                self.present(controller, animated: true, completion: nil)
            } else {
                // go to list
                StoreStruct.currentList = []
                let request = Lists.accounts(id: StoreStruct.allLists[indexPath.row - 2].id)
                //let request = Lists.list(id: StoreStruct.allLists[indexPath.row - 2].id)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        for z in stat {
                            
                            let request1 = Accounts.statuses(id: z.id)
                            StoreStruct.client.run(request1) { (statuses) in
                                if let stat = (statuses.value) {
                                    StoreStruct.currentList = StoreStruct.currentList + stat
                                    StoreStruct.currentList = StoreStruct.currentList.sorted(by: { $0.createdAt > $1.createdAt })
                                    StoreStruct.currentListTitle = StoreStruct.allLists[indexPath.row - 2].title
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                                }
                                
                            }
                        }
                        if StoreStruct.currentPage == 0 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists"), object: self)
                        } else if StoreStruct.currentPage == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists2"), object: self)
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "goLists3"), object: self)
                        }
                    }
                }
            }
            
                
            } else {
                
                
                StoreStruct.instanceText = StoreStruct.instanceLocalToAdd[indexPath.row]
                
                if StoreStruct.currentPage == 0 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance"), object: self)
                } else if StoreStruct.currentPage == 1 {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance2"), object: self)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "goInstance3"), object: self)
                }
                
                
            }
                
        }
    }
    
    
    
    @objc func themeTopStuff() {
        self.tabBar.tintColor = Colours.tabSelected
    }
    
    
    @objc func longAction(sender: UILongPressGestureRecognizer) {
        
        if (UserDefaults.standard.object(forKey: "longToggle") == nil) || (UserDefaults.standard.object(forKey: "longToggle") as! Int == 0) {
        
        
        if sender.state == .began {
            print("long pressed")
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UIImpactFeedbackGenerator()
            selection.impactOccurred()
            }
            
            var newNum = 0
            if UserDefaults.standard.object(forKey: "theme") == nil {
                newNum = 1
                UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
            } else {
                let z = UserDefaults.standard.object(forKey: "theme") as! Int
                if z == 0 {
                    newNum = 1
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 1 {
                    newNum = 2
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 2 {
                    newNum = 3
                    UIApplication.shared.statusBarStyle = .lightContent
                    Colours.keyCol = UIKeyboardAppearance.dark
                }
                if z == 3 {
                    newNum = 0
                    UIApplication.shared.statusBarStyle = .default
                    Colours.keyCol = UIKeyboardAppearance.light
                }
            }
            
            UserDefaults.standard.set(newNum, forKey: "theme")
            
            DispatchQueue.main.async {
                
                self.firstView.loadLoadLoad()
                self.secondView.loadLoadLoad()
                self.thirdView.loadLoadLoad()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                
                self.view.backgroundColor = Colours.white
                self.navigationController?.navigationBar.backgroundColor = Colours.white
                self.navigationController?.navigationBar.tintColor = Colours.white
                
                self.tabBar.barTintColor = Colours.white
                self.tabBar.backgroundColor = Colours.white
                self.tabBar.unselectedItemTintColor = Colours.tabUnselected
                self.tabBar.tintColor = Colours.tabSelected
                
                self.firstView.view.backgroundColor = Colours.white
                self.secondView.view.backgroundColor = Colours.white
                self.thirdView.view.backgroundColor = Colours.white
                self.fourthView.view.backgroundColor = Colours.white
                
                self.tabOne.navigationBar.backgroundColor = Colours.white
                self.tabOne.navigationBar.barTintColor = Colours.white
                self.tabTwo.navigationBar.backgroundColor = Colours.white
                self.tabTwo.navigationBar.barTintColor = Colours.white
                self.tabThree.navigationBar.backgroundColor = Colours.white
                self.tabThree.navigationBar.barTintColor = Colours.white
                self.tabFour.navigationBar.backgroundColor = Colours.white
                self.tabFour.navigationBar.barTintColor = Colours.white
                
                self.statusBarView.backgroundColor = Colours.white
            
        }
        }
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
            //cback2
            if sender.state == .began {
            self.tList()
            }
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 2) {
            
            if sender.state == .began {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let imp = UIImpactFeedbackGenerator()
                imp.impactOccurred()
            }
            let controller = ComposeViewController()
            controller.inReply = []
            controller.inReplyText = ""
            self.present(controller, animated: true, completion: nil)
            }
            
        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 3) {
            
            if sender.state == .began {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
            }
        } else {
            
            if sender.state == .began {
                self.tSearch()
            }
        }
    }
    
    
    
    
    
    
    
    
    @objc func themeLight() {
        
                UIApplication.shared.statusBarStyle = .default
                Colours.keyCol = UIKeyboardAppearance.light
            UserDefaults.standard.set(0, forKey: "theme")
            
            DispatchQueue.main.async {
                
                self.firstView.loadLoadLoad()
                self.secondView.loadLoadLoad()
                self.thirdView.loadLoadLoad()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                
                self.view.backgroundColor = Colours.white
                self.navigationController?.navigationBar.backgroundColor = Colours.white
                self.navigationController?.navigationBar.tintColor = Colours.white
                
                self.tabBar.barTintColor = Colours.white
                self.tabBar.backgroundColor = Colours.white
                self.tabBar.unselectedItemTintColor = Colours.tabUnselected
                self.tabBar.tintColor = Colours.tabSelected
                
                self.firstView.view.backgroundColor = Colours.white
                self.secondView.view.backgroundColor = Colours.white
                self.thirdView.view.backgroundColor = Colours.white
                self.fourthView.view.backgroundColor = Colours.white
                
                self.tabOne.navigationBar.backgroundColor = Colours.white
                self.tabOne.navigationBar.barTintColor = Colours.white
                self.tabTwo.navigationBar.backgroundColor = Colours.white
                self.tabTwo.navigationBar.barTintColor = Colours.white
                self.tabThree.navigationBar.backgroundColor = Colours.white
                self.tabThree.navigationBar.barTintColor = Colours.white
                self.tabFour.navigationBar.backgroundColor = Colours.white
                self.tabFour.navigationBar.barTintColor = Colours.white
                
                self.statusBarView.backgroundColor = Colours.white
                
            }
    }
    
    @objc func themeNight() {
        
            UIApplication.shared.statusBarStyle = .lightContent
            Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(1, forKey: "theme")
        
        DispatchQueue.main.async {
            
            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white
            
            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.tabUnselected
            self.tabBar.tintColor = Colours.tabSelected
            
            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white
            
            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white
            
            self.statusBarView.backgroundColor = Colours.white
            
        }
    }
    
    @objc func themeNight2() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(2, forKey: "theme")
        
        DispatchQueue.main.async {
            
            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white
            
            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.tabUnselected
            self.tabBar.tintColor = Colours.tabSelected
            
            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white
            
            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white
            
            self.statusBarView.backgroundColor = Colours.white
            
        }
    }
    
    @objc func themeBlack() {
        
        UIApplication.shared.statusBarStyle = .lightContent
                Colours.keyCol = UIKeyboardAppearance.dark
        
        UserDefaults.standard.set(3, forKey: "theme")
        
        DispatchQueue.main.async {
            
            self.firstView.loadLoadLoad()
            self.secondView.loadLoadLoad()
            self.thirdView.loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.white
            
            self.tabBar.barTintColor = Colours.white
            self.tabBar.backgroundColor = Colours.white
            self.tabBar.unselectedItemTintColor = Colours.tabUnselected
            self.tabBar.tintColor = Colours.tabSelected
            
            self.firstView.view.backgroundColor = Colours.white
            self.secondView.view.backgroundColor = Colours.white
            self.thirdView.view.backgroundColor = Colours.white
            self.fourthView.view.backgroundColor = Colours.white
            
            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white
            
            self.statusBarView.backgroundColor = Colours.white
            
        }
    }
    
    
    
    
    //bh9
    @objc func signOut() {
        
        UserDefaults.standard.set(nil, forKey: "accessToken")
        
        do {
            try Disk.clear(.documents)
        } catch {
            print("couldn't clear disk")
        }
        
        
        self.textField.text = ""
        
        StoreStruct.client = Client(baseURL: "")
        StoreStruct.redirect = ""
        StoreStruct.returnedText = ""
        StoreStruct.clientID = ""
        StoreStruct.clientSecret = ""
        StoreStruct.authCode = ""
        StoreStruct.accessToken = ""
        StoreStruct.currentPage = 0
        StoreStruct.playerID = ""
        
        StoreStruct.caption1 = ""
        StoreStruct.caption2 = ""
        StoreStruct.caption3 = ""
        StoreStruct.caption4 = ""
        
        StoreStruct.emotiSize = 16
        StoreStruct.emotiFace = []
        StoreStruct.mainResult = []
        StoreStruct.instanceLocalToAdd = []
        
        StoreStruct.statusesHome = []
        StoreStruct.statusesLocal = []
        StoreStruct.statusesFederated = []
        
        StoreStruct.notifications = []
        StoreStruct.notificationsMentions = []
        
        StoreStruct.fromOtherUser = false
        StoreStruct.userIDtoUse = ""
        StoreStruct.profileStatuses = []
        StoreStruct.profileStatusesHasImage = []
        
        StoreStruct.statusSearch = []
        StoreStruct.statusSearchUser = []
        StoreStruct.searchIndex = 0
        
        StoreStruct.tappedTag = ""
        StoreStruct.currentUser = nil
        StoreStruct.newInstanceTags = []
        StoreStruct.instanceText = ""
        
        StoreStruct.allLists = []
        StoreStruct.allListRelID = ""
        StoreStruct.currentList = []
        StoreStruct.currentListTitle = ""
        StoreStruct.drafts = []
        
        StoreStruct.allLikes = []
        StoreStruct.allBoosts = []
        StoreStruct.allPins = []
        StoreStruct.photoNew = UIImage()
        
        self.createLoginView()
        
        
    }
    
    
    
    
    
    func createLoginView() {
        self.loginBG.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.loginBG.backgroundColor = Colours.tabSelected
        self.view.addSubview(self.loginBG)
        
        self.loginLogo.frame = CGRect(x: self.view.bounds.width/2 - 40, y: self.view.bounds.height/4 - 40, width: 80, height: 80)
        self.loginLogo.image = UIImage(named: "logLogo")
        self.loginLogo.contentMode = .scaleAspectFit
        self.loginLogo.backgroundColor = UIColor.clear
        self.view.addSubview(self.loginLogo)
        
        self.loginLabel.frame = CGRect(x: 50, y: self.view.bounds.height/2 - 57.5, width: self.view.bounds.width - 80, height: 35)
        self.loginLabel.text = "Mastodon instance:".localized
        self.loginLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loginLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.loginLabel)
        
        self.textField.frame = CGRect(x: 40, y: self.view.bounds.height/2 - 22.5, width: self.view.bounds.width - 80, height: 45)
        self.textField.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.textField.borderStyle = .none
        self.textField.layer.cornerRadius = 10
        self.textField.textColor = UIColor.white
        self.textField.spellCheckingType = .no
        self.textField.returnKeyType = .done
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(string: "mastodon.technology",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: Colours.tabSelected])
        self.view.addSubview(self.textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        let wid = self.view.bounds.width - 20
        let he = Int(self.view.bounds.height) - fromTop - fromTop
        
        
        springWithDelay(duration: 0.75, delay: 0.02, animations: {
            self.textField.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        springWithDelay(duration: 0.6, delay: 0, animations: {
            self.loginLabel.transform = CGAffineTransform(translationX: 0, y: -40)
        })
        
        if textField.text == "" {} else {
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
        })
        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
        })
        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.searchTextField {
            
            
            
            var fromTop = 45
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    print("iPhone Xs Max")
                    fromTop = 45
                case 2436, 1792:
                    print("iPhone X")
                    fromTop = 45
                default:
                    fromTop = 22
                }
            }
            
            let wid = self.view.bounds.width - 20
            let he = Int(self.view.bounds.height) - fromTop - fromTop
            
            textField.resignFirstResponder()
            
            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
            springWithDelay(duration: 0.5, delay: 0, animations: {
                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: Int(he))
            })
            self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
            springWithDelay(duration: 0.5, delay: 0, animations: {
                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(he) - 60)
            })
            
            return true
            
            
        } else {
        
        let returnedText = textField.text ?? ""
        if returnedText == "" || returnedText == " " || returnedText == "  " {
            
        } else {
            
            
            DispatchQueue.main.async {
                self.textField.resignFirstResponder()
            }
            
            // Send off returnedText to client
            StoreStruct.client = Client(baseURL: "https://\(returnedText)")
            let request = Clients.register(
                clientName: "Mast",
                redirectURI: "com.shi.mastodon://success",
                scopes: [.read, .write, .follow],
                website: "https://twitter.com/jpeguin"
            )
            StoreStruct.client.run(request) { (application) in
                
                if application.value == nil {
                    
                    DispatchQueue.main.async {
                        let statusAlert = StatusAlert()
                        statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                        statusAlert.title = "Not a valid Instance".localized
                        statusAlert.contentColor = Colours.grayDark
                        statusAlert.message = "  an Instance name like mastodon.technology"
                        statusAlert.show()
                    }
                    
                } else {
                let application = application.value!
                
                StoreStruct.clientID = application.clientID
                StoreStruct.clientSecret = application.clientSecret
                StoreStruct.returnedText = returnedText
                
                DispatchQueue.main.async {
                    StoreStruct.redirect = "com.shi.mastodon://success".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    let queryURL = URL(string: "https://\(returnedText)/oauth/authorize?response_type=code&redirect_uri=\(StoreStruct.redirect!)&scope=read%20write%20follow&client_id=\(application.clientID)")!
                    self.safariVC = SFSafariViewController(url: queryURL)
                    self.present(self.safariVC!, animated: true, completion: nil)
                }
                }
            }
        }
        return true
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        
        
        let request = Lists.all()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.allLists = stat
                DispatchQueue.main.async {
                    self.tableViewLists.reloadData()
                }
            }
        }
        
        
        if StoreStruct.currentUser == nil {
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.currentUser = stat
                }
            }
        }
        
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        if let userDefaults = UserDefaults(suiteName: "group.com.shi.Mast.wormhole") {
            userDefaults.set(StoreStruct.client.accessToken ?? "", forKey: "key1")
            userDefaults.set(StoreStruct.returnedText, forKey: "key2")
            userDefaults.synchronize()
        }
        
        
        if UserDefaults.standard.object(forKey: "accessToken") == nil {} else {
            
            
            
//            self.watchSession?.delegate = self
//            self.watchSession?.activate()
//            do {
//                try self.watchSession?.updateApplicationContext(applicationContext)
//                self.watchSession?.transferUserInfo(applicationContext)
//            } catch {
//                print("err")
//            }
        }
    }
    
    
    @objc func touchList() {
        self.tList()
    }
    
    func tList() {
        
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator()
            imp.impactOccurred()
        }
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.1
        self.backgroundView.addTarget(self, action: #selector(self.dismissOverlay), for: .touchUpInside)
        self.view.addSubview(self.backgroundView)
        
        let wid = self.view.bounds.width - 20
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 60)
        self.searcherView.backgroundColor = Colours.grayDark3
        self.searcherView.layer.cornerRadius = 20
        self.searcherView.alpha = 0
        self.searcherView.layer.masksToBounds = true
        self.view.addSubview(self.searcherView)
        
        //table
        
        
        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: Int(0))
        self.tableViewLists.alpha = 0
        self.tableViewLists.delegate = self
        self.tableViewLists.dataSource = self
        self.tableViewLists.separatorStyle = .singleLine
        self.tableViewLists.backgroundColor = Colours.grayDark3
        self.tableViewLists.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableViewLists.layer.masksToBounds = true
        self.tableViewLists.estimatedRowHeight = 89
        self.tableViewLists.rowHeight = UITableView.automaticDimension
        self.searcherView.addSubview(self.tableViewLists)
        
        //animate
        self.searcherView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        var maxHe = (Int(52) * Int(StoreStruct.allLists.count + 2)) + (Int(52) * Int(StoreStruct.instanceLocalToAdd.count))
        if maxHe > 364 {
            maxHe = Int(364)
        }
        
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 60)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: maxHe)
        })
        self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: Int(0))
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.tableViewLists.alpha = 1
            self.tableViewLists.frame = CGRect(x: 0, y: 0, width: Int(wid), height: maxHe)
        })
    }
    
    
    @objc func didTouchSearch() {
        self.tSearch()
    }
    
    func tSearch() {
        
        self.tableViewLists.alpha = 0
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let imp = UIImpactFeedbackGenerator()
            imp.impactOccurred()
        }
        
        self.typeOfSearch = 0
        
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.1
        self.backgroundView.addTarget(self, action: #selector(self.dismissOverlaySearch), for: .touchUpInside)
        self.view.addSubview(self.backgroundView)
        
        let wid = self.view.bounds.width - 20
        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 120)
        self.searcherView.backgroundColor = Colours.grayDark3
        self.searcherView.layer.cornerRadius = 20
        self.searcherView.alpha = 0
        self.searcherView.layer.masksToBounds = true
        self.view.addSubview(self.searcherView)
        
        //text field
        
        searchTextField.frame = CGRect(x: 10, y: 10, width: Int(Int(wid) - 20), height: 40)
        searchTextField.backgroundColor = Colours.grayDark3
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.layer.cornerRadius = 10
        searchTextField.alpha = 1
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...".localized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:110/250, green: 113/250, blue: 121/250, alpha: 1.0)])
        searchTextField.becomeFirstResponder()
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.textColor = UIColor.white
        searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
        self.searcherView.addSubview(searchTextField)
        
        
        segmentedControl = SJFluidSegmentedControl(frame: CGRect(x: 20, y: 60, width: Int(wid - 40), height: Int(40)))
        segmentedControl.dataSource = self
        segmentedControl.shapeStyle = .roundedRect
        segmentedControl.textFont = .systemFont(ofSize: 16, weight: .heavy)
        segmentedControl.cornerRadius = 12
        segmentedControl.shadowsEnabled = false
        segmentedControl.transitionStyle = .slide
        segmentedControl.delegate = self
        self.searcherView.addSubview(segmentedControl)
        
        //table
        
        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.grayDark3
        self.tableView.separatorColor = UIColor(red: 50/250, green: 53/250, blue: 63/250, alpha: 1.0)
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.searcherView.addSubview(self.tableView)
        
        //animate
        self.searcherView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.searcherView.alpha = 1
            self.searcherView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "Hashtags".localized
        } else if index == 1 {
            return "Related".localized
        } else {
            return "Users".localized
        }
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        return [Colours.tabSelected, Colours.tabSelected]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        return [Colours.tabSelected, Colours.tabSelected]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        
        if toIndex == 0 {
            self.typeOfSearch = 0
            let request = Timelines.tag(self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 1 {
            self.typeOfSearch = 1
            let request = Search.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearch = stat.statuses
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        if toIndex == 2 {
            self.typeOfSearch = 2
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
            //self.tableView.reloadData()
        }
        
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.tableViewLists.alpha = 0
        print("changed")
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        let wid = self.view.bounds.width - 20
        self.newestText = textField.text ?? ""
        if self.typeOfSearch == 0 {
            let theText = textField.text?.replacingOccurrences(of: "#", with: "")
        let request = Timelines.tag(theText ?? "")
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    StoreStruct.statusSearch = stat
                    self.tableView.reloadData()
                }
            }
        }
        }
        if self.typeOfSearch == 1 {
                    let request = Search.search(query: textField.text ?? "")
                    StoreStruct.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                StoreStruct.statusSearch = stat.statuses
                                self.tableView.reloadData()
                            }
                        }
                    }
        }
        if self.typeOfSearch == 2 {
            
            let request = Accounts.search(query: self.newestText)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    DispatchQueue.main.async {
                        StoreStruct.statusSearchUser = stat
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        
        
            if textField.text == "" {
                self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
                springWithDelay(duration: 0.7, delay: 0, animations: {
                    self.searcherView.alpha = 1
                    self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 120)
                })
                self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
                springWithDelay(duration: 0.7, delay: 0, animations: {
                    self.tableView.alpha = 0
                    self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
                })
            } else {
                
                if self.tableView.alpha == 0 {
                    self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 100)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.searcherView.alpha = 1
                        self.searcherView.frame = CGRect(x: 10, y: fromTop, width: Int(wid), height: 340)
                    })
                    self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(0))
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.tableView.alpha = 1
                        self.tableView.frame = CGRect(x: 0, y: 120, width: Int(wid), height: Int(220))
                    })
                }
                
            }
        
        
    }
    
    
    
    
    
    @objc func dismissOverlay(button: UIButton) {
        dismissOverlayProper()
    }
    func dismissOverlayProper() {
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        
        self.backgroundView.alpha = 0
        
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = ""
        self.searchTextField.alpha = 0
        
        let wid = self.view.bounds.width
        springWithDelay(duration: 0.37, delay: 0, animations: {
            self.searcherView.alpha = 0
        })
    }
    @objc func dismissOverlaySearch(button: UIButton) {
        dismissOverlayProperSearch()
    }
    func dismissOverlayProperSearch() {
        var fromTop = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                print("iPhone Xs Max")
                fromTop = 45
            case 2436, 1792:
                print("iPhone X")
                fromTop = 45
            default:
                fromTop = 22
            }
        }
        
        self.segmentedControl.removeFromSuperview()
        
        self.backgroundView.alpha = 0
        
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = ""
        self.searchTextField.alpha = 0
        
        let wid = self.view.bounds.width
        springWithDelay(duration: 0.37, delay: 0, animations: {
            self.searcherView.alpha = 0
        })
    }
    
    
    
    func createTabBar() {
        
        DispatchQueue.main.async {
            
            
            
            // Create Tab one
            self.tabOne = UINavigationController(rootViewController: self.firstView)
            //let tabOne = TweetsViewController()
            let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "feed")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "feed")?.maskWithColor(color: Colours.gray))
            tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabOne.tabBarItem = tabOneBarItem
            self.tabOne.navigationBar.backgroundColor = Colours.white
            self.tabOne.navigationBar.barTintColor = Colours.white
            self.tabOne.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabOne.tabBarItem.tag = 1
            //tabOne.navigationBar.shadowImage = UIImage()
            
            // Create Tab two
            self.tabTwo = UINavigationController(rootViewController: self.secondView)
            //let tabTwo = MentionsViewController()
            let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "notifications")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "notifications")?.maskWithColor(color: Colours.gray))
            tabTwoBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabTwo.tabBarItem = tabTwoBarItem2
            self.tabTwo.navigationBar.backgroundColor = Colours.white
            self.tabTwo.navigationBar.barTintColor = Colours.white
            self.tabTwo.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabTwo.tabBarItem.tag = 2
            //tabTwo.navigationBar.shadowImage = UIImage()
            
            // Create Tab three
            self.tabThree = UINavigationController(rootViewController: self.thirdView)
            //let tabThree = MessageViewController()
            let tabThreeBarItem = UITabBarItem(title: "", image: UIImage(named: "profile")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "profile")?.maskWithColor(color: Colours.gray))
            tabThreeBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabThree.tabBarItem = tabThreeBarItem
            self.tabThree.navigationBar.backgroundColor = Colours.white
            self.tabThree.navigationBar.barTintColor = Colours.white
            self.tabThree.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabThree.tabBarItem.tag = 3
            //tabThree.navigationBar.shadowImage = UIImage()
            
            // Create Tab four
            self.tabFour = UINavigationController(rootViewController: self.fourthView)
            //let tabFour = ProfileViewController()
            let tabFourBarItem = UITabBarItem(title: "", image: UIImage(named: "toot")?.maskWithColor(color: Colours.gray), selectedImage: UIImage(named: "toot")?.maskWithColor(color: Colours.gray))
            tabFourBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            self.tabFour.tabBarItem = tabFourBarItem
            self.tabFour.navigationBar.backgroundColor = Colours.white
            self.tabFour.navigationBar.barTintColor = Colours.white
            self.tabFour.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.tabFour.tabBarItem.tag = 4
            //tabFour.navigationBar.shadowImage = UIImage()
            
            
            //bh5
            var tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height) + CGFloat(34)
            var backBit = self.view.bounds.width - 61
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    backBit = self.view.bounds.width - 66
                    tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height) + CGFloat(34)
                case 2436, 1792:
                    tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height) + CGFloat(34)
                case 1136:
                    backBit = self.view.bounds.width - 54
                    tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height)
                case 1920, 2208:
                    backBit = self.view.bounds.width - 66
                    tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height)
                default:
                    tabHeight = CGFloat(UITabBarController().tabBar.frame.size.height)
                }
            }
            self.ai = NVActivityIndicatorView(frame: CGRect(x: backBit, y: self.view.bounds.height - tabHeight + 11, width: 27, height: 27), type: .circleStrokeSpin, color: Colours.tabSelected)
            self.ai.isUserInteractionEnabled = false
            self.ai.alpha = 0
            self.view.addSubview(self.ai)
//            self.ai.startAnimating()
            
            let viewControllerList = [self.tabOne, self.tabTwo, self.tabThree, self.tabFour]
            
            for x in viewControllerList {
                
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 2688:
                        print("iPhone Xs Max")
                        
//                        self.bgView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 88)
//                        self.bgView.backgroundColor = Colours.cellNorm
//                        self.navigationController?.view.addSubview(self.bgView)
                        
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 50, width: 200, height: 30)))
                        //topIcon.setImage(UIImage(named: "IconSmall"), for: .normal)
                        //topIcon.setTitle(titleToGo, for: .normal)
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        //topIcon.addTarget(self, action: #selector(self.didTouchMiddle), for: .touchUpInside)
                        //let longPressRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(self.recognizerFiredNav))
                        //longPressRecognizer1.minimumPressDuration = 0.25
                        //topIcon.addGestureRecognizer(longPressRecognizer1)
//                        self.navigationController?.view.addSubview(topIcon)
                        
                        self.settingsButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 47, width: 32, height: 32)))
                        self.settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.settingsButton.adjustsImageWhenHighlighted = false
                        self.settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
                        
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 50, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
//                        x.view.addSubview(topIcon)
                        x.view.addSubview(self.searchButton)
                        let done = UIBarButtonItem.init(customView: self.settingsButton)
//                        self.firstView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.secondView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.thirdView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.fourthView.navigationItem.setLeftBarButton(done, animated: true)
                        
                        
                    case 2436, 1792:
                        print("iPhone X")
                        
//                        self.bgView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 88)
//                        self.bgView.backgroundColor = Colours.cellNorm
//                        self.navigationController?.view.addSubview(self.bgView)
                        
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 50, width: 200, height: 30)))
                        //topIcon.setImage(UIImage(named: "IconSmall"), for: .normal)
                        //topIcon.setTitle(titleToGo, for: .normal)
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        //topIcon.addTarget(self, action: #selector(self.didTouchMiddle), for: .touchUpInside)
                        //let longPressRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(self.recognizerFiredNav))
                        //longPressRecognizer1.minimumPressDuration = 0.25
                        //topIcon.addGestureRecognizer(longPressRecognizer1)
//                        self.navigationController?.view.addSubview(topIcon)
                        
                        self.settingsButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 47, width: 32, height: 32)))
                        self.settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.settingsButton.adjustsImageWhenHighlighted = false
                        self.settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
                        
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 50, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
                        
//                        x.view.addSubview(topIcon)
                        x.view.addSubview(self.searchButton)
                        let done = UIBarButtonItem.init(customView: self.settingsButton)
//                        self.firstView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.secondView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.thirdView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.fourthView.navigationItem.setLeftBarButton(done, animated: true)
                    default:
                        
//                        self.bgView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64)
//                        self.bgView.backgroundColor = Colours.cellNorm
//                        self.navigationController?.view.addSubview(self.bgView)
                        
                        let topIcon = UIButton(frame:(CGRect(x: self.view.bounds.width/2 - 100, y: 26, width: 200, height: 30)))
                        //topIcon.setImage(UIImage(named: "IconSmall"), for: .normal)
                        //topIcon.setTitle(titleToGo, for: .normal)
                        topIcon.setTitleColor(Colours.grayDark, for: .normal)
                        topIcon.adjustsImageWhenHighlighted = false
                        //topIcon.addTarget(self, action: #selector(self.didTouchMiddle), for: .touchUpInside)
                        //let longPressRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(self.recognizerFiredNav))
                        //longPressRecognizer1.minimumPressDuration = 0.25
                        //topIcon.addGestureRecognizer(longPressRecognizer1)
//                        self.navigationController?.view.addSubview(topIcon)
                        
                        self.settingsButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 15, y: 24, width: 32, height: 35)))
                        self.settingsButton.setImage(UIImage(named: "list")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.settingsButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.settingsButton.adjustsImageWhenHighlighted = false
                        self.settingsButton.addTarget(self, action: #selector(self.touchList), for: .touchUpInside)
                        
                        self.searchButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 50, y: 27, width: 32, height: 32)))
                        self.searchButton.setImage(UIImage(named: "search")?.maskWithColor(color: Colours.grayLight2), for: .normal)
                        self.searchButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                        self.searchButton.adjustsImageWhenHighlighted = false
                        self.searchButton.addTarget(self, action: #selector(self.didTouchSearch), for: .touchUpInside)
                        
//                        x.view.addSubview(topIcon)
                        x.view.addSubview(self.searchButton)
                        let done = UIBarButtonItem.init(customView: self.settingsButton)
//                        self.firstView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.secondView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.thirdView.navigationItem.setLeftBarButton(done, animated: true)
//                        self.fourthView.navigationItem.setLeftBarButton(done, animated: true)
                        
                    }
                }
                
            }
            
            self.viewControllers = viewControllerList
            
        }
    }
    
}

extension UIImage {
    
    public func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

class MNGExpandedTouchAreaButton: UIButton {
    
    var margin:CGFloat = 10.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
