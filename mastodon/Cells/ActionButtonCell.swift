//
//  ActionButtonCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ActionButtonCell: UITableViewCell {
    
    let containerView = UIView(frame: CGRect.zero)
    var replyButton = UIButton()
    var likeButton = UIButton()
    var boostButton = UIButton()
    var moreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        replyButton.backgroundColor = Colours.white
        likeButton.backgroundColor = Colours.white
        boostButton.backgroundColor = Colours.white
        moreButton.backgroundColor = Colours.white
        
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        boostButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.layer.cornerRadius = 20
        replyButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = 20
        likeButton.layer.masksToBounds = true
        boostButton.layer.cornerRadius = 20
        boostButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 20
        moreButton.layer.masksToBounds = true
        
        containerView.addSubview(replyButton)
        containerView.addSubview(likeButton)
        containerView.addSubview(boostButton)
        containerView.addSubview(moreButton)
        
        let horizontalSpacing = 25
        let cornerMargin = 30
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "boost" : boostButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": horizontalSpacing,
            "cornerMargin": cornerMargin
            ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        let horizontalFormat = "H:|-(==cornerMargin)-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[boost(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(horizontalConstraints)
        
        let verticalFormat = "V:|-20-[reply(40)]-20-|"
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints)
        
        let verticalFormat2 = "V:|-20-[like(40)]-20-|"
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints2)
        
        let verticalFormat3 = "V:|-20-[boost(40)]-20-|"
        let verticalConstraints3 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat3, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints3)
        
        let verticalFormat4 = "V:|-20-[more(40)]-20-|"
        let verticalConstraints4 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints4)
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        let verticalConstraints5 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        replyButton.setImage(UIImage(named: "reply"), for: .normal)
        likeButton.setImage(UIImage(named: "like"), for: .normal)
        boostButton.setImage(UIImage(named: "boost"), for: .normal)
        moreButton.setImage(UIImage(named: "more2"), for: .normal)
    }
    
}


class ActionButtonCell2: UITableViewCell {
    
    let containerView = UIView(frame: CGRect.zero)
    var replyButton = UIButton()
    var likeButton = UIButton()
    var moreButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        replyButton.backgroundColor = Colours.white
        likeButton.backgroundColor = Colours.white
        moreButton.backgroundColor = Colours.white
        
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        replyButton.layer.cornerRadius = 20
        replyButton.layer.masksToBounds = true
        likeButton.layer.cornerRadius = 20
        likeButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = 20
        moreButton.layer.masksToBounds = true
        
        containerView.addSubview(replyButton)
        containerView.addSubview(likeButton)
        containerView.addSubview(moreButton)
        
        let horizontalSpacing = 25
        let cornerMargin = 30
        
        let viewsDict = [
            "container" : containerView,
            "reply" : replyButton,
            "like" : likeButton,
            "more" : moreButton,
            ]
        
        let metrics = [
            "horizontalSpacing": horizontalSpacing,
            "cornerMargin": cornerMargin
        ]
        
        let verticalCenter = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        let horizontalCenter = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(verticalCenter)
        contentView.addConstraint(horizontalCenter)
        
        
        let horizontalFormat = "H:|-(==cornerMargin)-[reply(40)]-horizontalSpacing-[like(40)]-horizontalSpacing-[more(40)]-(==cornerMargin)-|"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(horizontalConstraints)
        
        let verticalFormat = "V:|-20-[reply(40)]-20-|"
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints)
        
        let verticalFormat2 = "V:|-20-[like(40)]-20-|"
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat2, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints2)
        
        let verticalFormat4 = "V:|-20-[more(40)]-20-|"
        let verticalConstraints4 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat4, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints4)
        
        let verticalFormat5 = "V:|-0-[container]-0-|"
        let verticalConstraints5 = NSLayoutConstraint.constraints(withVisualFormat: verticalFormat5, options: .alignAllCenterY, metrics: metrics, views: viewsDict)
        contentView.addConstraints(verticalConstraints5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        replyButton.setImage(UIImage(named: "direct2"), for: .normal)
        likeButton.setImage(UIImage(named: "like"), for: .normal)
        moreButton.setImage(UIImage(named: "more2"), for: .normal)
    }
    
}
