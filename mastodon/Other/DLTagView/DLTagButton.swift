//
//  DLTagButton.swift
//  DLTagView
//
//  Created by 刘铎 on 15/11/23.
//  Copyright © 2015年 liuduoios. All rights reserved.
//

import UIKit

public class DLTagButton: UIButton {
    
    public var tagInfo: TagInfo!
    
    class func buttonWithTagInfo(tagInfo: TagInfo) -> DLTagButton {
        let button = DLTagButton(type: .custom)
        button.tagInfo = tagInfo
        button.configure()
        return button
    }
    
    private func configure() {
        if let attributedText = tagInfo.attributedText {
            setAttributedTitle(attributedText, for: [])
        } else {
            setTitle(tagInfo.text, for: [])
            setTitleColor(tagInfo.textColor, for: [])
            titleLabel?.font = UIFont.systemFont(ofSize: tagInfo.fontSize)
        }
        
        contentEdgeInsets = tagInfo.padding
        
        setBackgroundImage(imageWithColor(color: tagInfo.backgroundColor), for: [])
        
        layer.cornerRadius = tagInfo.cornerRadius
        layer.masksToBounds = true
        
        layer.borderWidth = tagInfo.borderWidth
        layer.borderColor = tagInfo.borderColor.cgColor
        
        isEnabled = tagInfo.enabled
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }
    
}
