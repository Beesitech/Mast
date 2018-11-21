//
//  DetailViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import StatusAlert
import SAConfettiView
import AVKit
import AVFoundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate {
    
    var safariVC: SFSafariViewController?
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var mainStatus: [Status] = []
    var allPrevious: [Status] = []
    var allReplies: [Status] = []
    var isPeeking = false
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
        let detailVC = DetailViewController()
        if indexPath.section == 0 {
            detailVC.mainStatus.append(self.allPrevious[indexPath.row])
        } else if indexPath.section == 1 {
            detailVC.mainStatus.append(self.mainStatus[0])
        } else {
            detailVC.mainStatus.append(self.allReplies[indexPath.row])
        }
        detailVC.isPeeking = true
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    @objc func load() {
        DispatchQueue.main.async {
        self.loadLoadLoad()
        }
    }
    
    @objc func search() {
        let controller = DetailViewController()
        controller.mainStatus.append(StoreStruct.statusSearch[StoreStruct.searchIndex])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func goLists() {
        DispatchQueue.main.async {
            let controller = ListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
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
        self.tableView.addSubview(confettiView)
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
    
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("newsize")
        print(size)
        
        self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(size.width), height: Int(size.height))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            print("nothing")
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.frame.width), height: Int(self.view.frame.height))
        default:
            print("nothing")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCont), name: NSNotification.Name(rawValue: "refreshCont"), object: nil)
        
        self.view.backgroundColor = Colours.white
        splitViewController?.view.backgroundColor = Colours.cellQuote
        
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = Colours.white
        UINavigationBar.appearance().barTintColor = Colours.black
        UINavigationBar.appearance().tintColor = Colours.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colours.black]
        
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
            case 2436, 1792:
                offset = 88
            default:
                offset = 64
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        if self.isPeeking == true {
            offset = 0
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            print("nothing")
        case .pad:
            self.title = "Detail"
        default:
            print("nothing")
        }
        
        switch (deviceIdiom) {
        case .phone:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        }
        
        self.tableView.register(DetailCell.self, forCellReuseIdentifier: "cell7")
        self.tableView.register(DetailCellImage.self, forCellReuseIdentifier: "cell70")
        self.tableView.register(ActionButtonCell.self, forCellReuseIdentifier: "cell10")
        self.tableView.register(ActionButtonCell2.self, forCellReuseIdentifier: "cell109")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell8")
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell800")
        self.tableView.register(RepliesCell.self, forCellReuseIdentifier: "cell80")
        self.tableView.register(RepliesCell.self, forCellReuseIdentifier: "cell8000")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell9")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell900")
        self.tableView.register(RepliesCellImage.self, forCellReuseIdentifier: "cell90")
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
        
        self.loadLoadLoad()
        
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
        //tableView.cr.beginHeaderRefresh()
        
        
        let request = Statuses.context(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.allPrevious = (stat.ancestors)
                self.allReplies = (stat.descendants)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.allPrevious.count == 0 {} else {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: false)
                        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y + 1), animated: false)
                    }
                }
            }
        }
        
        
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.tableView)
        }
    }
    
    
    
    // Table stuff
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 0
        } else if section == 2 {
            return 0
        } else {
            if self.allReplies.isEmpty {
                return 0
            } else {
                return 40
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 8, width: self.view.bounds.width, height: 30)
        if section == 0 {
            return nil
        } else if section == 1 {
            return nil
        } else if section == 2 {
            return nil
        } else if section == 3 {
            if self.allReplies.isEmpty {
                return nil
            } else {
                title.text = "All Replies".localized
            }
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.allPrevious.count
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return self.allReplies.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            
            // All previous
            
            if self.allPrevious.isEmpty {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! MainFeedCell
                cell.delegate = self
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
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
                
                if self.allPrevious[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                    
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.configure(self.allPrevious[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        
                        var newString = string
                        for z2 in self.allPrevious[indexPath.row].mentions {
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
                    
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell9", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.configure(self.allPrevious[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileP), for: .touchUpInside)
                        cell.mainImageView.addTarget(self, action: #selector(self.tappedImagePrev(_:)), for: .touchUpInside)
                        cell.mainImageView.tag = indexPath.row
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                    cell.toot.handleMentionTap { (string) in
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let selection = UISelectionFeedbackGenerator()
                            selection.selectionChanged()
                        }
                        
                        var newString = string
                        for z2 in self.allPrevious[indexPath.row].mentions {
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
            
            
            
            
            
            
        } else if indexPath.section == 1 {
            
            print("testhtml")
            print(self.mainStatus[0].content)
            
            // Main status
            
            if self.mainStatus[indexPath.row].reblog?.mediaAttachments.isEmpty ?? self.mainStatus[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! DetailCell
                cell.configure(self.mainStatus[0])
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileM), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
                cell.fromClient.textColor = Colours.black.withAlphaComponent(0.6)
                cell.faves.titleLabel?.textColor = Colours.tabSelected
                cell.faves.setTitleColor(Colours.tabSelected, for: .normal)
                cell.faves.addTarget(self, action: #selector(self.didTouchFaves), for: .touchUpInside)
                
                cell.toot.handleMentionTap { (string) in
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }
                    
                    var newString = string
                    for z2 in self.mainStatus[0].mentions {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell70", for: indexPath) as! DetailCellImage
                cell.configure(self.mainStatus[0])
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfileM), for: .touchUpInside)
                cell.mainImageView.addTarget(self, action: #selector(self.tappedImageDetail(_:)), for: .touchUpInside)
                cell.mainImageView.tag = indexPath.row
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
                cell.fromClient.textColor = Colours.black.withAlphaComponent(0.6)
                cell.faves.titleLabel?.textColor = Colours.tabSelected
                cell.faves.setTitleColor(Colours.tabSelected, for: .normal)
                cell.faves.addTarget(self, action: #selector(self.didTouchFaves), for: .touchUpInside)
                cell.mainImageView.backgroundColor = Colours.white
                
                cell.toot.handleMentionTap { (string) in
                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                        let selection = UISelectionFeedbackGenerator()
                        selection.selectionChanged()
                    }
                    
                    var newString = string
                    for z2 in self.mainStatus[0].mentions {
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
            
            
        } else if indexPath.section == 2 {
            
            // Action buttons
            
            if self.mainStatus[0].visibility == .direct {
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell109", for: indexPath) as! ActionButtonCell2
                cell.configure()
                cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
                cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
                cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
                cell.replyButton.tag = indexPath.row
                cell.likeButton.tag = indexPath.row
                cell.moreButton.tag = indexPath.row
                cell.backgroundColor = Colours.white
                let bgColorView = UIView()
                bgColorView.backgroundColor = Colours.white
                cell.selectedBackgroundView = bgColorView
                return cell
                
                
            } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell10", for: indexPath) as! ActionButtonCell
            cell.configure()
            cell.replyButton.addTarget(self, action: #selector(self.didTouchReply), for: .touchUpInside)
            cell.likeButton.addTarget(self, action: #selector(self.didTouchLike), for: .touchUpInside)
            cell.boostButton.addTarget(self, action: #selector(self.didTouchBoost), for: .touchUpInside)
            cell.moreButton.addTarget(self, action: #selector(self.didTouchMore), for: .touchUpInside)
            cell.replyButton.tag = indexPath.row
            cell.likeButton.tag = indexPath.row
            cell.boostButton.tag = indexPath.row
            cell.moreButton.tag = indexPath.row
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
            
            }
            
        } else {
            
            // All replies
            
            if self.allReplies.isEmpty {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell800", for: indexPath) as! MainFeedCell
                cell.delegate = self
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                cell.backgroundColor = Colours.white
                cell.userName.textColor = Colours.black
                cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                cell.toot.textColor = Colours.black
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
                
                if self.allReplies[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
                    
                    if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell800", for: indexPath) as! MainFeedCell
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
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
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell8000", for: indexPath) as! RepliesCell
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
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
                    
                    if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell900", for: indexPath) as! MainFeedCellImage
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
                        cell.mainImageView.tag = indexPath.row
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
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
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell90", for: indexPath) as! RepliesCellImage
                        cell.delegate = self
                        cell.configure(self.allReplies[indexPath.row])
                        cell.profileImageView.tag = indexPath.row
                        cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
                        cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
                        cell.mainImageView.tag = indexPath.row
                        cell.backgroundColor = Colours.white
                        cell.userName.textColor = Colours.black
                        cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.date.textColor = Colours.black.withAlphaComponent(0.6)
                        cell.toot.textColor = Colours.black
                        cell.mainImageView.backgroundColor = Colours.white
                        cell.toot.handleMentionTap { (string) in
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let selection = UISelectionFeedbackGenerator()
                                selection.selectionChanged()
                            }
                            
                            var newString = string
                            for z2 in self.allReplies[indexPath.row].mentions {
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
        
        
    }
    
    @objc func tappedImageDetail(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        var sto = self.mainStatus
        
        if sto[0].reblog?.mediaAttachments[0].type ?? sto[0].mediaAttachments[0].type == .video || sto[0].reblog?.mediaAttachments[0].type ?? sto[0].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[0].reblog?.mediaAttachments[0].url ?? sto[0].mediaAttachments[0].url)!
            if (UserDefaults.standard.object(forKey: "vidgif") == nil) || (UserDefaults.standard.object(forKey: "vidgif") as! Int == 0) {
                XPlayer.play(videoURL)
            } else {
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            
            
        } else {
        
        let indexPath = IndexPath(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! DetailCellImage
        var images = [SKPhoto]()
        for y in sto[0].reblog?.mediaAttachments ?? sto[0].mediaAttachments {
            let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
            photo.shouldCachePhotoURLImage = true
            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                photo.caption = sto[0].reblog?.content.stripHTML() ?? sto[0].content.stripHTML()
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
    
    @objc func didTouchFaves(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UIImpactFeedbackGenerator()
        selection.impactOccurred()
        }
        if self.mainStatus[0].reblog?.favouritesCount ?? self.mainStatus[0].favouritesCount > 0 || self.mainStatus[0].reblog?.reblogsCount ?? self.mainStatus[0].reblogsCount > 0 {
            
        let request = Statuses.favouritedBy(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    let controller = BoostersViewController()
                    controller.statusLiked = stat
                    controller.profileStatus = self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id ?? ""
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
            
        }
        
    }
    
    @objc func didTouchReply(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        let controller = ComposeViewController()
        controller.spoilerText = self.mainStatus[sender.tag].reblog?.spoilerText ?? self.mainStatus[sender.tag].spoilerText
        controller.inReply = [self.mainStatus[sender.tag].reblog ?? self.mainStatus[sender.tag]]
        controller.inReplyText = self.mainStatus[sender.tag].reblog?.account.username ?? self.mainStatus[sender.tag].account.username
        print(self.mainStatus[sender.tag].reblog?.account.username ?? self.mainStatus[sender.tag].account.username)
        controller.prevTextReply = self.mainStatus[sender.tag].reblog?.content.stripHTML() ?? self.mainStatus[sender.tag].content.stripHTML()
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func didTouchLike(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        if self.mainStatus[0].reblog?.favourited ?? self.mainStatus[0].favourited ?? false || StoreStruct.allLikes.contains(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id) {
            
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "likelarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Unliked".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            statusAlert.show()
            
            StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id }
            let request2 = Statuses.unfavourite(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in
                print(statuses.value)
            }
        } else {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "likelarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Liked".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            statusAlert.show()
            
            StoreStruct.allLikes.append(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            let request2 = Statuses.favourite(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            
            StoreStruct.client.run(request2) { (statuses) in
                DispatchQueue.main.async {
                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                }
                }
                print(statuses.value)
            }
        }
        
    }
    
    @objc func didTouchBoost(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        if self.mainStatus[0].reblog?.reblogged ?? self.mainStatus[0].reblogged ?? false || StoreStruct.allBoosts.contains(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id) {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "boostlarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Unboosted".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            statusAlert.show()
            
            StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id }
            let request2 = Statuses.unreblog(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in
                print(statuses.value)
            }
        } else {
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
            }
            let statusAlert = StatusAlert()
            statusAlert.image = UIImage(named: "boostlarge")?.maskWithColor(color: Colours.grayDark)
            statusAlert.title = "Boosted".localized
            statusAlert.contentColor = Colours.grayDark
            statusAlert.message = "Toot"
            statusAlert.show()
            
            StoreStruct.allBoosts.append(self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            let request2 = Statuses.reblog(id: self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id)
            StoreStruct.client.run(request2) { (statuses) in
                
                DispatchQueue.main.async {
                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                }
                }
                print(statuses.value)
            }
        }
        
    }
    
    @objc func didTouchMore(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        var isMuted = false
        let request0 = Mutes.all()
        StoreStruct.client.run(request0) { (statuses) in
            if let stat = (statuses.value) {
                let s = stat.filter { $0.id == self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id }
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
                let s = stat.filter { $0.id == self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id }
                if s.isEmpty {
                    isBlocked = false
                } else {
                    isBlocked = true
                }
            }
        }
        
        
        
        
        
        if self.mainStatus[0].account.id == StoreStruct.currentUser.id {
            
            
            
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Pin/Unpin".localized), image: UIImage(named: "pinned")) { (action, ind) in
                    print(action, ind)
                    if self.mainStatus[0].pinned ?? false || StoreStruct.allPins.contains(self.mainStatus[0].id) {
                        StoreStruct.allPins = StoreStruct.allPins.filter { $0 != self.mainStatus[0].id }
                        let request = Statuses.unpin(id: self.mainStatus[0].id)
                        StoreStruct.client.run(request) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Unpinned".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = "This Toot"
                                statusAlert.show()
                            }
                        }
                    } else {
                        StoreStruct.allPins.append(self.mainStatus[0].id)
                        let request = Statuses.pin(id: self.mainStatus[0].id)
                        StoreStruct.client.run(request) { (statuses) in
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Pinned".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = "This Toot"
                                statusAlert.show()
                            }
                        }
                    }
                }
                .action(.default("Delete and Redraft".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)
                    
                    let controller = ComposeViewController()
                    controller.spoilerText = self.mainStatus[0].reblog?.spoilerText ?? self.mainStatus[0].spoilerText
                    controller.idToDel = self.mainStatus[0].id
                    controller.filledTextFieldText = self.mainStatus[0].content.stripHTML()
                    self.present(controller, animated: true, completion: nil)
                    
                }
                .action(.default("Delete".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)
                    
                    let request = Statuses.delete(id: self.mainStatus[0].id)
                    StoreStruct.client.run(request) { (statuses) in
                        print("deleted")
                        
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Deleted".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Your Toot"
                            statusAlert.show()
                            //sto.remove(at: indexPath.row)
                            //self.tableView.reloadData()
                        }
                    }
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
                            
                            if let myWebsite = self.mainStatus[0].url {
                                let objectsToShare = [myWebsite]
                                let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                            print(action, ind)
                            
                            let bodyText = self.mainStatus[0].content.stripHTML()
                            let vc = VisualActivityViewController(text: bodyText)
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
                        .show(on: self)
                    
                    
                    
                    
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        return
                    }
                }
                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
                .show(on: self)
            
            
            
        } else {
        
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
                    statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                    statusAlert.show()
                    
                    let request = Accounts.mute(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                    statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                    statusAlert.show()
                    
                    let request = Accounts.unmute(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                    statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                    statusAlert.show()
                    
                    let request = Accounts.block(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                    statusAlert.message = self.mainStatus[0].reblog?.account.displayName ?? self.mainStatus[0].account.displayName
                    statusAlert.show()
                    
                    let request = Accounts.unblock(id: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id)
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
                        
                        let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "Harassment")
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
                        
                        let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "No Content Warning")
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
                        
                        let request = Reports.report(accountID: self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id, statusIDs: [self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id], reason: "Spam")
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
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
                    .show(on: self)
                
                
            }
            .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                print(action, ind)
                
                let unreserved = "-._~/?"
                let allowed = NSMutableCharacterSet.alphanumeric()
                allowed.addCharacters(in: unreserved)
                let bodyText = self.mainStatus[0].reblog?.content.stripHTML() ?? self.mainStatus[0].content.stripHTML()
                let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                trans = trans!.replacingOccurrences(of: "\n", with: "%20")
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
                            
                            var translatedText = ""
                            for i in (json[0] as! [Any]) {
                                translatedText = translatedText + ((i as! [Any])[0] as? String ?? "")
                            }
                            
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
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
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
                        
                        if let myWebsite = self.mainStatus[0].reblog?.url ?? self.mainStatus[0].url {
                            let objectsToShare = [myWebsite]
                            let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            vc.previewNumberOfLines = 5
                            vc.previewFont = UIFont.systemFont(ofSize: 14)
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                        print(action, ind)
                        
                        let bodyText = self.mainStatus[0].reblog?.content.stripHTML() ?? self.mainStatus[0].content.stripHTML()
                        let vc = VisualActivityViewController(text: bodyText)
                        vc.previewNumberOfLines = 5
                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
                    .show(on: self)
                
                
                
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.contentView ?? self.view)
            .show(on: self)
        
        }
        
    }
    
    
    @objc func didTouchProfileM(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        let controller = ThirdViewController()
        if self.mainStatus[0].reblog?.account.username ?? self.mainStatus[0].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        
        controller.userIDtoUse = self.mainStatus[0].reblog?.account.id ?? self.mainStatus[0].account.id
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func didTouchProfileP(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        print("pp1")
        
        let controller = ThirdViewController()
        if self.allPrevious[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        
        controller.userIDtoUse = self.allPrevious[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        print("pp0")
        
        let controller = ThirdViewController()
        if self.allReplies[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        
        controller.userIDtoUse = self.allReplies[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func tappedImagePrev(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        
        var sto = self.allPrevious
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
            XPlayer.play(videoURL)
            
        } else {
            
            if self.allPrevious[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
                
                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                for y in sto[indexPath.row].mediaAttachments {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
                
                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                var images = [SKPhoto]()
                for y in sto[indexPath.row].mediaAttachments {
                    let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                    photo.shouldCachePhotoURLImage = true
                    if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                        photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
    
    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        
        var sto = self.allReplies
        let indexPath = IndexPath(row: sender.tag, section: 3)
        
        
        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
            XPlayer.play(videoURL)
            
        } else {
        
        if self.allReplies[indexPath.row].inReplyToID == self.mainStatus[0].reblog?.id ?? self.mainStatus[0].id {
            
            let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
            var images = [SKPhoto]()
            for y in sto[indexPath.row].mediaAttachments {
                let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                photo.shouldCachePhotoURLImage = true
                if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                    photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
        
        let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
        var images = [SKPhoto]()
        for y in sto[indexPath.row].mediaAttachments {
            let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
            photo.shouldCachePhotoURLImage = true
            if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                photo.caption = sto[indexPath.row].content.stripHTML() ?? ""
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
        
        var sto = self.allReplies
        if indexPath.section == 0 {
            sto = self.allPrevious
        }
        
        if orientation == .left {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            
            let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("boost")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                impact.impactOccurred()
                }
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
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
                
                
                
                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                    StoreStruct.allLikes = StoreStruct.allLikes.filter { $0 != sto[indexPath.row].id }
                    let request2 = Statuses.unfavourite(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "boost")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                        if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "boost")
                        } else {
                            cell.moreImage.image = nil
                        }
                        cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCellImage {
                    if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
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
                    StoreStruct.allLikes.append(sto[indexPath.row].id)
                    let request2 = Statuses.favourite(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateLi"), object: nil)
                            }
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                                if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "like")
                                }
                                cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                        if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                            cell.moreImage.image = nil
                            cell.moreImage.image = UIImage(named: "fifty")
                        } else {
                            cell.moreImage.image = UIImage(named: "like")
                        }
                        cell.hideSwipe(animated: true)
                            } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCellImage {
                    if sto[indexPath.row].reblogged ?? false || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
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
                
                
                
                
                
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
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
                controller.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                controller.inReply = [sto[indexPath.row]]
                controller.inReplyText = sto[indexPath.row].account.username
                controller.prevTextReply = sto[indexPath.row].content.stripHTML()
                print(sto[indexPath.row].account.username)
                self.present(controller, animated: true, completion: nil)
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            reply.backgroundColor = Colours.white
            reply.image = UIImage(named: "reply")
            reply.transitionDelegate = ScaleTransition.default
            reply.textColor = Colours.tabUnselected
            
            return [reply, like, boost]
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
                
                
                
                
                if sto[indexPath.row].account.id == StoreStruct.currentUser.id {
                    
                    
                    
                    Alertift.actionSheet(title: nil, message: nil)
                        .backgroundColor(Colours.white)
                        .titleTextColor(Colours.grayDark)
                        .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                        .messageTextAlignment(.left)
                        .titleTextAlignment(.left)
                        .action(.default("Pin/Unpin".localized), image: UIImage(named: "pinned")) { (action, ind) in
                            print(action, ind)
                            if sto[indexPath.row].pinned ?? false || StoreStruct.allPins.contains(sto[indexPath.row].id) {
                                StoreStruct.allPins = StoreStruct.allPins.filter { $0 != sto[indexPath.row].id }
                                let request = Statuses.unpin(id: sto[indexPath.row].id)
                                StoreStruct.client.run(request) { (statuses) in
                                    DispatchQueue.main.async {
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }
                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Unpinned".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "This Toot"
                                        statusAlert.show()
                                    }
                                }
                            } else {
                                StoreStruct.allPins.append(sto[indexPath.row].id)
                                let request = Statuses.pin(id: sto[indexPath.row].id)
                                StoreStruct.client.run(request) { (statuses) in
                                    DispatchQueue.main.async {
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }
                                        let statusAlert = StatusAlert()
                                        statusAlert.image = UIImage(named: "pinnedlarge")?.maskWithColor(color: Colours.grayDark)
                                        statusAlert.title = "Pinned".localized
                                        statusAlert.contentColor = Colours.grayDark
                                        statusAlert.message = "This Toot"
                                        statusAlert.show()
                                    }
                                }
                            }
                        }
                        .action(.default("Delete and Redraft".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
                            let controller = ComposeViewController()
                            controller.spoilerText = sto[indexPath.row].reblog?.spoilerText ?? sto[indexPath.row].spoilerText
                            controller.idToDel = sto[indexPath.row].id
                            controller.filledTextFieldText = sto[indexPath.row].content.stripHTML()
                            self.present(controller, animated: true, completion: nil)
                            
                        }
                        .action(.default("Delete".localized), image: UIImage(named: "block")) { (action, ind) in
                            print(action, ind)
                            
                            let request = Statuses.delete(id: sto[indexPath.row].id)
                            StoreStruct.client.run(request) { (statuses) in
                                print("deleted")
                                
                                DispatchQueue.main.async {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "blocklarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Deleted".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Your Toot"
                                    statusAlert.show()
                                    //sto.remove(at: indexPath.row)
                                    //self.tableView.reloadData()
                                }
                            }
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
                                    
                                    if let myWebsite = sto[indexPath.row].url {
                                        let objectsToShare = [myWebsite]
                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .show(on: self)
                    
                    
                    
                } else {
                
                
                
                
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
                                
                                let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "Harassment")
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
                                
                                let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "No Content Warning")
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
                                
                                let request = Reports.report(accountID: sto[indexPath.row].reblog?.account.id ?? sto[indexPath.row].account.id, statusIDs: [sto[indexPath.row].reblog?.id ?? sto[indexPath.row].id], reason: "Spam")
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
                            .show(on: self)
                        
                        
                    }
                    .action(.default("Translate".localized), image: UIImage(named: "translate")) { (action, ind) in
                        print(action, ind)
                        
                        let unreserved = "-._~/?"
                        let allowed = NSMutableCharacterSet.alphanumeric()
                        allowed.addCharacters(in: unreserved)
                        let bodyText = sto[indexPath.row].content.stripHTML()
                        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
                        let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
                        var trans = bodyText.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
                        trans = trans!.replacingOccurrences(of: "\n", with: "%20")
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
                                    
                                    var translatedText = ""
                                    for i in (json[0] as! [Any]) {
                                        translatedText = translatedText + ((i as! [Any])[0] as? String ?? "")
                                    }
                                    
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
                                
                                if let myWebsite = sto[indexPath.row].url {
                                    let objectsToShare = [myWebsite]
                                    let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                print(action, ind)
                                
                                let bodyText = sto[indexPath.row].content.stripHTML()
                                let vc = VisualActivityViewController(text: bodyText)
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .show(on: self)
                        
                        
                        
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .show(on: self)
                
                    
                }
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? RepliesCell {
                    cell.hideSwipe(animated: true)
                } else if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCellImage {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! RepliesCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            more.backgroundColor = Colours.white
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
        options.backgroundColor = Colours.white
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let controller = DetailViewController()
            controller.mainStatus.append(self.allPrevious[indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.section == 3 {
            let controller = DetailViewController()
            controller.mainStatus.append(self.allReplies[indexPath.row])
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @objc func refreshCont() {
        let request = Statuses.context(id: self.mainStatus[0].id)
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.allReplies = (stat.descendants)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
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
