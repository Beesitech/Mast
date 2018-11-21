//
//  StoreStruct.swift
//  mastodon
//
//  Created by Shihab Mehboob on 19/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

struct StoreStruct {
    static var colArray = [UIColor(red: 107/255.0, green: 122/255.0, blue: 214/255.0, alpha: 1.0),
                           UIColor(red: 79/255.0, green: 121/255.0, blue: 251/255.0, alpha: 1.0),
                           UIColor(red: 83/255.0, green: 153/255.0, blue: 244/255.0, alpha: 1.0),
                           UIColor(red: 149/255.0, green: 192/255.0, blue: 248/255.0, alpha: 1.0),
                           UIColor(red: 152/255.0, green: 228/255.0, blue: 220/255.0, alpha: 1.0),
                           UIColor(red: 122/255.0, green: 236/255.0, blue: 238/255.0, alpha: 1.0),
                           UIColor(red: 115/255.0, green: 191/255.0, blue: 105/255.0, alpha: 1.0),
                           UIColor(red: 159/255.0, green: 224/255.0, blue: 151/255.0, alpha: 1.0),
                           UIColor(red: 238/255.0, green: 235/255.0, blue: 162/255.0, alpha: 1.0),
                           UIColor(red: 240/255.0, green: 252/255.0, blue: 83/255.0, alpha: 1.0),
                           UIColor(red: 248/255.0, green: 173/255.0, blue: 59/255.0, alpha: 1.0),
                           UIColor(red: 244/255.0, green: 135/255.0, blue: 83/255.0, alpha: 1.0),
                           UIColor(red: 253/255.0, green: 109/255.0, blue: 109/255.0, alpha: 1.0),
                           UIColor(red: 253/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1.0),
                           UIColor(red: 243/255.0, green: 137/255.0, blue: 201/255.0, alpha: 1.0),
                           UIColor(red: 250/255.0, green: 69/255.0, blue: 178/255.0, alpha: 1.0),
                           UIColor(red: 216/255.0, green: 166/255.0, blue: 102/255.0, alpha: 1.0),
                           UIColor(red: 168/255.0, green: 111/255.0, blue: 13/255.0, alpha: 1.0),
                           UIColor(red: 100/255.0, green: 100/255.0, blue: 110/255.0, alpha: 1.0),
                           UIColor(red: 58/255.0, green: 58/255.0, blue: 65/255.0, alpha: 1.0)]
    
    static var client = Client(baseURL: "")
    static var redirect: String?
    static var returnedText = ""
    static var clientID = ""
    static var clientSecret = ""
    static var authCode = ""
    static var accessToken = ""
    
    static var currentPage = 0
    static var playerID = ""
    
    static var caption1: String = ""
    static var caption2: String = ""
    static var caption3: String = ""
    static var caption4: String = ""
    
    static var emotiSize = 16
    static var emotiFace: [Emoji] = []
    static var mainResult: [NSAttributedString] = []
    static var instanceLocalToAdd: [String] = []
    
    static var statusesHome: [Status] = []
    static var statusesLocal: [Status] = []
    static var statusesFederated: [Status] = []
    
    static var notifications: [Notificationt] = []
    static var notificationsMentions: [Notificationt] = []
    
    static var fromOtherUser = false
    static var userIDtoUse = ""
    static var profileStatuses: [Status] = []
    static var profileStatusesHasImage: [Status] = []
    
    static var statusSearch: [Status] = []
    static var statusSearchUser: [Account] = []
    static var searchIndex: Int = 0
    
    static var tempLiked: [Status] = []
    static var tempPinned: [Status] = []
    
    static var tappedTag = ""
    static var currentUser: Account!
    static var newInstanceTags: [Status] = []
    static var instanceText = ""
    
    static var allLists: [List] = []
    static var allListRelID: String = ""
    static var currentList: [Status] = []
    static var currentListTitle: String = ""
    static var drafts: [String] = []
    
    static var allLikes: [String] = []
    static var allBoosts: [String] = []
    static var allPins: [String] = []
    static var photoNew = UIImage()
}
