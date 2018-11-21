//
//  ShareViewController.swift
//  MastShare
//
//  Created by Shihab Mehboob on 02/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        
        var client = Client(baseURL: "")
        if let userDefaults = UserDefaults(suiteName: "group.com.shi.Mast.wormhole") {
            let value1 = userDefaults.string(forKey: "key1")
            let value2 = userDefaults.string(forKey: "key2")
            client = Client(
                baseURL: "https://\(value2 ?? "")",
                accessToken: value1 ?? ""
            )
        }
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            print("01")
            if let itemProvider = item.attachments?.first as? NSItemProvider {
                print("02")
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    print("03")
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        print("04")
                        if let shareURL = url as? NSURL {
                            print("05")
                            let request0 = Statuses.create(status: "\(self.contentText!)\n\n\(shareURL)", replyToID: nil, mediaIDs: [], sensitive: false, spoilerText: nil, visibility: .public)
                                client.run(request0) { (statuses) in
                                    print("06")
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                }
                        }
                        
                    })
                } else {
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: { (url, error) -> Void in
                        if let data = url as? URL {
                            
                            var imageData = Data()
                            do {
                                imageData = try Data(contentsOf: data)
                            }
                            catch let error {
                                print(error)
                            }
                            
                            
                            
                            
                            let request = Media.upload(media: .jpeg(imageData))
                            client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    print(stat.id)
                                    var mediaIDs: [String] = []
                                    mediaIDs.append(stat.id)
                                    
                                    let request0 = Statuses.create(status: self.contentText!, replyToID: nil, mediaIDs: mediaIDs, sensitive: false, spoilerText: nil, visibility: .public)
                                    DispatchQueue.global(qos: .background).async {
                                        client.run(request0) { (statuses) in
                                            print("posted")
                                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            
                        }
                    })
                    
                }
            }
        }
        
        
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
