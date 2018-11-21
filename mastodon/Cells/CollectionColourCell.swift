//
//  CollectionColourCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 15/10/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class CollectionColourCell: UICollectionViewCell {
    
    var bgImage = UIImageView()
    var image = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Set the cell's imageView's image to nil
        self.bgImage.image = nil
        self.image.image = nil
        
    }
    
    public func configure() {
        self.bgImage.backgroundColor = Colours.white
        self.bgImage.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        self.bgImage.layer.cornerRadius = 12
        contentView.addSubview(bgImage)
        
        self.image.frame.origin.x = 0
        self.image.frame.origin.y = 0
        self.image.frame.size.width = 55
        self.image.frame.size.height = 55
        self.image.backgroundColor = UIColor.clear
        self.image.layer.cornerRadius = 12
        contentView.addSubview(image)
    }
}



