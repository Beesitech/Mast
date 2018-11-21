//
//  ColourCells.swift
//  mastodon
//
//  Created by Shihab Mehboob on 15/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ColourCells: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKPhotoBrowserDelegate {
    
    var collectionView: UICollectionView!
    var profileStatuses: [Status] = []
    var profileStatusesHasImage: [Status] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = ColumnFlowLayout(
            cellsPerRow: 10,
            minimumInteritemSpacing: 14,
            minimumLineSpacing: 14,
            sectionInset: UIEdgeInsets(top: -10, left: 20, bottom: 0, right: 20)
        )
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55)
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(540), height: CGFloat(105)), collectionViewLayout: layout)
        } else {
            collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(105)), collectionViewLayout: layout)
        }
        collectionView.backgroundColor = Colours.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionColourCell.self, forCellWithReuseIdentifier: "CollectionColourCell")
        
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure() {
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 55, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreStruct.colArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionColourCell", for: indexPath) as! CollectionColourCell
        
        cell.configure()
        
        
        cell.image.backgroundColor = StoreStruct.colArray[indexPath.row]
        
        cell.image.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        cell.bgImage.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        
        
        cell.bgImage.layer.masksToBounds = false
        cell.bgImage.layer.shadowColor = UIColor.black.cgColor
        cell.bgImage.layer.shadowOffset = CGSize(width:0, height:6)
        cell.bgImage.layer.shadowRadius = 12
        cell.bgImage.layer.shadowOpacity = 0.12
        
        cell.frame.size.width = 55
        cell.frame.size.height = 55
        
        cell.backgroundColor = Colours.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
        
        Colours.tabSelected = StoreStruct.colArray[indexPath.row]
        window?.tintColor = Colours.tabSelected
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "themeTopStuff"), object: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "segTheme"), object: self)
        UserDefaults.standard.set(indexPath.row, forKey: "themeaccent")
    }
    
}




