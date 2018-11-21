//
//  MainFeedCell.swift
//  MastExtension
//
//  Created by Shihab Mehboob on 04/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class MainFeedCell: UITableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var date = UILabel()
    var toot = UILabel()
    var moreImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = UIColor.white
        moreImage.backgroundColor = UIColor.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = UIColor.black
        date.textColor = UIColor.black.withAlphaComponent(0.6)
        toot.textColor = UIColor.black
        
        userName.font = UIFont.boldSystemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.systemFont(ofSize: 14)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        
        let viewsDict = [
            "image" : profileImageView,
            "name" : userName,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-(>=5)-[more(16)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Status) {
        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        toot.text = status.reblog?.content.stripHTML() ?? status.content.stripHTML()
        
        userName.font = UIFont.boldSystemFont(ofSize: 14)
        date.font = UIFont.systemFont(ofSize: 12)
        toot.font = UIFont.systemFont(ofSize: 14)
        
        
        let url3 = URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)")
        DispatchQueue.global().async {
            if "\(status.reblog?.account.avatar ?? status.account.avatar)" == "" {} else {
                let data = try? Data(contentsOf: url3!)
                DispatchQueue.main.async {
                    self.profileImageView.setImage(UIImage(data: data!), for: .normal)
                }
            }
        }
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 0.2
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        
        
        
    }
    
}



extension String {
    func stripHTML() -> String {
        //z = z.replacingOccurrences(of: "<p>", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        
        var z = self.replacingOccurrences(of: "</p><p>", with: "\n\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<br />", with: "\n", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "<[^>]+>", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&apos;", with: "'", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&quot;", with: "\"", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&amp;", with: "&", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&lt;", with: "<", options: NSString.CompareOptions.regularExpression, range: nil)
        z = z.replacingOccurrences(of: "&gt;", with: ">", options: NSString.CompareOptions.regularExpression, range: nil)
        return z
    }
}
