//
//  DLTagView.swift
//  DLTagView
//
//  Created by 刘铎 on 15/11/23.
//  Copyright © 2015年 liuduoios. All rights reserved.
//

import UIKit

@IBDesignable
public class DLTagView: UIScrollView {
    
    // ------------------
    // MARK: - Properties
    // ------------------
    
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    public var lineSpace = 12 as CGFloat
    public var insets = 12 as CGFloat
    public var preferredMaxLayoutWidth = 20 as CGFloat
    public var singleLine = false
    public var didTapTag: ((TagInfo) -> Void)?
    
    private lazy var tags = [TagInfo]()
    private lazy var tagButtons = [DLTagButton]()
    private var didSetup = false
    
    // --------------
    // MARK: - Layout
    // --------------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
//        self.showsVerticalScrollIndicator = false
        self.bounces = true
        self.alwaysBounceHorizontal = true
        rearrangeButtons()
    }
    
    // --------------
    // MARK: - Public
    // --------------
    
    public func addTag(tag: TagInfo) {
        let button = createTagButtonWithTag(tag: tag)
        addSubview(button)
        tagButtons.append(button)
        tags.append(tag)
        rearrangeButtons()
    }
    
    public func insertTag(tag: TagInfo, atIndex index: Int) {
        if index + 1 > tags.count {
            addTag(tag: tag)
        } else {
            let button = createTagButtonWithTag(tag: tag)
            insertSubview(button, at: index)
            tagButtons.insert(button, at: index)
            tags.insert(tag, at: index)
            rearrangeButtons()
        }
    }
    
    public func removeTag(tag: TagInfo) {
        //        let index = tags.indexOf { (theTag) -> Bool in
        //            if theTag === tag {
        //                return true
        //            } else {
        //                return false
        //            }
        //        }
    }
    
    public func remoteTagAtIndex(index: UInt) {
        
    }
    
    public func removeAllTags() {
        tags.removeAll()
        tagButtons.forEach { tagButton in
            tagButton.removeFromSuperview()
        }
        tagButtons.removeAll()
        rearrangeButtons()
    }
    
    // -------------------------
    // MARK: - Private - Buttons
    // -------------------------
    
    private func createTagButtonWithTag(tag: TagInfo) -> DLTagButton {
        let button = DLTagButton.buttonWithTagInfo(tagInfo: tag)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(button: DLTagButton) {
        didTapTag?(button.tagInfo)
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        StoreStruct.tappedTag = button.tagInfo.altText ?? ""
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tappedOnTag"), object: nil)
    }
    
    private func rearrangeButtons() {
        var currentX = padding.left
        var currentY = padding.top
        
        var previousView: UIView? = nil
        
        var addedWidth: CGFloat = 0
        var addedHeight: CGFloat = 0
        
        for (index, view) in tagButtons.enumerated() {
            let size = view.intrinsicContentSize
            if let previousView = previousView {
                currentX += previousView.intrinsicContentSize.width + insets
                
//                if currentX + size.width + padding.right > self.frame.width {
//                    currentX = padding.left
//                    currentY += size.height + lineSpace
//                }
                
                view.frame = CGRect(x: currentX, y: currentY, width: size.width, height: size.height)
            } else {
                // 第一个view
                view.frame = CGRect(x: currentX, y: currentY, width: size.width, height: size.height)
            }
            
            if let previousView = previousView {
                addedWidth += previousView.intrinsicContentSize.width + insets
                addedHeight = size.height
            }
            
            previousView = view
            
            if index == subviews.endIndex - 1 {
                self.contentSize = CGSize(width: self.frame.maxY, height: self.frame.maxY + padding.bottom)
            }
        }
        
        
        if let previousView = previousView {
            addedWidth += previousView.intrinsicContentSize.width + insets + 30
            self.contentSize = CGSize(width: addedWidth, height: addedHeight)
        }
    }
    
}
