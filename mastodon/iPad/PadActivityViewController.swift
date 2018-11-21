//
//  SecondViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 18/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import StatusAlert
import SAConfettiView
import ReactiveSSE
import ReactiveSwift
import OneSignal

class PadActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate, OSSubscriptionObserver {
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        print("state changed")
    }
    
    var newUpdatesB2 = UIButton()
    var countcount1 = 0
    var countcount2 = 0
    
    var blurEffectViewMain = UIView()
    var blurEffect0 = UIBlurEffect()
    var blurEffectView0 = UIVisualEffectView()
    var hMod: [Notificationt] = []
    var fMod: [Notificationt] = []
    var nsocket: WebSocket!
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    var safariVC: SFSafariViewController?
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var currentIndex = 0
    var doOnce = false
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if self.currentIndex == 1 {
            
            guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
            let detailVC = DetailViewController()
            if self.currentIndex == 0 {
                if indexPath.section == 0 {
                    return nil
                } else {
                    if StoreStruct.notifications[indexPath.row].type == .follow {
                        let controller = ThirdViewController()
                        
                        if StoreStruct.notifications[indexPath.row].account.username == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = StoreStruct.notifications[indexPath.row].account.id
                        controller.isPeeking = true
                        previewingContext.sourceRect = cell.frame
                        return controller
                    } else {
                        detailVC.mainStatus.append(StoreStruct.notifications[indexPath.row].status!)
                    }
                }
            } else {
                detailVC.mainStatus.append(StoreStruct.notificationsMentions[indexPath.row].status!)
            }
            detailVC.isPeeking = true
            previewingContext.sourceRect = cell.frame
            return detailVC
            
        } else {
            
            guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
            let detailVC = DetailViewController()
            if self.currentIndex == 0 {
                if indexPath.section == 0 {
                    return nil
                } else {
                    if StoreStruct.notifications[indexPath.row].type == .follow {
                        let controller = ThirdViewController()
                        
                        if StoreStruct.notifications[indexPath.row].account.username == StoreStruct.currentUser.username {} else {
                            controller.fromOtherUser = true
                        }
                        controller.userIDtoUse = StoreStruct.notifications[indexPath.row].account.id
                        controller.isPeeking = true
                        previewingContext.sourceRect = cell.frame
                        return controller
                    } else {
                        detailVC.mainStatus.append(StoreStruct.notifications[indexPath.row].status!)
                    }
                }
            } else {
                detailVC.mainStatus.append(StoreStruct.notificationsMentions[indexPath.row].status!)
            }
            detailVC.isPeeking = true
            previewingContext.sourceRect = cell.frame
            return detailVC
            
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    @objc func scrollTop2() {
        
        if self.currentIndex == 1 {
            
            DispatchQueue.main.async {
                if StoreStruct.notifications.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            
        } else {
            
            
            DispatchQueue.main.async {
                if StoreStruct.notifications.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            
            
        }
    }
    
    @objc func load() {
        DispatchQueue.main.async {
            self.loadLoadLoad()
        }
    }
    
    @objc func loadNewest() {
        if self.currentIndex == 1 {
            if self.tableView.contentOffset.y == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            if self.tableView.contentOffset.y == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func search() {
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func searchUser() {
        let controller = ThirdViewController()
        controller.fromOtherUser = true
        controller.userIDtoUse = StoreStruct.statusSearchUser[StoreStruct.searchIndex].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func goLists() {
        DispatchQueue.main.async {
            let controller = ListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @objc func goInstance() {
        let request = Timelines.public(local: true, range: .max(id: StoreStruct.newInstanceTags.last?.id ?? "", limit: 5000))
        let testClient = Client(
            baseURL: "https://\(StoreStruct.instanceText)",
            accessToken: StoreStruct.client.accessToken ?? ""
        )
        testClient.run(request) { (statuses) in
            if let stat = (statuses.value) {
                StoreStruct.newInstanceTags = stat
                DispatchQueue.main.async {
                    let controller = InstanceViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    
    @objc func goMembers() {
        let request = Lists.accounts(id: StoreStruct.allListRelID)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = ListMembersViewController()
                    controller.currentTagTitle = "List Members".localized
                    controller.currentTags = stat
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    @objc func confettiCreate() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateRe() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.colors = [UIColor(red: 89/250, green: 207/250, blue: 99/250, alpha: 1.0), UIColor(red: 84/250, green: 202/250, blue: 94/250, alpha: 1.0), UIColor(red: 79/250, green: 97/250, blue: 89/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    @objc func confettiCreateLi() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = true
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.9
        confettiView.colors = [UIColor(red: 255/250, green: 177/250, blue: 61/250, alpha: 1.0), UIColor(red: 250/250, green: 172/250, blue: 56/250, alpha: 1.0), UIColor(red: 245/250, green: 168/250, blue: 51/250, alpha: 1.0)]
        confettiView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    
    
    
    @objc func changeSeg() {
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var newoff = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                newoff = 45
            case 2436:
                offset = 88
                newoff = 45
            default:
                offset = 64
                newoff = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        tableView.removeFromSuperview()
        tableView.removeFromSuperview()
        
        self.tableView.register(GraphCell.self, forCellReuseIdentifier: "cellG")
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "cell3")
        self.tableView.register(NotificationCellImage.self, forCellReuseIdentifier: "cell4")
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        self.tableView.register(GraphCell.self, forCellReuseIdentifier: "cellG02")
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "cell302")
        self.tableView.register(NotificationCellImage.self, forCellReuseIdentifier: "cell402")
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        self.loadLoadLoad()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.ai.startAnimating()
        
        
        if (UserDefaults.standard.object(forKey: "biometricsnot") == nil) || (UserDefaults.standard.object(forKey: "biometricsnot") as! Int == 0) {} else {
            self.biometricAuthenticationClicked(self)
        }
    }
    
    
    
    
    
    
    func biometricAuthenticationClicked(_ sender: Any) {
        
        let win = UIApplication.shared.keyWindow
        blurEffectViewMain.frame = UIScreen.main.bounds
        blurEffectViewMain.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        UIApplication.shared.keyWindow?.addSubview(blurEffectViewMain)
        
        blurEffect0 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView0 = UIVisualEffectView(effect: blurEffect0)
        blurEffectView0.frame = UIScreen.main.bounds
        blurEffectView0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIApplication.shared.keyWindow?.addSubview(blurEffectView0)
        
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
    
    
    
    
    @objc func touchList() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "touchList"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goMembers), name: NSNotification.Name(rawValue: "goMembers2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goInstance), name: NSNotification.Name(rawValue: "goInstance2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.searchUser), name: NSNotification.Name(rawValue: "searchUser2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop2), name: NSNotification.Name(rawValue: "scrollTop2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadNewest), name: NSNotification.Name(rawValue: "loadNewest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSeg), name: NSNotification.Name(rawValue: "changeSeg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startStream), name: NSNotification.Name(rawValue: "startStream"), object: nil)
        
        self.view.backgroundColor = Colours.white
        self.title = "Activity"
        splitViewController?.view.backgroundColor = Colours.cellQuote
        
        
        //        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().backgroundColor = Colours.white
        UINavigationBar.appearance().barTintColor = Colours.black
        UINavigationBar.appearance().tintColor = Colours.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        
        
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var newoff = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                newoff = 45
            case 2436:
                offset = 88
                newoff = 45
            default:
                offset = 64
                newoff = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        
        self.tableView.register(GraphCell.self, forCellReuseIdentifier: "cellG")
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "cell3")
        self.tableView.register(NotificationCellImage.self, forCellReuseIdentifier: "cell4")
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        self.tableView.register(GraphCell.self, forCellReuseIdentifier: "cellG02")
        self.tableView.register(NotificationCell.self, forCellReuseIdentifier: "cell302")
        self.tableView.register(NotificationCellImage.self, forCellReuseIdentifier: "cell402")
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshCont), for: .valueChanged)
        //self.tableView.addSubview(refreshControl)
        
        //tableView.cr.beginHeaderRefresh()
        
        
        self.ai = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2, width: 40, height: 40), type: .circleStrokeSpin, color: Colours.tabSelected)
        self.view.addSubview(self.ai)
        self.loadLoadLoad()
        
        
        if StoreStruct.notifications.isEmpty {
            let request = Notifications.all(range: .default)
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    StoreStruct.notifications = stat
                    
//                    StoreStruct.notificationsMentions = []
                    
//                    StoreStruct.notificationsMentions = StoreStruct.notifications.filter({ (test) -> Bool in
//                        test.type == .mention
//                    })
                    
                    
                    DispatchQueue.main.async {
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                        
                        self.ai.alpha = 0
                        self.ai.removeFromSuperview()
                        
                        self.tableView.reloadData()
                        self.tableView.reloadData()
                        
                    }
                    
                    //                    for x in stat {
                    //                        if x.type == .mention {
                    //                            StoreStruct.notificationsMentions.append(x)
                    //                            DispatchQueue.main.async {
                    //                                StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                    //                                StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                    //
                    //                                self.ai.alpha = 0
                    //                                self.ai.removeFromSuperview()
                    //
                    //                                self.tableView.reloadData()
                    //                                self.tableView.reloadData()
                    //
                    //                            }
                    //                        }
                    //                    }
                    
                }
            }
        } else {
            StoreStruct.notificationsMentions = []
            
            
            StoreStruct.notificationsMentions = StoreStruct.notifications.filter({ (test) -> Bool in
                test.type == .mention
            })
            
            
            DispatchQueue.main.async {
                StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                
                self.ai.alpha = 0
                self.ai.removeFromSuperview()
                
                self.tableView.reloadData()
                self.tableView.reloadData()
                
            }
            
            
            //            for x in StoreStruct.notifications {
            //                if x.type == .mention {
            //                    StoreStruct.notificationsMentions.append(x)
            //                    DispatchQueue.main.async {
            //                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
            //                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
            //
            //                        self.ai.alpha = 0
            //                        self.ai.removeFromSuperview()
            //
            //                        self.tableView.reloadData()
            //                        self.tableView.reloadData()
            //
            //                    }
            //                }
            //            }
        }
        
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.tableView)
            registerForPreviewing(with: self, sourceView: self.tableView)
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("newsize")
        print(size)
        
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(size.width), height: Int(size.height))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
        self.navigationController?.view.backgroundColor = Colours.white
        
        StoreStruct.currentPage = 1
        //        self.tableView.reloadData()
        //        self.tableView.reloadData()
        
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.frame.width), height: Int(self.view.frame.height))
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.frame.width), height: Int(self.view.frame.height))
        
        tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            self?.refreshCont()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.cr.endHeaderRefresh()
            })
        }
        tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let selection = UISelectionFeedbackGenerator()
                selection.selectionChanged()
            }
            self?.refreshCont()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.cr.endHeaderRefresh()
            })
        }
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var newoff = 45
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                newoff = 45
            case 2436:
                offset = 88
                newoff = 45
            default:
                offset = 64
                newoff = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        //bh4
        var newSize = offset
        
        self.newUpdatesB2.frame = CGRect(x: CGFloat(self.view.bounds.width - 42), y: CGFloat(newSize), width: CGFloat(56), height: CGFloat(30))
        self.newUpdatesB2.backgroundColor = Colours.grayLight19
        self.newUpdatesB2.layer.cornerRadius = 10
        self.newUpdatesB2.setTitleColor(UIColor.white, for: .normal)
        self.newUpdatesB2.setTitle("", for: .normal)
        self.newUpdatesB2.alpha = 0
        self.view.addSubview(self.newUpdatesB2)
        
        
        
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
        self.streamDataNoti()
        }
        
        OneSignal.add(self as OSSubscriptionObserver)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.currentIndex == 1 {
            
            
            
            let indexPath1 = IndexPath(row: self.countcount1 - 1, section: 0)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath1) ?? false {
                if self.countcount1 == 0 {
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        self.countcount1 = 0
                    })
                } else {
                    self.countcount1 = self.countcount1 - 1
                    if self.countcount1 == 0 {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.countcount1 = 0
                        })
                    }
                }
            }
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.countcount1 = 0
                })
            }
            
        } else {
            
            
            
            let indexPath1 = IndexPath(row: self.countcount2 - 1, section: 1)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath1) ?? false {
                if self.countcount2 == 0 {
                    springWithDelay(duration: 0.4, delay: 0, animations: {
                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                        //                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                        springWithDelay(duration: 0.5, delay: 0, animations: {
                            self.newUpdatesB2.alpha = 0
                            self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                            //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                        })
                        self.countcount2 = 0
                    })
                } else {
                    self.countcount2 = self.countcount2 - 1
                    if self.countcount2 == 0 {
                        springWithDelay(duration: 0.4, delay: 0, animations: {
                            self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                            //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                            springWithDelay(duration: 0.5, delay: 0, animations: {
                                self.newUpdatesB2.alpha = 0
                                self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                //                                self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                            })
                            self.countcount2 = 0
                        })
                    }
                }
                self.newUpdatesB2.setTitle("\(self.countcount2)  ", for: .normal)
            }
            if (scrollView.contentOffset.y == 0) {
                springWithDelay(duration: 0.4, delay: 0, animations: {
                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                    //                    self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                    springWithDelay(duration: 0.5, delay: 0, animations: {
                        self.newUpdatesB2.alpha = 0
                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                        //                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                    })
                    self.countcount2 = 0
                })
            }
            
        }
    }
    
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y == 0 {
    //            if self.currentIndex == 1 {
    //
    //                //                if self.tableView.contentOffset.y == 0 {
    //                //                    StoreStruct.statusesHome = self.hMod.reversed() + StoreStruct.statusesHome
    //                //                    StoreStruct.statusesHome = StoreStruct.statusesHome.removeDuplicates()
    //                //                    self.tableView.reloadData()
    //                //                    self.hMod = []
    //                //                }
    //            } else {
    //
    //                if self.tableView.contentOffset.y == 0 {
    //                    StoreStruct.notifications = self.hMod.reversed() + StoreStruct.notifications
    //                    StoreStruct.notifications = StoreStruct.notifications.removeDuplicates()
    //                    self.tableView.reloadData()
    //                    self.hMod = []
    //                }
    //            }
    //        }
    //    }
    
    
    @objc func startStream() {
        self.streamDataNoti()
    }
    
    
    
    func streamDataNoti() {
        
        if (UserDefaults.standard.object(forKey: "streamToggle") == nil) || (UserDefaults.standard.object(forKey: "streamToggle") as! Int == 0) {
            
            var sss = StoreStruct.client.baseURL.replacingOccurrences(of: "https", with: "wss")
            sss = sss.replacingOccurrences(of: "http", with: "wss")
            nsocket = WebSocket(url: URL(string: "\(sss)/api/v1/streaming/user?access_token=\(StoreStruct.accessToken)&stream=user")!)
            nsocket.onConnect = {
                print("websocket is connected")
            }
            //websocketDidDisconnect
            nsocket.onDisconnect = { (error: Error?) in
                print("websocket is disconnected")
            }
            //websocketDidReceiveMessage
            nsocket.onText = { (text: String) in
                print("got some text: \(text)")
                
                let data0 = text.data(using: .utf8)!
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data0, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    let re = jsonResult?["payload"]
                    if jsonResult?["event"] as? String == "notification" {
                        let te = SSEvent.init(type: "notification", data: re as! String)
                        let data = te.data.data(using: .utf8)!
                        guard let model = try? Notificationt.decode(data: data) else {
                            return
                        }
                        self.hMod.append(model)
                        StoreStruct.notifications = self.hMod.reversed() + StoreStruct.notifications
                        StoreStruct.notifications = StoreStruct.notifications.removeDuplicates()
                        DispatchQueue.main.async {
                            //self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                            if self.currentIndex == 0 {
                                if self.tableView.contentOffset.y == 0 {
                                    
                                    if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                        self.newUpdatesB2.setTitle("\(self.hMod.count)  ", for: .normal)
                                        //                                    self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                                        self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                        springWithDelay(duration: 0.5, delay: 0, animations: {
                                            self.newUpdatesB2.alpha = 1
                                            //                                        self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                                            self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                        })
                                        self.countcount2 = self.hMod.count
                                        
                                        UIView.setAnimationsEnabled(false)
                                        self.tableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                        self.tableView.scrollToRow(at: IndexPath(row: self.hMod.count, section: 1), at: .top, animated: false)
                                        UIView.setAnimationsEnabled(true)
                                        
                                    } else {
                                        
                                        self.tableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }
                                    
                                    self.hMod = []
                                }
                            }
                        }
                        
                        
                        if model.type == .mention {
                            self.fMod.append(model)
                            DispatchQueue.main.async {
                                if self.currentIndex == 1 {
                                    if self.tableView.contentOffset.y == 0 {
                                        StoreStruct.notificationsMentions = self.fMod.reversed() + StoreStruct.notificationsMentions
                                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                                        
                                        if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                                            self.countcount1 = self.fMod.count
                                            
                                            UIView.setAnimationsEnabled(false)
                                            self.tableView.reloadData()
                                            self.refreshControl.endRefreshing()
                                            self.tableView.scrollToRow(at: IndexPath(row: self.fMod.count, section: 0), at: .top, animated: false)
                                            UIView.setAnimationsEnabled(true)
                                            
                                        } else {
                                            
                                            self.tableView.reloadData()
                                            self.refreshControl.endRefreshing()
                                        }
                                        
                                        self.fMod = []
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print("failfail")
                    return
                }
            }
            //websocketDidReceiveData
            nsocket.onData = { (data: Data) in
                print("got some data: \(data.count)")
            }
            nsocket.connect()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        DispatchQueue.main.async {
            self.ai.alpha = 0
            self.ai.removeFromSuperview()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "becomeFirst"), object: self)
    }
    
    
    
    
    // Table stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.currentIndex == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentIndex == 0 {
            if section == 0 {
                return 1
            } else {
                return StoreStruct.notifications.count
            }
        } else {
            return StoreStruct.notificationsMentions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.currentIndex == 0 && indexPath.section == 0 {
            //return 220
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
            if indexPath.section == 0 {
                
                // make graph in cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellG02", for: indexPath) as! GraphCell
                //                let data: [Double] = [Double(20), Double(50), Double(12), Double(25), Double(15), Double(5), Double(21)]
                //                let labels = ["S", "M", "T", "W", "T", "F", "S"]
                //                cell.configure(data: data, labels: labels)
                //                cell.backgroundColor = Colours.white
                //                cell.graphView.fillGradientEndColor = Colours.white
                //                cell.graphView.dataPointLabelColor = Colours.black.withAlphaComponent(0.6)
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
                
                
            } else {
                
                
                
                
                if StoreStruct.notifications.count == 0 {
                    
                    self.ai.stopAnimating()
                    self.ai.removeFromSuperview()
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell302", for: indexPath) as! NotificationCell
                    cell.backgroundColor = Colours.white
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = Colours.white
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    
                    
                    if indexPath.row == StoreStruct.notifications.count - 14 {
                        self.fetchMoreNotifications()
                    }
                    
                    if let hasStatus = StoreStruct.notifications[indexPath.row].status {
                        
                        if hasStatus.mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell302", for: indexPath) as! NotificationCell
                            cell.delegate = self
                            cell.configure(StoreStruct.notifications[indexPath.row])
                            cell.profileImageView.tag = indexPath.row
                            cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                            cell.backgroundColor = Colours.white
                            //cell.userName.textColor = Colours.black
                            //cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                            //cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                            //cell.toot.textColor = Colours.black
                            cell.typeImage.backgroundColor = Colours.white
                            cell.toot.handleMentionTap { (string) in
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                
                                var newString = string
                                for z2 in StoreStruct.notifications[indexPath.row].status!.mentions {
                                    if z2.acct.contains(string) {
                                        newString = z2.acct
                                    }
                                }
                                
                                
                                let controller = ThirdViewController()
                                if newString == StoreStruct.currentUser.username {} else {
                                    controller.fromOtherUser = true
                                }
                                let request = Accounts.search(query: newString)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        if stat.count > 0 {
                                            controller.userIDtoUse = stat[0].id
                                            DispatchQueue.main.async {
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                            cell.toot.handleURLTap { (url) in
                                // safari
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                if url.absoluteString.hasPrefix(".") {
                                    let z = URL(string: String(url.absoluteString.dropFirst()))!
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                } else {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                }
                            }
                            cell.toot.handleHashtagTap { (string) in
                                // hash
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                let controller = HashtagViewController()
                                controller.currentTagTitle = string
                                let request = Timelines.tag(string)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        controller.currentTags = stat
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                            let bgColorView = UIView()
                            bgColorView.backgroundColor = Colours.white
                            cell.selectedBackgroundView = bgColorView
                            return cell
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell402", for: indexPath) as! NotificationCellImage
                            cell.delegate = self
                            cell.configure(StoreStruct.notifications[indexPath.row])
                            cell.profileImageView.tag = indexPath.row
                            cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                            cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
                            cell.mainImageView.tag = indexPath.row
                            cell.backgroundColor = Colours.white
                            //cell.userName.textColor = Colours.black
                            //cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                            //cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                            //cell.toot.textColor = Colours.black
                            cell.typeImage.backgroundColor = Colours.white
                            cell.mainImageView.backgroundColor = Colours.white
                            cell.mainImageViewBG.backgroundColor = Colours.white
                            cell.toot.handleMentionTap { (string) in
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                
                                var newString = string
                                for z2 in StoreStruct.notifications[indexPath.row].status!.mentions {
                                    if z2.acct.contains(string) {
                                        newString = z2.acct
                                    }
                                }
                                
                                
                                let controller = ThirdViewController()
                                if newString == StoreStruct.currentUser.username {} else {
                                    controller.fromOtherUser = true
                                }
                                let request = Accounts.search(query: newString)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        if stat.count > 0 {
                                            controller.userIDtoUse = stat[0].id
                                            DispatchQueue.main.async {
                                                self.navigationController?.pushViewController(controller, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                            cell.toot.handleURLTap { (url) in
                                // safari
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                if url.absoluteString.hasPrefix(".") {
                                    let z = URL(string: String(url.absoluteString.dropFirst()))!
                                    self.safariVC = SFSafariViewController(url: z)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                } else {
                                    self.safariVC = SFSafariViewController(url: url)
                                    self.safariVC?.preferredBarTintColor = Colours.white
                                    self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                    self.present(self.safariVC!, animated: true, completion: nil)
                                }
                            }
                            cell.toot.handleHashtagTap { (string) in
                                // hash
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let selection = UISelectionFeedbackGenerator()
                                    selection.selectionChanged()
                                }
                                let controller = HashtagViewController()
                                controller.currentTagTitle = string
                                let request = Timelines.tag(string)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        controller.currentTags = stat
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                            let bgColorView = UIView()
                            bgColorView.backgroundColor = Colours.white
                            cell.selectedBackgroundView = bgColorView
                            return cell
                        }
                        
                        
                        
                    } else {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell302", for: indexPath) as! NotificationCell
                        cell.delegate = self
                        cell.configure(StoreStruct.notifications[indexPath.row])
                        cell.backgroundColor = Colours.white
                        //cell.userName.textColor = Colours.black
                        //cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        //cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        //cell.toot.textColor = Colours.black
                        cell.typeImage.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in StoreStruct.notifications[indexPath.row].status!.mentions {
                                if z2.acct.contains(string) {
                                    newString = z2.acct
                                }
                            }
                            
                            
                            let controller = ThirdViewController()
                            if newString == StoreStruct.currentUser.username {} else {
                                controller.fromOtherUser = true
                            }
                            let request = Accounts.search(query: newString)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    if stat.count > 0 {
                                        controller.userIDtoUse = stat[0].id
                                        DispatchQueue.main.async {
                                            self.navigationController?.pushViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                        cell.toot.handleURLTap { (url) in
                            // safari
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            if url.absoluteString.hasPrefix(".") {
                                let z = URL(string: String(url.absoluteString.dropFirst()))!
                                self.safariVC = SFSafariViewController(url: z)
                                self.safariVC?.preferredBarTintColor = Colours.white
                                self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                self.present(self.safariVC!, animated: true, completion: nil)
                            } else {
                                self.safariVC = SFSafariViewController(url: url)
                                self.safariVC?.preferredBarTintColor = Colours.white
                                self.safariVC?.preferredControlTintColor = Colours.tabSelected
                                self.present(self.safariVC!, animated: true, completion: nil)
                            }
                        }
                        cell.toot.handleHashtagTap { (string) in
                            // hash
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            let controller = HashtagViewController()
                            controller.currentTagTitle = string
                            let request = Timelines.tag(string)
                            StoreStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    controller.currentTags = stat
                                    DispatchQueue.main.async {
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        let bgColorView = UIView()
                        bgColorView.backgroundColor = Colours.white
                        cell.selectedBackgroundView = bgColorView
                        return cell
                    }
                }
                
            }
            
        
        
    }
    
    
    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var sto = StoreStruct.notifications
        if self.currentIndex == 0 {
            sto = StoreStruct.notifications
            print("880")
        } else if self.currentIndex == 1 {
            print("8801")
            sto = StoreStruct.notificationsMentions
        }
        
        
        let controller = ThirdViewController()
        if sto[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        controller.userIDtoUse = sto[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        var sto = StoreStruct.notifications
        if self.currentIndex == 0 {
            sto = StoreStruct.notifications
        } else if self.currentIndex == 1 {
            sto = StoreStruct.notificationsMentions
        }
        
        
        if sto[sender.tag].status?.mediaAttachments[0].type == .video || sto[sender.tag].status?.mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[sender.tag].status!.mediaAttachments[0].url)!
            XPlayer.play(videoURL)
            
        } else {
            
            var indexPath = IndexPath(row: sender.tag, section: 0)
            if self.currentIndex == 0 {
                indexPath = IndexPath(row: sender.tag, section: 1)
            }
            
            if self.currentIndex == 1 {
                let cell = tableView.cellForRow(at: indexPath) as! NotificationCellImage
                var images = [SKPhoto]()
                for y in sto[indexPath.row].status!.mediaAttachments {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[indexPath.row].status?.content.stripHTML() ?? ""
                    } else {
                        photo.caption = y.description ?? ""
                    }
                    images.append(photo)
                }
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.mainImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
            } else {
                
                let cell = tableView.cellForRow(at: indexPath) as! NotificationCellImage
                var images = [SKPhoto]()
                for y in sto[indexPath.row].status!.mediaAttachments {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[indexPath.row].status?.content.stripHTML() ?? ""
                    } else {
                        photo.caption = y.description ?? ""
                    }
                    images.append(photo)
                }
                let originImage = sender.currentImage
                if originImage != nil {
                    let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.mainImageView)
                    browser.displayToolbar = true
                    browser.displayAction = true
                    browser.delegate = self
                    browser.initializePageIndex(0)
                    present(browser, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var theTable = self.tableView
        var sto = StoreStruct.notifications
        if self.currentIndex == 0 {
            sto = StoreStruct.notifications
            theTable = self.tableView
        } else if self.currentIndex == 1 {
            sto = StoreStruct.notificationsMentions
            theTable = self.tableView
        }
        
        if StoreStruct.notifications[indexPath.row].type == .mention || self.currentIndex == 1 {
            if orientation == .left {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                
                let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                    print("boost")
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    if sto[indexPath.row].status!.reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].status?.id ?? "" ) {
                        StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[indexPath.row].status?.id ?? ""  }
                        let request2 = Statuses.unreblog(id: sto[indexPath.row].status?.id ?? "" )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                                    if sto[indexPath.row].status!.favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "like")
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                                    if sto[indexPath.row].status!.favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "like")
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    } else {
                        StoreStruct.allBoosts.append(sto[indexPath.row].status?.id ?? "" )
                        let request2 = Statuses.reblog(id: sto[indexPath.row].status?.id ?? "" )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                                }
                                
                                if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                                    if sto[indexPath.row].status!.favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")
                                    } else {
                                        cell.moreImage.image = UIImage(named: "boost")
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                                    if sto[indexPath.row].status!.favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")
                                    } else {
                                        cell.moreImage.image = UIImage(named: "boost")
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                boost.backgroundColor = Colours.white
                boost.image = UIImage(named: "boost")
                boost.transitionDelegate = ScaleTransition.default
                boost.textColor = Colours.tabUnselected
                
                let like = SwipeAction(style: .default, title: nil) { action, indexPath in
                    print("like")
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    
                    
                    
                    
                    
                    if sto[indexPath.row].status!.favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].status?.id ?? "" ) {
                        StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].status?.id ?? "" }
                        let request2 = Statuses.unfavourite(id: sto[indexPath.row].status?.id ?? "" )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                                    if sto[indexPath.row].status!.reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "boost")
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                                    if sto[indexPath.row].status!.reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "boost")
                                    } else {
                                        cell.moreImage.image = nil
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    } else {
                        StoreStruct.allLikes.append(sto[indexPath.row].status?.id ?? "" )
                        let request2 = Statuses.favourite(id: sto[indexPath.row].status?.id ?? "" )
                        StoreStruct.client.run(request2) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                                }
                                if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                                    if sto[indexPath.row].status!.reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")
                                    } else {
                                        cell.moreImage.image = UIImage(named: "like")
                                    }
                                    cell.hideSwipe(animated: true)
                                } else {
                                    let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                                    if sto[indexPath.row].status!.reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].status?.id ?? "" ) {
                                        cell.moreImage.image = nil
                                        cell.moreImage.image = UIImage(named: "fifty")
                                    } else {
                                        cell.moreImage.image = UIImage(named: "like")
                                    }
                                    cell.hideSwipe(animated: true)
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                like.backgroundColor = Colours.white
                like.image = UIImage(named: "like")
                like.transitionDelegate = ScaleTransition.default
                like.textColor = Colours.tabUnselected
                
                let reply = SwipeAction(style: .default, title: nil) { action, indexPath in
                    print("reply")
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    let controller = ComposeViewController()
                    controller.spoilerText = sto[indexPath.row].status?.spoilerText ?? ""
                    controller.inReply = [sto[indexPath.row].status!]
                    controller.inReplyText = sto[indexPath.row].account.username
                    controller.prevTextReply = sto[indexPath.row].status!.content.stripHTML()
                    print(sto[indexPath.row].account.username)
                    self.present(controller, animated: true, completion: nil)
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                reply.backgroundColor = Colours.white
                if sto[indexPath.row].status?.visibility == .direct {
                    reply.image = UIImage(named: "direct2")
                } else {
                    reply.image = UIImage(named: "reply")
                }
                reply.transitionDelegate = ScaleTransition.default
                reply.textColor = Colours.tabUnselected
                
                
                if sto[indexPath.row].status?.visibility == .direct {
                    return [reply, like]
                } else {
                    return [reply, like, boost]
                }
                
                
            } else {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                
                let more = SwipeAction(style: .default, title: nil) { action, indexPath in
                    print("boost")
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        impact.impactOccurred()
                    }
                    
                    
                    var isMuted = false
                    let request0 = Mutes.all()
                    StoreStruct.client.run(request0) { (statuses) in
                        if let stat = (statuses.value) {
                            let s = stat.filter { $0.id == sto[indexPath.row].account.id }
                            if s.isEmpty {
                                isMuted = false
                            } else {
                                isMuted = true
                            }
                        }
                    }
                    var isBlocked = false
                    let request01 = Blocks.all()
                    StoreStruct.client.run(request01) { (statuses) in
                        if let stat = (statuses.value) {
                            let s = stat.filter { $0.id == sto[indexPath.row].account.id }
                            if s.isEmpty {
                                isBlocked = false
                            } else {
                                isBlocked = true
                            }
                        }
                    }
                    
                    Alertift.actionSheet(title: nil, message: nil)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Mute/Unmute".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
                            if isMuted == false {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Muted".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                statusAlert.show()
                                
                                let request = Accounts.mute(id: sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("muted")
                                        print(stat)
                                    }
                                }
                            } else {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Unmuted".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                statusAlert.show()
                                
                                let request = Accounts.unmute(id: sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("unmuted")
                                        print(stat)
                                    }
                                }
                            }
                            
                        }
                        .action(.default("Block/Unblock".localized), image: UIImage(named: "block2")) { (action, ind) in
                            print(action, ind)
                            
                            if isBlocked == false {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Blocked".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                statusAlert.show()
                                
                                let request = Accounts.block(id: sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("blocked")
                                        print(stat)
                                    }
                                }
                            } else {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "block2large")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Unblocked".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = sto[indexPath.row].account.displayName
                                statusAlert.show()
                                
                                let request = Accounts.unblock(id: sto[indexPath.row].account.id)
                                StoreStruct.client.run(request) { (statuses) in
                                    if let stat = (statuses.value) {
                                        print("unblocked")
                                        print(stat)
                                    }
                                }
                            }
                            
                        }
                        .action(.default("Report".localized), image: UIImage(named: "report")) { (action, ind) in
                            print(action, ind)
                            
                            
                            Alertift.actionSheet()
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Harassment"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Harassment"
                                    statusAlert.show()
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].status?.id ?? ""], reason: "Harassment")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
                                        }
                                    }
                                    
                                }
                                .action(.default("No Content Warning"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "No Content Warning"
                                    statusAlert.show()
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].status?.id ?? ""], reason: "No Content Warning")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
                                        }
                                    }
                                    
                                }
                                .action(.default("Spam"), image: nil) { (action, ind) in
                                    print(action, ind)
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    
                                    
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Reported".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Spam"
                                    statusAlert.show()
                                    
                                    let request = Reports.report(accountID: sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].status?.id ?? ""], reason: "Spam")
                                    StoreStruct.client.run(request) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print("reported")
                                            print(stat)
                                        }
                                    }
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                        }
                        .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                            print(action, ind)
                            
                            let unreserved = "-._~/?"
                            let allowed = NSMutableCharacterSet.alphanumeric()
                            allowed.addCharacters(in: unreserved)
                            var bodyText = sto[indexPath.row].status?.content.stripHTML() ?? ""
                            bodyText = bodyText.replacingOccurrences(of: ".", with: " ")
                            bodyText = bodyText.replacingOccurrences(of: "!", with: " ")
                            bodyText = bodyText.replacingOccurrences(of: "?", with: " ")
                            bodyText = bodyText.replacingOccurrences(of: "~", with: " ")
                            let trans = bodyText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                            let langStr = Locale.current.languageCode
                            let urlString = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=\(langStr ?? "en")&dt=t&q=\(trans!)&ie=UTF-8&oe=UTF-8"
                            guard let requestUrl = URL(string:urlString) else {
                                return
                            }
                            let request = URLRequest(url:requestUrl)
                            let task = URLSession.shared.dataTask(with: request) {
                                (data, response, error) in
                                if error == nil, let usableData = data {
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as! [Any]
                                        let translatedText = ((((json[0] as! [Any])[0]) as! [Any])[0])
                                        
                                        Alertift.actionSheet(title: nil, message: translatedText as? String ?? "Could not translate tweet")
                                            .backgroundColor(Colours.white)
                                            .titleTextColor(Colours.grayDark)
                                            .messageTextColor(Colours.grayDark)
                                            .messageTextAlignment(.left)
                                            .titleTextAlignment(.left)
                                            .action(.cancel("Dismiss"))
                                            .finally { action, index in
                                                if action.style == .cancel {
                                                    return
                                                }
                                            }
                                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                                            .show(on: self)
                                    } catch let error as NSError {
                                        print(error)
                                    }
                                    
                                }
                            }
                            task.resume()
                        }
                        .action(.default("Share".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)
                            
                            
                            
                            
                            Alertift.actionSheet()
                                .backgroundColor(Colours.white)
                                .titleTextColor(Colours.grayDark)
                                .messageTextColor(Colours.grayDark)
                                .messageTextAlignment(.left)
                                .titleTextAlignment(.left)
                                .action(.default("Share Link".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    if let myWebsite = sto[indexPath.row].status?.url {
                                        let objectsToShare = [myWebsite]
                                        let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
//                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                                        vc.previewNumberOfLines = 5
//                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    let bodyText = sto[indexPath.row].status?.content.stripHTML()
                                    let vc = UIActivityViewController(activityItems: [bodyText ?? ""], applicationActivities: nil)
                                    vc.popoverPresentationController?.sourceView = self.view
                                    vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                    vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
//                                    let vc = VisualActivityViewController(text: bodyText ?? "")
//                                    vc.previewNumberOfLines = 5
//                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 1))?.contentView ?? self.view)
                        .show(on: self)
                    
                    
                    
                    if let cell = theTable.cellForRow(at: indexPath) as? NotificationCell {
                        cell.hideSwipe(animated: true)
                    } else {
                        let cell = theTable.cellForRow(at: indexPath) as! NotificationCellImage
                        cell.hideSwipe(animated: true)
                    }
                }
                more.backgroundColor = Colours.white
                more.image = UIImage(named: "more2")
                more.transitionDelegate = ScaleTransition.default
                more.textColor = Colours.tabUnselected
                return [more]
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        options.buttonSpacing = 0
        options.buttonPadding = 0
        options.maximumButtonWidth = 60
        options.backgroundColor = Colours.white
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if self.currentIndex == 0 {
            if indexPath.section == 1 {
                if StoreStruct.notifications[indexPath.row].type == .follow {
                    let controller = ThirdViewController()
                    if StoreStruct.notifications[indexPath.row].account.username == StoreStruct.currentUser.username {} else {
                        controller.fromOtherUser = true
                    }
                    controller.userIDtoUse = StoreStruct.notifications[indexPath.row].account.id
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = DetailViewController()
                    controller.mainStatus.append(StoreStruct.notifications[indexPath.row].status!)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            
            let controller = DetailViewController()
            controller.mainStatus.append(StoreStruct.notificationsMentions[indexPath.row].status!)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    var lastThing = ""
    func fetchMoreNotifications() {
        let request = Notifications.all(range: .max(id: StoreStruct.notifications.last?.id ?? "", limit: 5000))
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                
                
                
                
                if stat.isEmpty || self.lastThing == stat.first?.id ?? "" {} else {
                    self.lastThing = stat.first?.id ?? ""
                    StoreStruct.notifications = StoreStruct.notifications + stat
                    
//                    for x in stat {
//                        if x.type == .mention {
//                            StoreStruct.notificationsMentions.append(x)
//                        }
//                    }
                    
                    DispatchQueue.main.async {
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                        StoreStruct.notifications = StoreStruct.notifications.sorted(by: { $0.createdAt > $1.createdAt })
                        
                        StoreStruct.notifications = StoreStruct.notifications.removeDuplicates()
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                        
                        self.tableView.reloadData()
                        self.tableView.reloadData()
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func refreshCont() {
        let request = Notifications.all(range: .min(id: StoreStruct.notifications.first?.id ?? "", limit: 5000))
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    var newestC = StoreStruct.notifications.count
//                    var newestC2 = StoreStruct.notificationsMentions.count
                    
                    StoreStruct.notifications = stat + StoreStruct.notifications
                    var co = 0
//                    for x in stat {
//                        if x.type == .mention {
//                            StoreStruct.notificationsMentions = [x] + StoreStruct.notificationsMentions
//                            co = co + 1
//                        }
//                    }
                    
                    DispatchQueue.main.async {
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.sorted(by: { $0.createdAt > $1.createdAt })
                        StoreStruct.notifications = StoreStruct.notifications.sorted(by: { $0.createdAt > $1.createdAt })
                        StoreStruct.notifications = StoreStruct.notifications.removeDuplicates()
//                        StoreStruct.notificationsMentions = StoreStruct.notificationsMentions.removeDuplicates()
                        
                        newestC = StoreStruct.notifications.count - newestC
//                        newestC2 = StoreStruct.notificationsMentions.count - newestC2
                        //                        self.tableView.reloadData()
                        //                        self.tableView.reloadData()
                        //
                        //                        self.refreshControl.endRefreshing()
                        
                        
                        
                        if (UserDefaults.standard.object(forKey: "posset") == nil) || (UserDefaults.standard.object(forKey: "posset") as! Int == 0) {
                            
                            
//                            if self.currentIndex == 1 {
//                                self.newUpdatesB1.setTitle("\(newestC2)  ", for: .normal)
//                                //                        self.newUpdatesB1.transform = CGAffineTransform(translationX: 120, y: 0)
//                                self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
//                                springWithDelay(duration: 0.5, delay: 0, animations: {
//                                    self.newUpdatesB1.alpha = 1
//                                    //                            self.newUpdatesB1.transform = CGAffineTransform(translationX: 0, y: 0)
//                                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
//                                })
//                                self.countcount1 = co
//                            } else {
                            
                                self.newUpdatesB2.setTitle("\(newestC)  ", for: .normal)
                                //                            self.newUpdatesB2.transform = CGAffineTransform(translationX: 120, y: 0)
                                self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width + 78)
                                springWithDelay(duration: 0.5, delay: 0, animations: {
                                    self.newUpdatesB2.alpha = 1
                                    //                                self.newUpdatesB2.transform = CGAffineTransform(translationX: 0, y: 0)
                                    self.newUpdatesB2.frame.origin.x = CGFloat(self.view.bounds.width - 42)
                                })
                                self.countcount2 = newestC
                                
                                
//                            }
                            
                            UIView.setAnimationsEnabled(false)
                            self.tableView.reloadData()
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
//                            if self.currentIndex == 1 {
//                                if StoreStruct.notificationsMentions.count > newestC2 {
//                                    self.tableView.scrollToRow(at: IndexPath(row: newestC2, section: 0), at: .top, animated: false)
//                                }
//                            } else {
                                if StoreStruct.notifications.count > newestC {
                                    self.tableView.scrollToRow(at: IndexPath(row: newestC, section: 1), at: .top, animated: false)
                                }
//                            }
                            UIView.setAnimationsEnabled(true)
                            
                        } else {
                            self.tableView.reloadData()
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    
    func loadLoadLoad() {
        if (UserDefaults.standard.object(forKey: "theme") == nil || UserDefaults.standard.object(forKey: "theme") as! Int == 0) {
            Colours.white = UIColor.white
            Colours.grayDark = UIColor(red: 40/250, green: 40/250, blue: 40/250, alpha: 1.0)
            Colours.grayDark2 = UIColor(red: 110/250, green: 113/250, blue: 121/250, alpha: 1.0)
            Colours.cellNorm = Colours.white
            Colours.cellQuote = UIColor(red: 243/255.0, green: 242/255.0, blue: 246/255.0, alpha: 1.0)
            Colours.cellSelected = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
            Colours.tabUnselected = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
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
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
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
            Colours.tabUnselected = UIColor(red: 80/255.0, green: 80/255.0, blue: 90/255.0, alpha: 1.0)
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
            Colours.tabUnselected = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.blackUsual = UIColor(red: 70/255.0, green: 70/255.0, blue: 80/255.0, alpha: 1.0)
            Colours.cellOwn = UIColor(red: 10/255.0, green: 10/255.0, blue: 20/255.0, alpha: 1.0)
            Colours.cellAlternative = UIColor(red: 20/255.0, green: 20/255.0, blue: 30/255.0, alpha: 1.0)
            Colours.black = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        self.view.backgroundColor = Colours.white
        
        if (UserDefaults.standard.object(forKey: "systemText") == nil) || (UserDefaults.standard.object(forKey: "systemText") as! Int == 0) {
            Colours.fontSize1 = CGFloat(UIFont.systemFontSize)
            Colours.fontSize3 = CGFloat(UIFont.systemFontSize)
        } else {
            if (UserDefaults.standard.object(forKey: "fontSize") == nil) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") as! Int == 0) {
                Colours.fontSize0 = 12
                Colours.fontSize2 = 8
                Colours.fontSize1 = 12
                Colours.fontSize3 = 8
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 1) {
                Colours.fontSize0 = 13
                Colours.fontSize2 = 9
                Colours.fontSize1 = 13
                Colours.fontSize3 = 9
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 2) {
                Colours.fontSize0 = 14
                Colours.fontSize2 = 10
                Colours.fontSize1 = 14
                Colours.fontSize3 = 10
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 3) {
                Colours.fontSize0 = 15
                Colours.fontSize2 = 11
                Colours.fontSize1 = 15
                Colours.fontSize3 = 11
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 4) {
                Colours.fontSize0 = 16
                Colours.fontSize2 = 12
                Colours.fontSize1 = 16
                Colours.fontSize3 = 12
            } else if (UserDefaults.standard.object(forKey: "fontSize") != nil && UserDefaults.standard.object(forKey: "fontSize") as! Int == 5) {
                Colours.fontSize0 = 17
                Colours.fontSize2 = 13
                Colours.fontSize1 = 17
                Colours.fontSize3 = 13
            } else {
                Colours.fontSize0 = 18
                Colours.fontSize2 = 14
                Colours.fontSize1 = 18
                Colours.fontSize3 = 14
            }
        }
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
        self.tableView.backgroundColor = Colours.white
        self.tableView.separatorColor = Colours.cellQuote
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
        self.navigationController?.navigationBar.backgroundColor = Colours.white
        self.navigationController?.navigationBar.tintColor = Colours.black
        self.navigationController?.navigationBar.barTintColor = Colours.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        self.splitViewController?.view.backgroundColor = Colours.cellQuote
        
        //        var customStyle = VolumeBarStyle.likeInstagram
        //        customStyle.trackTintColor = Colours.cellQuote
        //        customStyle.progressTintColor = Colours.grayDark
        //        customStyle.backgroundColor = Colours.cellNorm
        //        volumeBar.style = customStyle
        //        volumeBar.start()
        //
        //        self.missingView.image = UIImage(named: "missing")?.maskWithColor(color: Colours.tabUnselected)
        //
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.grayDark]
        //        self.collectionView.backgroundColor = Colours.white
        //        self.removeTabbarItemsText()
    }
    
}
