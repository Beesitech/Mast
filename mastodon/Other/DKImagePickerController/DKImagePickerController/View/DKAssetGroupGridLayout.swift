//
//  DKAssetGroupGridLayout.swift
//  DKImagePickerControllerDemo
//
//  Created by ZhangAo on 16/1/17.
//  Copyright © 2016年 ZhangAo. All rights reserved.
//

import UIKit

open class DKAssetGroupGridLayout: UICollectionViewFlowLayout {
    
    open override func prepare() {
        super.prepare()
        
        var minItemWidth: CGFloat = 80
        
        if (UserDefaults.standard.object(forKey: "colgrid") == nil) || (UserDefaults.standard.object(forKey: "colgrid") as! Int == 0) {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    minItemWidth = 95
                default:
                    minItemWidth = 80
                }
            }
        } else if UserDefaults.standard.object(forKey: "colgrid") as! Int == 1 {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 2688:
                    minItemWidth = 110
                default:
                    minItemWidth = 95
                }
            }
        } else {
            minItemWidth = 150
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            minItemWidth = 100
        }
        
        let interval: CGFloat = 1
        self.minimumInteritemSpacing = interval
        self.minimumLineSpacing = interval
        
        let contentWidth = self.collectionView!.bounds.width
        
        let itemCount = Int(floor(contentWidth / minItemWidth))
        var itemWidth = (contentWidth - interval * (CGFloat(itemCount) - 1)) / CGFloat(itemCount)
        let actualInterval = (contentWidth - CGFloat(itemCount) * itemWidth) / (CGFloat(itemCount) - 1)
        itemWidth += actualInterval - interval
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        self.itemSize = itemSize
    }
    
}
