//
//  TootController.swift
//  MastWatch Extension
//
//  Created by Shihab Mehboob on 09/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import WatchKit
import Foundation

class TootController: WKInterfaceController {

    @IBOutlet var textL: WKInterfaceLabel!
    @IBOutlet var tootB: WKInterfaceButton!
    @IBOutlet var cancelB: WKInterfaceButton!
    
    @IBAction func tappedToot() {
        let request0 = Statuses.create(status: StoreStruct.tootText, replyToID: StoreStruct.replyID, mediaIDs: [], sensitive: false, spoilerText: nil, visibility: .public)
        StoreStruct.client.run(request0) { (statuses) in
            print(statuses)
            StoreStruct.replyID = ""
        }
        self.dismiss()
    }
    
    @IBAction func tappedCancel() {
        StoreStruct.replyID = ""
        self.dismiss()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setTitle("Review Toot")
        
        self.textL.setText(StoreStruct.tootText)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
