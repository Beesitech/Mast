//
//  LikedViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 27/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import SJFluidSegmentedControl
import SafariServices
import StatusAlert
import SAConfettiView
import AVKit
import AVFoundation

class LikedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, SKPhotoBrowserDelegate, UIViewControllerPreviewingDelegate {
    
    var ai = NVActivityIndicatorView(frame: CGRect(x:0,y:0,width:0,height:0), type: .circleStrokeSpin, color: Colours.tabSelected)
    var safariVC: SFSafariViewController?
    var segmentedControl: SJFluidSegmentedControl!
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    var currentIndex = 0
    var currentTagTitle = ""
    var currentTags: [Status] = []
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForRow(at: location) else { return nil }
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
        let detailVC = DetailViewController()
        detailVC.mainStatus.append(self.currentTags[indexPath.row])
        detailVC.isPeeking = true
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func scrollTop1() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //self.ai.startAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.goLists), name: NSNotification.Name(rawValue: "goLists"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.load), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop1), name: NSNotification.Name(rawValue: "scrollTop1"), object: nil)
        
        self.view.backgroundColor = Colours.white
        splitViewController?.view.backgroundColor = Colours.cellQuote
        
        
        //        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().backgroundColor = Colours.white
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
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        case .pad:
            self.title = "Liked"
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        default:
            self.tableView.frame = CGRect(x: 0, y: Int(offset + 5), width: Int(self.view.bounds.width), height: Int(self.view.bounds.height) - offset - tabHeight - 5)
        }
        
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(MainFeedCellImage.self, forCellReuseIdentifier: "cell2")
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
        
        //        refreshControl.addTarget(self, action: #selector(refreshCont), for: .valueChanged)
        //        self.tableView.addSubview(refreshControl)
        
        self.loadLoadLoad()
        
        
        if (traitCollection.forceTouchCapability == .available) {
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
        
//        self.navigationController?.navigationBar.tintColor = Colours.tabUnselected
//        self.navigationController?.navigationBar.barTintColor = Colours.tabUnselected
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = Colours.tabUnselected
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            print("nothing")
        case .pad:
            self.tableView.frame = CGRect(x: 0, y: Int(0), width: Int(self.view.frame.width), height: Int(self.view.frame.height))
            self.currentTags = StoreStruct.tempLiked
            print("testcurrent01")
            print(self.currentTags)
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
            self.tableView.reloadData()
        default:
            print("nothing")
        }
        
        
        
        StoreStruct.currentPage = 0
    }
    
    
    // Table stuff
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            return 40
        case .pad:
            return 0
        default:
            return 40
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let title = UILabel()
        title.frame = CGRect(x: 20, y: 8, width: self.view.bounds.width, height: 30)
        if self.currentTags.count == 0 {
            title.text = "No Liked Toots"
        } else {
            title.text = "Liked"
        }
        title.textColor = Colours.grayDark2
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.white
        
        return vw
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentTags.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.currentTags.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainFeedCell
            cell.backgroundColor = Colours.white
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.white
            cell.selectedBackgroundView = bgColorView
            return cell
        } else {
        
        if indexPath.row == self.currentTags.count - 14 {
            self.fetchMoreHome()
        }
        if self.currentTags[indexPath.row].mediaAttachments.isEmpty || (UserDefaults.standard.object(forKey: "sensitiveToggle") != nil) && (UserDefaults.standard.object(forKey: "sensitiveToggle") as? Int == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainFeedCell
            cell.delegate = self
            cell.backgroundColor = Colours.white
            cell.configure(self.currentTags[indexPath.row])
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
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
                for z2 in self.currentTags[indexPath.row].mentions {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MainFeedCellImage
            cell.delegate = self
            cell.backgroundColor = Colours.white
            cell.configure(self.currentTags[indexPath.row])
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.addTarget(self, action: #selector(self.didTouchProfile), for: .touchUpInside)
            cell.mainImageView.addTarget(self, action: #selector(self.tappedImage(_:)), for: .touchUpInside)
            cell.mainImageView.tag = indexPath.row
            cell.userName.textColor = Colours.black
            cell.userTag.textColor = Colours.black.withAlphaComponent(0.6)
            cell.date.textColor = Colours.black.withAlphaComponent(0.6)
            cell.toot.textColor = Colours.black
            cell.mainImageView.backgroundColor = Colours.white
            cell.mainImageViewBG.backgroundColor = Colours.white
            cell.toot.handleMentionTap { (string) in
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                    let selection = UISelectionFeedbackGenerator()
                    selection.selectionChanged()
                }
                
                var newString = string
                for z2 in self.currentTags[indexPath.row].mentions {
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
    
    @objc func didTouchProfile(sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        let controller = ThirdViewController()
        if self.currentTags[sender.tag].reblog?.account.username ?? self.currentTags[sender.tag].account.username == StoreStruct.currentUser.username {} else {
            controller.fromOtherUser = true
        }
        controller.userIDtoUse = self.currentTags[sender.tag].reblog?.account.id ?? self.currentTags[sender.tag].account.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func tappedImage(_ sender: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        
        var sto = self.currentTags
        
        
        if sto[sender.tag].mediaAttachments[0].type == .video || sto[sender.tag].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[sender.tag].mediaAttachments[0].url)!
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
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
            var images = [SKPhoto]()
            for y in sto[indexPath.row].mediaAttachments {
                let photo = SKPhoto.photoWithImageURL(y.url, holder: sender.currentImage)
                photo.shouldCachePhotoURLImage = true
                if (UserDefaults.standard.object(forKey: "captionset") == nil) || (UserDefaults.standard.object(forKey: "captionset") as! Int == 0) {
                    photo.caption = sto[indexPath.row].content.stripHTML()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var sto = self.currentTags
        
        
        if orientation == .left {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            
            let boost = SwipeAction(style: .default, title: nil) { action, indexPath in
                print("boost")
                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                impact.impactOccurred()
                }
                
                
                
                
                
                
                if sto[indexPath.row].reblogged! || StoreStruct.allBoosts.contains(sto[indexPath.row].id) {
                    StoreStruct.allBoosts = StoreStruct.allBoosts.filter { $0 != sto[indexPath.row].id }
                    let request2 = Statuses.unreblog(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "like")
                                } else {
                                    cell.moreImage.image = nil
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].favourited! || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
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
                    StoreStruct.allBoosts.append(sto[indexPath.row].id)
                    let request2 = Statuses.reblog(id: sto[indexPath.row].id)
                    StoreStruct.client.run(request2) { (statuses) in
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreateRe"), object: nil)
                            }
                            
                            if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                                if sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
                                    cell.moreImage.image = nil
                                    cell.moreImage.image = UIImage(named: "fifty")
                                } else {
                                    cell.moreImage.image = UIImage(named: "boost")
                                }
                                cell.hideSwipe(animated: true)
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                                if sto[indexPath.row].favourited ?? false || StoreStruct.allLikes.contains(sto[indexPath.row].id) {
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
                
                
                
                
                
                
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                            } else {
                                let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
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
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                like.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    like.backgroundColor = Colours.cellQuote
                } else {
                    like.backgroundColor = Colours.white
                }
            }
            
            
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
                print(sto[indexPath.row].account.username)
                controller.prevTextReply = sto[indexPath.row].content.stripHTML()
                self.present(controller, animated: true, completion: nil)
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                reply.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    reply.backgroundColor = Colours.cellQuote
                } else {
                    reply.backgroundColor = Colours.white
                }
            }
            
            
            reply.transitionDelegate = ScaleTransition.default
            reply.textColor = Colours.tabUnselected
            
            if sto[indexPath.row].reblog?.visibility ?? sto[indexPath.row].visibility == .direct {
                reply.image = UIImage(named: "direct2")
                return [reply, like]
            } else {
                reply.image = UIImage(named: "reply")
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
                                        if UIDevice.current.userInterfaceIdiom == .pad {
                                            let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                            vc.popoverPresentationController?.sourceView = self.view
                                            vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                            vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                            self.present(vc, animated: true, completion: nil)
                                        } else {
                                        let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.previewNumberOfLines = 5
                                        vc.previewFont = UIFont.systemFont(ofSize: 14)
                                        self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }
                                .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                    print(action, ind)
                                    
                                    let bodyText = sto[indexPath.row].content.stripHTML()
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        let vc = UIActivityViewController(activityItems: [bodyText], applicationActivities: nil)
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                        self.present(vc, animated: true, completion: nil)
                                    } else {
                                    let vc = VisualActivityViewController(text: bodyText)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    }
                                    
                                }
                                .action(.cancel("Dismiss"))
                                .finally { action, index in
                                    if action.style == .cancel {
                                        return
                                    }
                                }
                                .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                                .show(on: self)
                            
                            
                            
                            
                        }
                        .action(.cancel("Dismiss"))
                        .finally { action, index in
                            if action.style == .cancel {
                                return
                            }
                        }
                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                                        .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
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
                                    if UIDevice.current.userInterfaceIdiom == .pad {
                                        let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                        self.present(vc, animated: true, completion: nil)
                                    } else {
                                    let vc = VisualActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                                    vc.previewNumberOfLines = 5
                                    vc.previewFont = UIFont.systemFont(ofSize: 14)
                                    self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                            .action(.default("Share Text".localized), image: UIImage(named: "share")) { (action, ind) in
                                print(action, ind)
                                
                                let bodyText = sto[indexPath.row].content.stripHTML()
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    let vc = UIActivityViewController(activityItems: [bodyText], applicationActivities: nil)
                                    vc.popoverPresentationController?.sourceView = self.view
                                    vc.popoverPresentationController?.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                                    vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
                                    self.present(vc, animated: true, completion: nil)
                                } else {
                                let vc = VisualActivityViewController(text: bodyText)
                                vc.previewNumberOfLines = 5
                                vc.previewFont = UIFont.systemFont(ofSize: 14)
                                self.present(vc, animated: true, completion: nil)
                                }
                                
                            }
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                            .show(on: self)
                        
                        
                        
                        
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.contentView ?? self.view)
                    .show(on: self)
                
                
            }
                
                if let cell = tableView.cellForRow(at: indexPath) as? MainFeedCell {
                    cell.hideSwipe(animated: true)
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! MainFeedCellImage
                    cell.hideSwipe(animated: true)
                }
            }
            
            if (UserDefaults.standard.object(forKey: "dmTog") == nil) || (UserDefaults.standard.object(forKey: "dmTog") as! Int == 0) {
                more.backgroundColor = Colours.white
            } else {
                if sto[indexPath.row].visibility == .direct {
                    more.backgroundColor = Colours.cellQuote
                } else {
                    more.backgroundColor = Colours.white
                }
            }
            
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
        
        let controller = DetailViewController()
        controller.mainStatus.append(self.currentTags[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    var lastThing = ""
    
    func fetchMoreHome() {
        let request = Favourites.all(range: .max(id: self.currentTags.last?.id ?? "", limit: 5000))
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty || self.lastThing == stat.first?.id ?? "" {} else {
                    self.lastThing = stat.first?.id ?? ""
                    
                self.currentTags = self.currentTags + stat
                DispatchQueue.main.async {
                    self.currentTags = self.currentTags.removeDuplicates()
                    self.tableView.reloadData()
                }
                }
            }
        }
    }
    
    @objc func refreshCont() {
        
        let request = Favourites.all(range: .min(id: self.currentTags.first?.id ?? "", limit: 5000))
        DispatchQueue.global(qos: .userInitiated).async {
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    var newestC = self.currentTags.count
                    self.currentTags = stat + self.currentTags
                    DispatchQueue.main.async {
                        
                        self.currentTags = self.currentTags.removeDuplicates()
                        newestC = self.currentTags.count - newestC
                        UIView.setAnimationsEnabled(false)
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.tableView.scrollToRow(at: IndexPath(row: newestC, section: 0), at: .top, animated: false)
                        UIView.setAnimationsEnabled(true)
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
            Colours.cellQuote = UIColor(red: 20/255.0, green: 20/255.0, blue: 29/255.0, alpha: 1.0)
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




