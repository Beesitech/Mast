//
//  ProfileHeaderCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 21/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ProfileHeaderCellImage: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKPhotoBrowserDelegate {
    
    var collectionView: UICollectionView!
    var profileStatuses: [Status] = []
    var profileStatusesHasImage: [Status] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = ColumnFlowLayout(
            cellsPerRow: 4,
            minimumInteritemSpacing: 15,
            minimumLineSpacing: 15,
            sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        )
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(-10), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(208)), collectionViewLayout: layout)
        collectionView.backgroundColor = Colours.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionProfileCell.self, forCellWithReuseIdentifier: "CollectionProfileCell")
        
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: [Status], status2: [Status]) {
        self.profileStatuses = status
        self.profileStatusesHasImage = status2
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profileStatusesHasImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionProfileCell", for: indexPath) as! CollectionProfileCell
        
        if self.profileStatusesHasImage.isEmpty {} else {
            cell.configure()
            if self.profileStatusesHasImage[indexPath.item].mediaAttachments.isEmpty {} else {
            let z = self.profileStatusesHasImage[indexPath.item].mediaAttachments[0].previewURL
            let secureImageUrl = URL(string: z)!
            cell.image.contentMode = .scaleAspectFill
            cell.image.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            cell.image.pin_updateWithProgress = true
            cell.image.pin_setImage(from: secureImageUrl)
            //cell.layer.cornerRadius = 10
            cell.image.backgroundColor = Colours.white
            
                if (UserDefaults.standard.object(forKey: "imCorner") == nil || UserDefaults.standard.object(forKey: "imCorner") as! Int == 0) {
                    cell.image.layer.cornerRadius = 10
                }
                if (UserDefaults.standard.object(forKey: "imCorner") != nil && UserDefaults.standard.object(forKey: "imCorner") as! Int == 1) {
                    cell.image.layer.cornerRadius = 0
                }
            cell.image.layer.masksToBounds = true
            cell.image.layer.borderColor = UIColor.black.cgColor
            //cell.image.layer.borderWidth = 0.2
            
            cell.image.frame.size.width = 190
            cell.image.frame.size.height = 150
               
                
                cell.bgImage.layer.masksToBounds = false
                cell.bgImage.layer.shadowColor = UIColor.black.cgColor
                cell.bgImage.layer.shadowOffset = CGSize(width:0, height:8)
                cell.bgImage.layer.shadowRadius = 12
                cell.bgImage.layer.shadowOpacity = 0.22
            }
        }
        
        cell.backgroundColor = Colours.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        }
        
        var sto = self.profileStatusesHasImage
        
        
        if sto[indexPath.item].mediaAttachments[0].type == .video || sto[indexPath.item].mediaAttachments[0].type == .gifv {
            
            let videoURL = URL(string: sto[indexPath.item].mediaAttachments[0].url)!
            XPlayer.play(videoURL)
            
        } else {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionProfileCell
        var images = [SKPhoto]()
        for y in sto[indexPath.row].mediaAttachments {
            let photo = SKPhoto.photoWithImageURL(y.url, holder: cell.image.image)
            photo.shouldCachePhotoURLImage = true
            photo.caption = sto[indexPath.row].content.stripHTML()
            images.append(photo)
        }
        let originImage = cell.image.image
        if originImage != nil {
            let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell.image)
            browser.displayToolbar = true
            browser.displayAction = true
            browser.delegate = self
            browser.initializePageIndex(0)
            
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindow.Level.alert + 1
            win.makeKeyAndVisible()
            vc.present(browser, animated: true, completion: nil)
        }
        
        }
    }
    
}


