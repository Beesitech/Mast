//
//  InterfaceController.swift
//  MastWatch Extension
//
//  Created by Shihab Mehboob on 08/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    private var indicator: EMTLoadingIndicator?
    @IBOutlet var image: WKInterfaceImage!
    var isShowing = true
    
    @IBAction func tappedNewToot() {
        let textChoices = ["Yes","No","Maybe","I love Mast"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.allowEmoji, completion: {(results) -> Void in
            if results != nil && results!.count > 0 {
                let aResult = results?[0] as? String
                print(aResult!)
                StoreStruct.tootText = aResult!
                self.presentController(withName: "TootController", context: nil)
            }
        })
    }
    
    @IBAction func tappedLocal() {
        StoreStruct.fromWhere = 2
        pushController(withName: "LocalTimelineController", context: nil)
    }
    
    @IBAction func tappedFederated() {
        StoreStruct.fromWhere = 3
        pushController(withName: "FedTimelineController", context: nil)
    }
    
    @IBAction func tappedProfile() {
        StoreStruct.fromWhere = 4
        pushController(withName: "ProfileController", context: nil)
    }
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    var client = Client(baseURL: "")
    
    var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("active: \(activationState)")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            print("herehere")
            print(userInfo.first?.key)
            if let xy = userInfo.first?.key {
                UserDefaults.standard.set(xy, forKey: "key1")
                if let xy2 = userInfo.first?.value {
                    UserDefaults.standard.set(xy2, forKey: "key2")
                    self.client = Client(
                        baseURL: "https://\(xy2 ?? "")",
                        accessToken: xy ?? ""
                    )
                    StoreStruct.client = self.client
                    
                    let request = Timelines.home()
                    self.client.run(request) { (statuses) in
                        if let stat = (statuses.value) {
                            self.indicator?.hide()
                            StoreStruct.allStats = stat
                            self.tableView.setNumberOfRows(StoreStruct.allStats.count, withRowType: "TimelineRow")
                            
                            for index in 0..<self.tableView.numberOfRows {
                                guard self.isShowing else { return }
                                let controller = self.tableView.rowController(at: index) as! TimelineRow
                                controller.userName.setText("@\(StoreStruct.allStats[index].reblog?.account.username ?? StoreStruct.allStats[index].account.username)")
                                controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                                controller.imageView.setImageNamed("icon")
                                controller.imageView.setWidth(20)
                                controller.tootText.setText("\(StoreStruct.allStats[index].reblog?.content.stripHTML() ?? StoreStruct.allStats[index].content.stripHTML())")
                                
                                //DispatchQueue.global().async { [weak self] in
                                    self.getDataFromUrl(url: URL(string: StoreStruct.allStats[index].reblog?.account.avatar ?? StoreStruct.allStats[index].account.avatar ?? "")!) { data, response, error in
                                        guard let data = data, error == nil else { return }
                                        //DispatchQueue.main.async() {
                                        if self.isShowing {
                                            controller.imageView.setImageData(data)
                                        }
                                        //}
                                    }
                                //}
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setTitle("Home")
        StoreStruct.fromWhere = 0
        
    }
        
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
            
        watchSession = WCSession.default
        
        
        self.indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: self.image,
                                             width: 40, height: 40, style: .line)
        self.indicator?.showWait()
        
        
        if UserDefaults.standard.value(forKey: "key1") != nil {
        
            
//            if StoreStruct.client.baseURL == "" {
        self.client = Client(
            baseURL: "https://\(UserDefaults.standard.object(forKey: "key2") ?? "")",
            accessToken: UserDefaults.standard.object(forKey: "key1") as? String ?? ""
        )
        StoreStruct.client = self.client
//            }
        
        let request = Timelines.home()
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStats = stat
                self.tableView.setNumberOfRows(StoreStruct.allStats.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStats[index].reblog?.account.username ?? StoreStruct.allStats[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStats[index].reblog?.content.stripHTML() ?? StoreStruct.allStats[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                        self.getDataFromUrl(url: URL(string: StoreStruct.allStats[index].reblog?.account.avatar ?? StoreStruct.allStats[index].account.avatar ?? "")!) { data, response, error in
                            guard let data = data, error == nil else { return }
                            //DispatchQueue.main.async() {
                            if self.isShowing {
                                controller.imageView.setImageData(data)
                            }
                            //}
                        }
                    //}
                    
                }
                
            }
        }
            
        } else {
            
            self.tableView.setNumberOfRows(1, withRowType: "TimelineRow")
            for index in 0..<self.tableView.numberOfRows {
                let controller = self.tableView.rowController(at: index) as! TimelineRow
                controller.userName.setText("Initial Launch")
                controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                controller.imageView.setWidth(0)
                controller.tootText.setText("Please open the Mast iOS app on your iPhone to get started.")
            }
            
        }
        
    }
    
    override func interfaceOffsetDidScrollToBottom() {
        
        print("scrolled to bottom")
        self.indicator?.showWait()
        let request = Timelines.home(range: .max(id: StoreStruct.allStats.last?.id ?? "", limit: nil))
        self.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStats = StoreStruct.allStats + stat
                self.tableView.setNumberOfRows(StoreStruct.allStats.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStats[index].reblog?.account.username ?? StoreStruct.allStats[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStats[index].reblog?.content.stripHTML() ?? StoreStruct.allStats[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                    self.getDataFromUrl(url: URL(string: StoreStruct.allStats[index].reblog?.account.avatar ?? StoreStruct.allStats[index].account.avatar ?? "")!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        //DispatchQueue.main.async() {
                        if self.isShowing {
                            controller.imageView.setImageData(data)
                        }
                        //}
                    }
                    //}
                    
                }
                
            }
        }
    }
    
    override func interfaceOffsetDidScrollToTop() {
        
        print("scrolled to top")
        
        let request = Timelines.home(range: .min(id: StoreStruct.allStats.first?.id ?? "", limit: nil))
        self.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStats = stat + StoreStruct.allStats
                self.tableView.setNumberOfRows(StoreStruct.allStats.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStats[index].reblog?.account.username ?? StoreStruct.allStats[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStats[index].reblog?.content.stripHTML() ?? StoreStruct.allStats[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                    self.getDataFromUrl(url: URL(string: StoreStruct.allStats[index].reblog?.account.avatar ?? StoreStruct.allStats[index].account.avatar ?? "")!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        //DispatchQueue.main.async() {
                        if self.isShowing {
                            controller.imageView.setImageData(data)
                        }
                        //}
                    }
                    //}
                    
                }
                
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        StoreStruct.currentRow = rowIndex
        StoreStruct.fromWhere = 0
        pushController(withName: "DetailController", context: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func willDisappear() {
        self.isShowing = false
    }

}

extension String {
    func stripHTML() -> String {
        //z = z.replacingOccurrences(of: "<p>", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        
        var z = self.replacingOccurrences(of: "</p><p>", with: "\n\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<br />", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<[^>]+>", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&apos;", with: "'", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.regularExpression, range: nil)
        return z
    }
}
