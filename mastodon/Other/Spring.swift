// The MIT License (MIT)
//
// Copyright (c) 2015 Meng To (meng@designcode.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

import UIKit

var duration = 0.7
var delay = 0.0
var damping = 0.7
var velocity = 0.7

func spring(duration: TimeInterval, animations: (() -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
    }, completion: { finished in
        
    })
}

func springWithDelay(duration: TimeInterval, delay: TimeInterval, animations: (() -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
    }, completion: { finished in
        
    })
}

func slideUp(duration: TimeInterval, animations: (() -> Void)!) {
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
    }, completion: nil)
}

func springWithCompletion(duration: TimeInterval, animations: (() -> Void)!, completion: ((Bool) -> Void)!) {
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        animations()
        
    }, completion: { finished in
        completion(true)
    })
}

func springScaleFrom (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransform(translationX: x, y: y)
    let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
    view.transform = translation.concatenating(scale)
    
    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransform(translationX: 0, y: 0)
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = translation.concatenating(scale)
        
    }, completion: nil)
}

func springScaleTo (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransform(translationX: 0, y: 0)
    let scale = CGAffineTransform(scaleX: 1, y: 1)
    view.transform = translation.concatenating(scale)
    
    UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
        
        let translation = CGAffineTransform(translationX: x, y: y)
        let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
        view.transform = translation.concatenating(scale)
        
    }, completion: nil)
}

func popoverTopRight(view: UIView) {
    view.isHidden = false
    let translate = CGAffineTransform(translationX: 200, y: -200)
    let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
    view.alpha = 0
    view.transform = translate.concatenating(scale)
    
    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
        
        let translate = CGAffineTransform(translationX: 0, y: 0)
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        view.transform = translate.concatenating(scale)
        view.alpha = 1
        
    }, completion: nil)
}
