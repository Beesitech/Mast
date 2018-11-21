//
//  ListCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 23/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ListCell: SwipeTableViewCell {
    
    var userName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.numberOfLines = 0
        userName.textColor = UIColor.white
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentView.addSubview(userName)
        
        let viewsDict = [
            "name" : userName,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[name]-16-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: List) {
        userName.text = status.title
        
    }
    
}



class ListCell2: SwipeTableViewCell {
    
    var userName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.numberOfLines = 0
        userName.textColor = UIColor.white
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentView.addSubview(userName)
        
        let viewsDict = [
            "name" : userName,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[name]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[name]-16-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: String) {
        userName.text = status
    }
    
}

