//
//  Hash.swift
//  mastodon
//
//  Created by Shihab Mehboob on 14/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation

public class HashType: Codable {
    
    public let name: String
    public let value: String
    public let verifiedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case value
        case verifiedAt = "verified_at"
    }
}
