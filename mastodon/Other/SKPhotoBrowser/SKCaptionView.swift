//
//  SKCaptionView.swift
//  SKPhotoBrowser
//
//  Created by suzuki_keishi  on 2015/10/07.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class SKCaptionView: UIView {
    final let screenBound = UIScreen.main.bounds
    fileprivate var screenWidth: CGFloat { return screenBound.size.width }
    fileprivate var screenHeight: CGFloat { return screenBound.size.height }
    fileprivate var photo: SKPhotoProtocol!
    fileprivate var photoLabel: UILabel!
    fileprivate var photoLabelPadding: CGFloat = 10
    fileprivate var fadeView: UIView = UIView()
    fileprivate var gradientLayer = CAGradientLayer()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(photo: SKPhotoProtocol) {
        let screenBound = UIScreen.main.bounds
        self.init(frame: CGRect(x: 0, y: 0, width: screenBound.size.width, height: screenBound.size.height))
        self.photo = photo
        setup()
    }
    
    func setup() {
        isOpaque = false
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
        
        // setup background first
        fadeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(fadeView)
        
        // add layer at fadeView
        gradientLayer.colors = [UIColor(white: 0.0, alpha: 0.0).cgColor, UIColor(white: 0.0, alpha: 0.8).cgColor]
        fadeView.layer.insertSublayer(gradientLayer, at: 0)
        
        photoLabel = UILabel(frame: CGRect(x: photoLabelPadding, y: 0,
            width: bounds.size.width - (photoLabelPadding * 2), height: bounds.size.height))
        photoLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoLabel.isOpaque = false
        photoLabel.backgroundColor = .clear
        photoLabel.textColor = .white
        photoLabel.textAlignment = .center
        photoLabel.lineBreakMode = .byTruncatingTail
        photoLabel.numberOfLines = 3
        photoLabel.shadowColor = UIColor(white: 0.0, alpha: 0.5)
        photoLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        photoLabel.font = UIFont.systemFont(ofSize: CGFloat(Colours.fontSize1))
        if let cap = photo.caption {
            photoLabel.text = cap
        }
        addSubview(photoLabel)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let text = photoLabel.text else {
            return CGSize.zero
        }
        guard photoLabel.text?.characters.count > 0 else {
            return CGSize.zero
        }
        
        let font: UIFont = photoLabel.font
        let width: CGFloat = size.width - (photoLabelPadding * 2)
        let height: CGFloat = photoLabel.font.lineHeight * CGFloat(photoLabel.numberOfLines)
        
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let textSize = attributedText.boundingRect(with: CGSize(width: width, height: height),
            options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        
        return CGSize(width: textSize.width, height: textSize.height + photoLabelPadding * 2)
    }
    
    open override func layoutSubviews() {
        fadeView.frame = frame
        gradientLayer.frame = frame
    }
}

