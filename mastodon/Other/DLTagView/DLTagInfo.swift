//
//  DLTag.swift
//  DLTagView
//
//  Created by 刘铎 on 15/11/23.
//  Copyright © 2015年 liuduoios. All rights reserved.
//

import UIKit

public protocol TagInfo {
    
    var altText: String? { get set }
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    var textColor: UIColor { get set }
    var backgroundColor: UIColor { get set }
    var cornerRadius: CGFloat { get set }
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var fontSize: CGFloat { get set }
    var padding: UIEdgeInsets { get set }
    var enabled: Bool { get set }
    
}

public struct DLTag: TagInfo {
    
    public var altText: String?
    public var text: String?
    public var attributedText: NSAttributedString?
    public var textColor = UIColor.black
    public var backgroundColor = UIColor.white
    public var cornerRadius = 0 as CGFloat
    public var borderColor = UIColor.black
    public var borderWidth = 1 as CGFloat
    public var fontSize = 17 as CGFloat
    public var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var enabled = true
    
    public init(text: String) {
        self.text = text
    }
    
}
