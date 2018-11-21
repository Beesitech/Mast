//
//  StoreStruct.swift
//  mastodon
//
//  Created by Shihab Mehboob on 09/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation

struct StoreStruct {
    static var currentRow: Int = 0
    static var fromWhere = 0
    static var allStats: [Status] = []
    static var allStatsLocal: [Status] = []
    static var allStatsFed: [Status] = []
    static var allStatsProfile: [Status] = []
    static var client = Client(baseURL: "")
    static var tootText = ""
    static var replyID = ""
    static var currentUser: Account!
}
