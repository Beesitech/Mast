//
//  NotificationCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class NotificationCell: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var typeImage = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var moreImage = UIImageView()
    var warningB = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        typeImage.backgroundColor = Colours.white
        moreImage.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        moreImage.translatesAutoresizingMaskIntoConstraints = false
        warningB.translatesAutoresizingMaskIntoConstraints = false
        
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
        typeImage.layer.cornerRadius = 0
        typeImage.layer.masksToBounds = true
        
        
        warningB.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        warningB.titleLabel?.textAlignment = .center
        warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
        warningB.layer.cornerRadius = 7
        warningB.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        warningB.titleLabel?.numberOfLines = 0
        warningB.layer.masksToBounds = true
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.black.withAlphaComponent(0.6)
        date.textColor = Colours.black.withAlphaComponent(0.6)
        toot.textColor = Colours.black
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        contentView.addSubview(typeImage)
        contentView.addSubview(profileImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(warningB)
        
        let viewsDict = [
            "image" : profileImageView,
            "type" : typeImage,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "warning" : warningB,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[artist]-(>=5)-[more(16)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-12-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-105-[warning]-17-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Notificationt) {
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        
        
        if status.type == .favourite {
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) liked"
            typeImage.setImage(UIImage(named: "like3"), for: .normal)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.textColor = Colours.black.withAlphaComponent(0.6)
                date.textColor = Colours.black.withAlphaComponent(0.6)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.textColor = Colours.black.withAlphaComponent(0.3)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        if status.type == .reblog {
            profileImageView.isUserInteractionEnabled = true
            userName.text = "\(status.account.displayName) boosted"
            typeImage.setImage(UIImage(named: "boost3"), for: .normal)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.textColor = Colours.black.withAlphaComponent(0.6)
                date.textColor = Colours.black.withAlphaComponent(0.6)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.textColor = Colours.black.withAlphaComponent(0.3)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        if status.type == .mention {
            profileImageView.isUserInteractionEnabled = true
            toot.textColor = Colours.black
            userName.textColor = Colours.black
            userTag.textColor = Colours.black.withAlphaComponent(0.6)
            date.textColor = Colours.black.withAlphaComponent(0.6)
            userName.text = "\(status.account.displayName) mentioned you"
            if status.status?.visibility == .direct {
                typeImage.setImage(UIImage(named: "direct")?.maskWithColor(color: Colours.purple), for: .normal)
            } else if status.status?.visibility == .unlisted {
                typeImage.setImage(UIImage(named: "rep4"), for: .normal)
            } else if status.status?.visibility == .private {
                typeImage.setImage(UIImage(named: "rep5"), for: .normal)
            } else {
                typeImage.setImage(UIImage(named: "reply3"), for: .normal)
            }
        }
        if status.type == .follow {
            profileImageView.isUserInteractionEnabled = false
            userName.text = "\(status.account.displayName) followed you"
            typeImage.setImage(UIImage(named: "follow3"), for: .normal)
            if (UserDefaults.standard.object(forKey: "subtleToggle") == nil) || (UserDefaults.standard.object(forKey: "subtleToggle") as! Int == 0) {
                toot.textColor = Colours.black
                userName.textColor = Colours.black
                userTag.textColor = Colours.black.withAlphaComponent(0.6)
                date.textColor = Colours.black.withAlphaComponent(0.6)
            } else {
                toot.textColor = Colours.black.withAlphaComponent(0.3)
                userName.textColor = Colours.black.withAlphaComponent(0.3)
                userTag.textColor = Colours.black.withAlphaComponent(0.3)
                date.textColor = Colours.black.withAlphaComponent(0.3)
            }
        }
        typeImage.layer.masksToBounds = true
        
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.text = "@\(status.account.acct)"
        } else {
            userTag.text = "@\(status.account.username)"
        }
        
        if (UserDefaults.standard.object(forKey: "timerel") == nil) || (UserDefaults.standard.object(forKey: "timerel") as! Int == 0) {
            date.text = status.createdAt.toStringWithRelativeTime()
        } else {
            date.text = status.createdAt.toString(dateStyle: .short, timeStyle: .short)
        }
        
//        toot.text = status.status?.content.stripHTML() ?? status.account.note.stripHTML()
        
        
        
        
        
        if status.status?.emojis.isEmpty ?? true {
            toot.text = status.status?.content.stripHTML() ?? status.account.note.stripHTML()
        } else {
            let attributedString = NSMutableAttributedString(string: status.status?.content.stripHTML() ?? status.account.note.stripHTML())
            for y in (status.status?.emojis)! {
                let textAttachment = NSTextAttachment()
                textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                while attributedString.mutableString.contains(":\(y.shortcode):") {
                    let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                    attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                }
            }
            self.toot.attributedText = attributedString
        }
        
        
        
        
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        
        profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        profileImageView.pin_updateWithProgress = true
        profileImageView.pin_setImage(from: URL(string: "\(status.account.avatar)"))
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
        
        if (status.status?.favourited ?? false) && (status.status?.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")
        } else if status.status?.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost")
        } else if (status.status?.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like")
        } else {
            self.moreImage.image = nil
        }
        
        
        
        
        if (UserDefaults.standard.object(forKey: "senseTog") == nil) || (UserDefaults.standard.object(forKey: "senseTog") as! Int == 0) {
            
            if status.status?.reblog?.sensitive ?? false || status.status?.sensitive ?? false {
                warningB.backgroundColor = Colours.tabUnselected
                let z = status.status?.reblog?.spoilerText ?? status.status?.spoilerText ?? ""
                var zz = "Content Warning"
                if z == "" {} else {
                    zz = z
                }
                warningB.setTitle("\(zz)\n\nTap to show toot", for: .normal)
                warningB.setTitleColor(Colours.black.withAlphaComponent(0.4), for: .normal)
                warningB.addTarget(self, action: #selector(self.didTouchWarning), for: .touchUpInside)
                warningB.alpha = 1
            } else {
                warningB.backgroundColor = Colours.clear
                warningB.alpha = 0
            }
            
        } else {
            warningB.backgroundColor = Colours.clear
            warningB.alpha = 0
        }
        
        
        
    }
    
    @objc func didTouchWarning() {
        warningB.backgroundColor = Colours.clear
        warningB.alpha = 0
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
    }
}
