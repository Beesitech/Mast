//
//  DetailController.swift
//  MastWatch Extension
//
//  Created by Shihab Mehboob on 09/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import WatchKit
import Foundation

class DetailController: WKInterfaceController {
    
    @IBOutlet var tableView: WKInterfaceTable!
    @IBOutlet var replyB: WKInterfaceGroup!
    @IBOutlet var likeB: WKInterfaceButton!
    @IBOutlet var boostB: WKInterfaceButton!
    
    var allThings: [Status] = []
    var isShowing = true
    
    @IBAction func replyTap() {
        let textChoices = ["Yes","No","Maybe","I love Mast"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.allowEmoji, completion: {(results) -> Void in
            if results != nil && results!.count > 0 {
                let aResult = results?[0] as? String
                print(aResult!)
                StoreStruct.tootText = aResult!
                StoreStruct.replyID = self.allThings[StoreStruct.currentRow].reblog?.inReplyToID ?? self.allThings[StoreStruct.currentRow].inReplyToID ?? ""
                self.presentController(withName: "TootController", context: nil)
            }
        })
    }
    
    @IBAction func likeTap() {
        if self.allThings[StoreStruct.currentRow].reblog?.favourited ?? self.allThings[StoreStruct.currentRow].favourited ?? true {
            DispatchQueue.main.async {
                self.likeB.setBackgroundImageNamed("likeW")
            }
            let request = Statuses.unfavourite(id: self.allThings[StoreStruct.currentRow].reblog?.id ?? self.allThings[StoreStruct.currentRow].id)
            StoreStruct.client.run(request) { (statuses) in
                print("unliked")
            }
        } else {
            DispatchQueue.main.async {
                self.likeB.setBackgroundImageNamed("like")
            }
            let request = Statuses.favourite(id: self.allThings[StoreStruct.currentRow].reblog?.id ?? self.allThings[StoreStruct.currentRow].id)
            StoreStruct.client.run(request) { (statuses) in
                print("liked")
            }
        }
    }
    
    @IBAction func boostTap() {
        if self.allThings[StoreStruct.currentRow].reblog?.reblogged ?? self.allThings[StoreStruct.currentRow].reblogged ?? true {
            DispatchQueue.main.async {
                self.boostB.setBackgroundImageNamed("boostW")
            }
            let request = Statuses.unreblog(id: self.allThings[StoreStruct.currentRow].reblog?.id ?? self.allThings[StoreStruct.currentRow].id)
            StoreStruct.client.run(request) { (statuses) in
                print("unboosted")
            }
        } else {
            DispatchQueue.main.async {
                self.boostB.setBackgroundImageNamed("boost")
            }
            let request = Statuses.reblog(id: self.allThings[StoreStruct.currentRow].reblog?.id ?? self.allThings[StoreStruct.currentRow].id)
            StoreStruct.client.run(request) { (statuses) in
                print("boosted")
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setTitle("Detail")
        
        self.allThings = StoreStruct.allStats
        if StoreStruct.fromWhere == 2 {
            self.allThings = StoreStruct.allStatsLocal
        }
        if StoreStruct.fromWhere == 3 {
            self.allThings = StoreStruct.allStatsFed
        }
        if StoreStruct.fromWhere == 4 {
            self.allThings = StoreStruct.allStatsProfile
        }
        
        replyB.setBackgroundImageNamed("reply")
        likeB.setBackgroundImageNamed("likeW")
        boostB.setBackgroundImageNamed("boostW")
        if self.allThings[StoreStruct.currentRow].reblog?.favourited ?? self.allThings[StoreStruct.currentRow].favourited ?? true {
            likeB.setBackgroundImageNamed("like")
        }
        if self.allThings[StoreStruct.currentRow].reblog?.reblogged ?? self.allThings[StoreStruct.currentRow].reblogged ?? true {
            boostB.setBackgroundImageNamed("boost")
        }
        
        self.tableView.setNumberOfRows(1, withRowType: "DetailRow")
        let controller = self.tableView.rowController(at: 0) as! DetailRow
        
        controller.imageView.setImageNamed("icon")
        controller.imageView.setWidth(20)
        
        controller.userName.setText("@\(self.allThings[StoreStruct.currentRow].reblog?.account.username ?? self.allThings[StoreStruct.currentRow].account.username)")
        controller.userName.setTextColor(UIColor.white.withAlphaComponent(0.6))
        controller.screenName.setText("\(self.allThings[StoreStruct.currentRow].reblog?.account.displayName ?? self.allThings[StoreStruct.currentRow].account.displayName)")
        controller.screenName.setTextColor(UIColor.white.withAlphaComponent(0.6))
        
            self.getDataFromUrl(url: URL(string: self.allThings[StoreStruct.currentRow].reblog?.account.avatar ?? self.allThings[StoreStruct.currentRow].account.avatar)!) { data, response, error in
                guard let data = data, error == nil else { return }
                if self.isShowing {
                    controller.imageView.setImageData(data)
                }
            }
        
        controller.likesText.setText("\(self.allThings[StoreStruct.currentRow].reblog?.favouritesCount ?? self.allThings[StoreStruct.currentRow].favouritesCount) Likes")
        controller.likesText.setTextColor(UIColor.white.withAlphaComponent(0.6))
        
        controller.boostsText.setText("\(self.allThings[StoreStruct.currentRow].reblog?.reblogsCount ?? self.allThings[StoreStruct.currentRow].reblogsCount) Boosts")
        controller.boostsText.setTextColor(UIColor.white.withAlphaComponent(0.6))
        
    controller.timeText.setText(self.allThings[StoreStruct.currentRow].reblog?.createdAt.toString(dateStyle: .medium, timeStyle: .medium) ?? self.allThings[StoreStruct.currentRow].createdAt.toString(dateStyle: .medium, timeStyle: .medium))
        controller.timeText.setTextColor(UIColor.white.withAlphaComponent(0.6))
        
        controller.tootText.setText("\(self.allThings[StoreStruct.currentRow].reblog?.content.stripHTML() ?? self.allThings[StoreStruct.currentRow].content.stripHTML())")
        
        if self.allThings[StoreStruct.currentRow].reblog?.mediaAttachments.count ?? self.allThings[StoreStruct.currentRow].mediaAttachments.count > 0 {
        let xImage = self.allThings[StoreStruct.currentRow].reblog?.mediaAttachments[0].previewURL ?? self.allThings[StoreStruct.currentRow].mediaAttachments[0].previewURL
        if xImage != "" {
            self.getDataFromUrl(url: URL(string: xImage)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    controller.imageView2.setImageData(data)
                }
            }
        } else {
            controller.imageView2.setHeight(0)
        }
        } else {
            controller.imageView2.setHeight(0)
        }
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
