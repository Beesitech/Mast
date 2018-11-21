//
//  PadViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 26/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import OneSignal
import StatusAlert

class PadViewController: UIViewController, UITextFieldDelegate, OSSubscriptionObserver, UIGestureRecognizerDelegate {
    
    var curr = 0
    var unselectCol = UIColor(red: 75/255.0, green: 75/255.0, blue: 85/255.0, alpha: 1.0)
    var isSearching = false
    var tappedB = 0
    
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
    
    
    var statusBarView = UIView()
    var searcherView = UIView()
    var searchTextField = UITextField()
    var backgroundView = UIButton()
    let volumeBar = VolumeBar.shared
    
    var button1 = MNGExpandedTouchAreaButton()
    var button2 = MNGExpandedTouchAreaButton()
    var button3 = MNGExpandedTouchAreaButton()
    var button4 = MNGExpandedTouchAreaButton()
    var button5 = MNGExpandedTouchAreaButton()
    
    var button6 = MNGExpandedTouchAreaButton()
    var button7 = MNGExpandedTouchAreaButton()
    
    
    var window: UIWindow?
    
    let splitViewController2 =  UISplitViewController()
    let rootNavigationController2 = UINavigationController(rootViewController: PadTimelinesViewController())
    let rootNavigationController22 = UINavigationController(rootViewController: PadTimelinesViewController())
    let splitViewController3 =  UISplitViewController()
    let splitViewController31 =  UISplitViewController()
    let rootNavigationController3 = UINavigationController(rootViewController: PadLocalTimelinesViewController())
    let detailNavigationController3 = UINavigationController(rootViewController: PadFedViewController())
    
    let splitViewController21 =  UISplitViewController()
    let rootNavigationController21 = UINavigationController(rootViewController: PadMentionsViewController())
    let detailNavigationController21 = UINavigationController(rootViewController: PadActivityViewController())
    
    let splitViewController5 =  UISplitViewController()
    let rootNavigationController5 = UINavigationController(rootViewController: ThirdViewController())
    let splitViewController6 =  UISplitViewController()
    let rootNavigationController6 = UINavigationController(rootViewController: PinnedViewController())
    let detailNavigationController6 = UINavigationController(rootViewController: LikedViewController())
    
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("newsize")
        print(size)
        
        statusBarView.frame = UIApplication.shared.statusBarFrame
        
        splitViewController3.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController3.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        splitViewController2.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController2.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController21.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController21.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        splitViewController31.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController31.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController6.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController6.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        splitViewController5.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController5.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        
        if UIDevice.current.orientation.isPortrait {
            self.splitViewController3.preferredDisplayMode = .primaryHidden
            self.splitViewController21.preferredDisplayMode = .primaryHidden
            self.splitViewController6.preferredDisplayMode = .primaryHidden
        } else {
            self.splitViewController3.preferredDisplayMode = .allVisible
            self.splitViewController21.preferredDisplayMode = .allVisible
            self.splitViewController6.preferredDisplayMode = .allVisible
        }
    }
    
    func load2() {
        
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
            Colours.grayDark = UIColor(red: 40/250, green: 40/250, blue: 40/250, alpha: 1.0)
            Colours.grayDark2 = UIColor(red: 110/250, green: 113/250, blue: 121/250, alpha: 1.0)
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.black = UIColor.black
            UIApplication.shared.statusBarStyle = .default
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 1) {
            Colours.white = UIColor(red: 53/255.0, green: 53/255.0, blue: 64/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else if (UserDefaults.standard.object(forKey: "theme") != nil && UserDefaults.standard.object(forKey: "theme") as! Int == 2) {
            Colours.white = UIColor(red: 36/255.0, green: 33/255.0, blue: 37/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 33/255.0, green: 33/255.0, blue: 43/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 55/255.0, green: 55/255.0, blue: 65/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            Colours.white = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            Colours.grayDark = UIColor(red: 250/250, green: 250/250, blue: 250/250, alpha: 1.0)
            Colours.grayDark2 = UIColor.white
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 34/255.0, green: 34/255.0, blue: 44/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 10/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    @objc func b1Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        
        self.load2()
        self.curr = 0
        self.tappedB = 0
        
        splitViewController3.viewControllers = [rootNavigationController3, detailNavigationController3]
        splitViewController3.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController3.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        if UIDevice.current.orientation.isPortrait {
            splitViewController3.preferredDisplayMode = .primaryHidden
        } else {
            splitViewController3.preferredDisplayMode = .allVisible
        }
        
        splitViewController2.viewControllers = [rootNavigationController2, splitViewController3]
        splitViewController2.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController2.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController2.preferredDisplayMode = .allVisible
        
        self.splitViewController?.viewControllers[1] = splitViewController2
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b2Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        
        self.load2()
        self.curr = 1
        self.tappedB = 1
        
        splitViewController21.viewControllers = [rootNavigationController21, detailNavigationController21]
        splitViewController21.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController21.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        if UIDevice.current.orientation.isPortrait {
            splitViewController21.preferredDisplayMode = .primaryHidden
        } else {
            splitViewController21.preferredDisplayMode = .allVisible
        }
        
        splitViewController31.viewControllers = [rootNavigationController22, splitViewController21]
        splitViewController31.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController31.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController31.preferredDisplayMode = .allVisible
        
        
        self.splitViewController?.viewControllers[1] = splitViewController31
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b3Touched() {
        
        panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
        self.isSearching = false
        
        self.load2()
        self.curr = 2
        self.tappedB = 2
        
        splitViewController6.viewControllers = [rootNavigationController6, detailNavigationController6]
        splitViewController6.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController6.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        if UIDevice.current.orientation.isPortrait {
            splitViewController6.preferredDisplayMode = .primaryHidden
        } else {
            splitViewController6.preferredDisplayMode = .allVisible
        }
        
        splitViewController5.viewControllers = [rootNavigationController5, splitViewController6]
        splitViewController5.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController5.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController5.preferredDisplayMode = .allVisible
        
        self.splitViewController?.viewControllers[1] = splitViewController5
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    
    
    
    @objc func setVC() {
            let con = PadDetailViewController()
            con.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        panelController.set(viewController: con)
        
    }
    @objc func setVC2() {
            let con = ThirdViewController()
            con.fromOtherUser = true
            con.userIDtoUse = StoreStruct.statusSearchUser[StoreStruct.searchIndex].id
        panelController.set(viewController: con)
    }
    
    
    let panelController = FloatingPanelController()
    
    @objc func b4Touched() {
        
        if self.isSearching {
            
            panelController.hidePanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            self.isSearching = false
            
        } else {
        
            if self.tappedB == 0 {
                panelController.addTo(parent: self.detailNavigationController3)
            } else if self.tappedB == 1 {
                panelController.addTo(parent: self.detailNavigationController21)
            } else {
                panelController.addTo(parent: self.detailNavigationController6)
            }
            
        panelController.resizeTo(CGSize(width:  400,
                                        height: 500))
        panelController.pinTo(position: .topLeading,
                              margins: UIEdgeInsets(top:    17, left:  18,
                                                    bottom: 42, right: 18))
        let yourContentVC = PadSearchViewController()
        panelController.set(viewController: yourContentVC)
        panelController.showPanel(animated: false, inCornerAlongXAxis: true, inCornerAlongYAxis: false)
            
            self.isSearching = true
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b5Touched() {
        
    }
    
    @objc func b6Touched() {
        let controller = SettingsViewController()
        controller.preferredContentSize.width = 700
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    @objc func b7Touched() {
        let controller = ComposeViewController()
        controller.inReply = []
        controller.inReplyText = ""
        self.present(controller, animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    
    @objc func logBackOut() {
        print("log back out")
        let controller = PadLogInViewController()
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        becomeFirstResponder()
        
        if UserDefaults.standard.object(forKey: "accessToken2") == nil {
            print("didl123")
            let controller = PadLogInViewController()
            controller.modalPresentationStyle = .formSheet
            self.present(controller, animated: true, completion: nil)
        } else {
            
            
            OneSignal.add(self as OSSubscriptionObserver)
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            
            
            
            StoreStruct.accessToken = UserDefaults.standard.object(forKey: "accessToken2") as! String
            StoreStruct.client = Client(
                baseURL: "https://\(StoreStruct.returnedText)",
                accessToken: StoreStruct.accessToken
            )
            
            
            
            let request2 = Accounts.currentUser()
            StoreStruct.client.run(request2) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.currentUser = stat
                }
            }
            
            
        }
        
        
    }
    
    
    override var keyCommands: [UIKeyCommand]? {
        //shortkeys
        let op1 = UIKeyCommand(input: "1", modifierFlags: .control, action: #selector(b1Touched), discoverabilityTitle: "Home Timelines")
        let op2 = UIKeyCommand(input: "2", modifierFlags: .control, action: #selector(b2Touched), discoverabilityTitle: "Notification Timelines")
        let op3 = UIKeyCommand(input: "3", modifierFlags: .control, action: #selector(b3Touched), discoverabilityTitle: "Profile Timelines")
        let searchThing = UIKeyCommand(input: "f", modifierFlags: .command, action: #selector(b4Touched), discoverabilityTitle: "Search")
        let setThing = UIKeyCommand(input: ";", modifierFlags: .command, action: #selector(b6Touched), discoverabilityTitle: "Settings")
        let newToot = UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(b7Touched), discoverabilityTitle: "New Toot")
        return [
            op1, op2, op3, searchThing, setThing, newToot
        ]
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func becomeFirst() {
        self.becomeFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colours.white
        splitViewController?.view.backgroundColor = Colours.cellQuote
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logBackOut), name: NSNotification.Name(rawValue: "logBackOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeLight), name: NSNotification.Name(rawValue: "light"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight), name: NSNotification.Name(rawValue: "night"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeNight2), name: NSNotification.Name(rawValue: "night2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeBlack), name: NSNotification.Name(rawValue: "black"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setVC), name: NSNotification.Name(rawValue: "setVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setVC2), name: NSNotification.Name(rawValue: "setVC2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeFirst), name: NSNotification.Name(rawValue: "becomeFirst"), object: nil)
        
        statusBarView.frame = UIApplication.shared.statusBarFrame
        statusBarView.backgroundColor = Colours.white
        view.addSubview(statusBarView)
        
        
        
        self.load2()
        self.curr = 0
        
        splitViewController3.viewControllers = [rootNavigationController3, detailNavigationController3]
        splitViewController3.preferredPrimaryColumnWidthFraction = 0.66
        splitViewController3.minimumPrimaryColumnWidth = ((self.window?.bounds.width ?? 90 - 80)/3)*2
        if UIDevice.current.orientation.isPortrait {
            splitViewController3.preferredDisplayMode = .primaryHidden
        } else {
            splitViewController3.preferredDisplayMode = .allVisible
        }
        
        splitViewController2.viewControllers = [rootNavigationController2, splitViewController3]
        splitViewController2.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController2.minimumPrimaryColumnWidth = (self.window?.bounds.width ?? 90 - 80)/3
        splitViewController2.preferredDisplayMode = .allVisible
        
        self.splitViewController?.viewControllers[1] = splitViewController2
        
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        
        
        
        
        
        
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longAction(sender:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
        
        let margins = view.layoutMarginsGuide
        let insetsConst: CGFloat = 22
        let insetsConst2: CGFloat = 22
        
        self.load2()
        
        self.button1.frame = CGRect(x: 5, y: 60, width: 70, height: 70)
        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
        self.button1.backgroundColor = UIColor.clear
        self.button1.addTarget(self, action: #selector(self.b1Touched), for: .touchUpInside)
        self.view.addSubview(self.button1)
        
        self.button2.frame = CGRect(x: 5, y: 130, width: 70, height: 70)
        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button2.backgroundColor = UIColor.clear
        self.button2.addTarget(self, action: #selector(self.b2Touched), for: .touchUpInside)
        self.view.addSubview(self.button2)
        
        self.button3.frame = CGRect(x: 5, y: 200, width: 70, height: 70)
        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button3.backgroundColor = UIColor.clear
        self.button3.addTarget(self, action: #selector(self.b3Touched), for: .touchUpInside)
        self.view.addSubview(self.button3)
        
        self.button4.frame = CGRect(x: 5, y: 270, width: 70, height: 70)
        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button4.contentEdgeInsets = UIEdgeInsets(top: insetsConst2, left: insetsConst2, bottom: insetsConst2, right: insetsConst2)
        self.button4.backgroundColor = UIColor.clear
        self.button4.addTarget(self, action: #selector(self.b4Touched), for: .touchUpInside)
        self.view.addSubview(self.button4)
        
        
        
        
        
        
//        self.button5.frame.size.height = 70
//        self.button5.frame.size.width = 70
////        self.button5.frame = CGRect(x: 5, y: self.view.bounds.height - 230, width: 70, height: 70)
//        self.button5.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
//        self.button5.contentEdgeInsets = UIEdgeInsets(top: insetsConst2, left: insetsConst2, bottom: insetsConst2, right: insetsConst2)
//        self.button5.backgroundColor = UIColor.clear
//        self.button5.addTarget(self, action: #selector(self.b5Touched), for: .touchUpInside)
//        //self.view.addSubview(self.button5)
//        self.button5.translatesAutoresizingMaskIntoConstraints = false
//
//        self.button5.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -134).isActive = true
//        self.button5.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -12).isActive = true
        
        self.button6.frame.size.height = 70
        self.button6.frame.size.width = 70
//        self.button6.frame = CGRect(x: 5, y: self.view.bounds.height - 160, width: 70, height: 70)
        self.button6.setImage(UIImage(named: "settings2")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button6.contentEdgeInsets = UIEdgeInsets(top: insetsConst, left: insetsConst, bottom: insetsConst, right: insetsConst)
        self.button6.backgroundColor = UIColor.clear
        self.button6.addTarget(self, action: #selector(self.b6Touched), for: .touchUpInside)
        self.view.addSubview(self.button6)
        self.button6.translatesAutoresizingMaskIntoConstraints = false
        
        self.button6.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -65).isActive = true
        self.button6.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -14).isActive = true
        
        self.button7.frame.size.height = 70
        self.button7.frame.size.width = 70
        self.button7.setImage(UIImage(named: "toot")?.maskWithColor(color: self.unselectCol), for: .normal)
        self.button7.backgroundColor = UIColor.clear
        self.button7.addTarget(self, action: #selector(self.b7Touched), for: .touchUpInside)
        self.view.addSubview(self.button7)
        self.button7.translatesAutoresizingMaskIntoConstraints = false
        
        self.button7.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        self.button7.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 6).isActive = true
        
        
        
        
        
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

                    (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
                    (self.rootNavigationController3.viewControllers[0] as! PadLocalTimelinesViewController).loadLoadLoad()
                    (self.detailNavigationController3.viewControllers[0] as! PadFedViewController).loadLoadLoad()
                    (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
                    (self.detailNavigationController21.viewControllers[0] as! PadActivityViewController).loadLoadLoad()
                    (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
                    (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
                    (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
                    
                    self.splitViewController2.view.backgroundColor = Colours.white
                    self.splitViewController3.view.backgroundColor = Colours.white
                    self.splitViewController31.view.backgroundColor = Colours.white
                    self.rootNavigationController22.view.backgroundColor = Colours.white
                    self.splitViewController21.view.backgroundColor = Colours.white
                    self.splitViewController5.view.backgroundColor = Colours.white
                    self.splitViewController6.view.backgroundColor = Colours.white
                    self.rootNavigationController2.view.backgroundColor = Colours.white
                    self.rootNavigationController3.view.backgroundColor = Colours.white
                    self.detailNavigationController3.view.backgroundColor = Colours.white
                    self.rootNavigationController21.view.backgroundColor = Colours.white
                    self.detailNavigationController21.view.backgroundColor = Colours.white
                    self.rootNavigationController5.view.backgroundColor = Colours.white
                    self.rootNavigationController6.view.backgroundColor = Colours.white
                    self.detailNavigationController6.view.backgroundColor = Colours.white
                    
                    self.navigationController?.view.backgroundColor = Colours.white
                    
                    self.view.backgroundColor = Colours.white
                    self.navigationController?.navigationBar.backgroundColor = Colours.white
                    self.navigationController?.navigationBar.tintColor = Colours.black
                    
                    self.statusBarView.backgroundColor = Colours.white
                    self.splitViewController?.view.backgroundColor = Colours.cellQuote

                    
                    self.load2()
                    if self.curr == 0 {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    } else if self.curr == 1 {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    } else {
                        self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                        self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                        self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
                    }
                    
                    
                    
                    
                }
            }

        } else if (UserDefaults.standard.object(forKey: "longToggle") as! Int == 1) {
            //cback2
            if sender.state == .began {
//                self.tList()
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
//                self.tSearch()
            }
        }
    }








    @objc func themeLight() {

        UIApplication.shared.statusBarStyle = .default
        Colours.keyCol = UIKeyboardAppearance.light
        UserDefaults.standard.set(0, forKey: "theme")

        DispatchQueue.main.async {

            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController3.viewControllers[0] as! PadLocalTimelinesViewController).loadLoadLoad()
            (self.detailNavigationController3.viewControllers[0] as! PadFedViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.detailNavigationController21.viewControllers[0] as! PadActivityViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController3.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController3.view.backgroundColor = Colours.white
            self.detailNavigationController3.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.detailNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black

            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote

            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }

    @objc func themeNight() {

        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(1, forKey: "theme")

        DispatchQueue.main.async {

            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController3.viewControllers[0] as! PadLocalTimelinesViewController).loadLoadLoad()
            (self.detailNavigationController3.viewControllers[0] as! PadFedViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.detailNavigationController21.viewControllers[0] as! PadActivityViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController3.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController3.view.backgroundColor = Colours.white
            self.detailNavigationController3.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.detailNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black

            
            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote

            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }

    @objc func themeNight2() {

        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(2, forKey: "theme")

        DispatchQueue.main.async {

            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController3.viewControllers[0] as! PadLocalTimelinesViewController).loadLoadLoad()
            (self.detailNavigationController3.viewControllers[0] as! PadFedViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.detailNavigationController21.viewControllers[0] as! PadActivityViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController3.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController3.view.backgroundColor = Colours.white
            self.detailNavigationController3.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.detailNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black


            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote

            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }

    @objc func themeBlack() {

        UIApplication.shared.statusBarStyle = .lightContent
        Colours.keyCol = UIKeyboardAppearance.dark

        UserDefaults.standard.set(3, forKey: "theme")

        DispatchQueue.main.async {

            (self.rootNavigationController2.viewControllers[0] as! PadTimelinesViewController).loadLoadLoad()
            (self.rootNavigationController3.viewControllers[0] as! PadLocalTimelinesViewController).loadLoadLoad()
            (self.detailNavigationController3.viewControllers[0] as! PadFedViewController).loadLoadLoad()
            (self.rootNavigationController21.viewControllers[0] as! PadMentionsViewController).loadLoadLoad()
            (self.detailNavigationController21.viewControllers[0] as! PadActivityViewController).loadLoadLoad()
            (self.rootNavigationController5.viewControllers[0] as! ThirdViewController).loadLoadLoad()
            (self.rootNavigationController6.viewControllers[0] as! PinnedViewController).loadLoadLoad()
            (self.detailNavigationController6.viewControllers[0] as! LikedViewController).loadLoadLoad()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)

            self.splitViewController2.view.backgroundColor = Colours.white
            self.splitViewController3.view.backgroundColor = Colours.white
            self.splitViewController31.view.backgroundColor = Colours.white
            self.rootNavigationController22.view.backgroundColor = Colours.white
            self.splitViewController21.view.backgroundColor = Colours.white
            self.splitViewController5.view.backgroundColor = Colours.white
            self.splitViewController6.view.backgroundColor = Colours.white
            self.rootNavigationController2.view.backgroundColor = Colours.white
            self.rootNavigationController3.view.backgroundColor = Colours.white
            self.detailNavigationController3.view.backgroundColor = Colours.white
            self.rootNavigationController21.view.backgroundColor = Colours.white
            self.detailNavigationController21.view.backgroundColor = Colours.white
            self.rootNavigationController5.view.backgroundColor = Colours.white
            self.rootNavigationController6.view.backgroundColor = Colours.white
            self.detailNavigationController6.view.backgroundColor = Colours.white
            
            self.navigationController?.view.backgroundColor = Colours.white
            
            self.view.backgroundColor = Colours.white
            self.navigationController?.navigationBar.backgroundColor = Colours.white
            self.navigationController?.navigationBar.tintColor = Colours.black

            self.statusBarView.backgroundColor = Colours.white
            self.splitViewController?.view.backgroundColor = Colours.cellQuote

            self.load2()
            if self.curr == 0 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else if self.curr == 1 {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            } else {
                self.button1.setImage(UIImage(named: "feed")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button2.setImage(UIImage(named: "notifications")?.maskWithColor(color: self.unselectCol), for: .normal)
                self.button3.setImage(UIImage(named: "profile")?.maskWithColor(color: Colours.tabSelected), for: .normal)
                self.button4.setImage(UIImage(named: "search2")?.maskWithColor(color: self.unselectCol), for: .normal)
            }
            
        }
    }
    
    
}
