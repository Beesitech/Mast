//
//  SKDetectingImageView.swift
//  SKPhotoBrowser
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

@objc protocol SKDetectingImageViewDelegate {
    func handleImageViewSingleTap(_ view: UIImageView, touch: UITouch)
    func handleImageViewDoubleTap(_ view: UIImageView, touch: UITouch)
}

class SKDetectingImageView: UIImageView {
    weak var delegate: SKDetectingImageViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let touch = touches.first!
        switch touch.tapCount {
        case 1 : handleSingleTap(touch)
        case 2 : handleDoubleTap(touch)
        default: break
        }
        next
    }
    
    func handleSingleTap(_ touch: UITouch) {
        delegate?.handleImageViewSingleTap(self, touch: touch)
    }
    func handleDoubleTap(_ touch: UITouch) {
        delegate?.handleImageViewDoubleTap(self, touch: touch)
    }
}
