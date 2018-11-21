//
//  LocalTimelineController.swift
//  MastWatch Extension
//
//  Created by Shihab Mehboob on 09/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import WatchKit
import Foundation

class LocalTimelineController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    
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
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setTitle("Local")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: self.image,
                                             width: 40, height: 40, style: .line)
        self.indicator?.showWait()
        
        let request = Timelines.public(local: true, range: .min(id: "", limit: nil))
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStatsLocal = stat
                self.tableView.setNumberOfRows(StoreStruct.allStatsLocal.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStatsLocal[index].reblog?.account.username ?? StoreStruct.allStatsLocal[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStatsLocal[index].reblog?.content.stripHTML() ?? StoreStruct.allStatsLocal[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                        self.getDataFromUrl(url: URL(string: StoreStruct.allStatsLocal[index].reblog?.account.avatar ?? StoreStruct.allStatsLocal[index].account.avatar ?? "")!) { data, response, error in
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
        
        let request = Timelines.public(local: true, range: .min(id: StoreStruct.allStatsLocal.first?.id ?? "", limit: nil))
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStatsLocal = stat + StoreStruct.allStatsLocal
                self.tableView.setNumberOfRows(StoreStruct.allStatsLocal.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStatsLocal[index].reblog?.account.username ?? StoreStruct.allStatsLocal[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStatsLocal[index].reblog?.content.stripHTML() ?? StoreStruct.allStatsLocal[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                    self.getDataFromUrl(url: URL(string: StoreStruct.allStatsLocal[index].reblog?.account.avatar ?? StoreStruct.allStatsLocal[index].account.avatar ?? "")!) { data, response, error in
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
    
    
    override func interfaceOffsetDidScrollToBottom() {
        self.indicator?.showWait()
        let request = Timelines.public(local: true, range: .max(id: StoreStruct.allStatsLocal.last?.id ?? "", limit: nil))
        StoreStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                self.indicator?.hide()
                StoreStruct.allStatsLocal = StoreStruct.allStatsLocal + stat
                self.tableView.setNumberOfRows(StoreStruct.allStatsLocal.count, withRowType: "TimelineRow")
                
                for index in 0..<self.tableView.numberOfRows {
                    guard self.isShowing else { return }
                    let controller = self.tableView.rowController(at: index) as! TimelineRow
                    controller.userName.setText("@\(StoreStruct.allStatsLocal[index].reblog?.account.username ?? StoreStruct.allStatsLocal[index].account.username)")
                    controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
                    controller.imageView.setImageNamed("icon")
                    controller.imageView.setWidth(20)
                    controller.tootText.setText("\(StoreStruct.allStatsLocal[index].reblog?.content.stripHTML() ?? StoreStruct.allStatsLocal[index].content.stripHTML())")
                    
                    //DispatchQueue.global().async { [weak self] in
                    self.getDataFromUrl(url: URL(string: StoreStruct.allStatsLocal[index].reblog?.account.avatar ?? StoreStruct.allStatsLocal[index].account.avatar ?? "")!) { data, response, error in
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
        StoreStruct.fromWhere = 2
        pushController(withName: "DetailController", context: nil)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func willDisappear() {
        self.isShowing = false
    }
}
