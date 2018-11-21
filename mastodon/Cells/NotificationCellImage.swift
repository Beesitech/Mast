//
//  NotificationCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class NotificationCellImage: SwipeTableViewCell {
    
    var profileImageView = UIButton()
    var typeImage = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var moreImage = UIImageView()
    var imageCountTag = UIButton()
    var warningB = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        typeImage.backgroundColor = Colours.white
        moreImage.backgroundColor = Colours.clear
        warningB.backgroundColor = Colours.clear
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
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
        
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }
        mainImageView.layer.masksToBounds = true
        mainImageView.backgroundColor = Colours.white
        mainImageViewBG.layer.cornerRadius = 10
        mainImageViewBG.backgroundColor = Colours.white
        mainImageViewBG.layer.shadowColor = UIColor.black.cgColor
        mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 7)
        mainImageViewBG.layer.shadowRadius = 10
        mainImageViewBG.layer.shadowOpacity = 0.22
        mainImageViewBG.layer.masksToBounds = false
        
        
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
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(moreImage)
        contentView.addSubview(warningB)
        
        imageCountTag.backgroundColor = Colours.clear
        imageCountTag.translatesAutoresizingMaskIntoConstraints = false
        imageCountTag.layer.cornerRadius = 7
        imageCountTag.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        imageCountTag.layer.shadowColor = UIColor.black.cgColor
        imageCountTag.layer.shadowOffset = CGSize(width: 0, height: 7)
        imageCountTag.layer.shadowRadius = 10
        imageCountTag.layer.shadowOpacity = 0.22
        imageCountTag.layer.masksToBounds = false
        mainImageView.addSubview(imageCountTag)
        
        let viewsDict = [
            "image" : profileImageView,
            "type" : typeImage,
            "mainImage" : mainImageView,
            "mainImageBG" : mainImageViewBG,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "more" : moreImage,
            "countTag" : imageCountTag,
            "warning" : warningB,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[artist]-(>=5)-[more(16)]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[type(40)]-4-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-107-[mainImage]-20-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-121-[mainImageBG]-30-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-2-[more(16)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[type(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImage(160)]-23-|", options: [], metrics: nil, views: viewsDict))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-5-[episodes]-10-[mainImageBG(160)]-23-|", options: [], metrics: nil, views: viewsDict))
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-105-[warning]-17-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[warning]-9-|", options: [], metrics: nil, views: viewsDict))
    }
    
    @objc func touchMore(button: UIButton) {
        print("touched more")
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "more"), object: nil)
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
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
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
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
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
            //toot.textColor = Colours.black.withAlphaComponent(0.3)
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
        
        
//        toot.text = status.status?.content.stripHTML() ?? ""
        
        
        
        
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
        
        mainImageView.imageView?.contentMode = .scaleAspectFill
        self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
        mainImageView.pin_updateWithProgress = true
        mainImageView.pin_setImage(from: URL(string: "\(status.status?.mediaAttachments[0].previewURL ?? "")"))
        mainImageView.layer.masksToBounds = true
        mainImageView.layer.borderColor = UIColor.black.cgColor
        if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
            mainImageView.layer.cornerRadius = 10
        }
        if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
            mainImageView.layer.cornerRadius = 0
        }
        //mainImageView.layer.borderWidth = 0.2
        
        if (status.status?.favourited ?? false) && (status.status?.reblogged ?? false) {
            self.moreImage.image = UIImage(named: "fifty")
        } else if status.status?.reblogged ?? false {
            self.moreImage.image = UIImage(named: "boost")
        } else if (status.status?.favourited ?? false) || StoreStruct.allLikes.contains(status.id) {
            self.moreImage.image = UIImage(named: "like")
        } else {
            self.moreImage.image = nil
        }
        
        
        
        imageCountTag.isUserInteractionEnabled = false
        if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .video {
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments[0].type ?? status.status?.mediaAttachments[0].type == .gifv {
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0 > 1 {
            let z = status.status?.reblog?.mediaAttachments.count ?? status.status?.mediaAttachments.count ?? 0
            imageCountTag.setTitle("\(z)", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
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

