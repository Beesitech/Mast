//
//  AppIconsCells.swift
//  mastodon
//
//  Created by Shihab Mehboob on 28/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class AppIconsCells: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKPhotoBrowserDelegate {
    
    var collectionView: UICollectionView!
    var profileStatuses: [Status] = []
    var profileStatusesHasImage: [Status] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = ColumnFlowLayout(
            cellsPerRow: 10,
            minimumInteritemSpacing: 16,
            minimumLineSpacing: 16,
            sectionInset: UIEdgeInsets(top: -10, left: 20, bottom: 0, right: 20)
        )
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(540), height: CGFloat(130)), collectionViewLayout: layout)
        } else {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(130)), collectionViewLayout: layout)
        }
        collectionView.backgroundColor = Colours.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionAppCell.self, forCellWithReuseIdentifier: "CollectionAppCell")
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            contentView.addSubview(collectionView)
        case .pad:
            print("nothing")
        default:
            contentView.addSubview(collectionView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var appArrayIcons = ["icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8", "icon9", "icon10", "icon11", "icon12", "icon13", "icon14", "icon15", "icon16", "icon17", "icon18", "icon19", "icon20"]
    var appArrayIconsIPAD = ["icon1~ipad", "icon2~ipad", "icon3~ipad", "icon4~ipad", "icon5~ipad", "icon6~ipad", "icon7~ipad", "icon8~ipad", "icon9~ipad", "icon10~ipad", "icon11~ipad", "icon12~ipad", "icon13~ipad", "icon14~ipad", "icon15~ipad", "icon16~ipad", "icon17~ipad", "icon18~ipad", "icon19~ipad", "icon20~ipad"]
    var appArray = ["AppIcon-1", "AppIcon-2", "AppIcon-3", "AppIcon-4", "AppIcon-5", "AppIcon-6", "AppIcon-7", "AppIcon-8", "AppIcon-9", "AppIcon-10", "AppIcon-11", "AppIcon-12", "AppIcon-13", "AppIcon-14", "AppIcon-15", "AppIcon-16", "AppIcon-17", "AppIcon-18", "AppIcon-19", "AppIcon-20"]
    
    
    func configure() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionAppCell", for: indexPath) as! CollectionAppCell
        
        cell.configure()
        
        cell.image.contentMode = .scaleAspectFill
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            cell.image.image = UIImage(named: self.appArrayIcons[indexPath.row])
        case .pad:
            cell.image.image = UIImage(named: self.appArrayIconsIPAD[indexPath.row])
        default:
            cell.image.image = UIImage(named: self.appArrayIcons[indexPath.row])
        }
        cell.image.backgroundColor = Colours.white
        
        cell.image.layer.cornerRadius = 15
        cell.image.layer.masksToBounds = true
        cell.image.layer.borderColor = UIColor.black.cgColor
        //cell.image.layer.borderWidth = 0.2
        
//        cell.image.frame.size.width = 60
//        cell.image.frame.size.height = 60
//        cell.bgImage.frame.size.width = 60
//        cell.bgImage.frame.size.height = 60
        
        cell.image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        cell.bgImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        
        cell.bgImage.layer.masksToBounds = false
        cell.bgImage.layer.shadowColor = UIColor.black.cgColor
        cell.bgImage.layer.shadowOffset = CGSize(width:0, height:6)
        cell.bgImage.layer.shadowRadius = 13
        cell.bgImage.layer.shadowOpacity = 0.22
        
        cell.frame.size.width = 80
        cell.frame.size.height = 80
        
        cell.backgroundColor = Colours.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            UIApplication.shared.setAlternateIconName(nil)
        } else {
            UIApplication.shared.setAlternateIconName(self.appArray[indexPath.row])
        }
    }
    
}



