//
//  TodayViewController.swift
//  MastExtension
//
//  Created by Shihab Mehboob on 04/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var allStats: [Status] = []
    var expanded1 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        
        var client = Client(baseURL: "")
        if let userDefaults = UserDefaults(suiteName: "group.com.shi.Mast.wormhole") {
            let value1 = userDefaults.string(forKey: "key1")
            let value2 = userDefaults.string(forKey: "key2")
            client = Client(
                baseURL: "https://\(value2 ?? "")",
                accessToken: value1 ?? ""
            )
        }
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
            case 2436:
                offset = 88
            default:
                offset = 64
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        self.tableView.register(MainFeedCell.self, forCellReuseIdentifier: "cellmain")
        self.tableView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width - 20), height: Int(900))
        self.tableView.alpha = 1
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.clear
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.tableView)
        
        let request = Timelines.home()
        client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.allStats = stat
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var client = Client(baseURL: "")
        if let userDefaults = UserDefaults(suiteName: "group.com.shi.Mast.wormhole") {
            let value1 = userDefaults.string(forKey: "key1")
            let value2 = userDefaults.string(forKey: "key2")
            client = Client(
                baseURL: "https://\(value2 ?? "")",
                accessToken: value1 ?? ""
            )
        }
        
        let request = Timelines.home()
        client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.allStats = stat
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allStats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellmain", for: indexPath) as! MainFeedCell
        cell.configure(self.allStats[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.userName.textColor = UIColor.black
        cell.date.textColor = UIColor.black.withAlphaComponent(0.6)
        cell.toot.textColor = UIColor.black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        return cell
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 900) : CGSize(width: maxSize.width, height: 75)
        
        expanded1 = expanded
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
