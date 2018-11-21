//
//  SKPhoto.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import ImageIO
import Regift
import AVFoundation
import CoreMedia

public protocol SKPhotoProtocol: NSObjectProtocol {
    var underlyingImage: UIImage! { get }
    var caption: String! { get }
    var index: Int? { get set}
    func loadUnderlyingImageAndNotify()
    func checkCache()
}

// MARK: - SKPhoto
open class SKPhoto: NSObject, SKPhotoProtocol {
    
    open var underlyingImage: UIImage!
    open var photoURL: String!
    open var shouldCachePhotoURLImage: Bool = false
    open var caption: String!
    open var index: Int?
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage) {
        self.init()
        underlyingImage = image
    }
    
    convenience init(url: String) {
        self.init()
        photoURL = url
    }
    
    convenience init(url: String, holder: UIImage?) {
        self.init()
        photoURL = url
        underlyingImage = holder
    }
    
    open func checkCache() {
        if photoURL != nil && shouldCachePhotoURLImage {
            if let img = UIImage.sharedSKPhotoCache().object(forKey: photoURL as AnyObject) as? UIImage {
                underlyingImage = img
            }
        }
    }
    /*
     open func loadUnderlyingImageAndNotify() {
     
     if underlyingImage != nil && photoURL == nil {
     loadUnderlyingImageComplete()
     }
     
     if photoURL != nil {
     // Fetch Image
     let session = URLSession(configuration: URLSessionConfiguration.default)
     if let nsURL = URL(string: photoURL) {
     DispatchQueue.main.async {
     session.dataTask(with: nsURL, completionHandler: { [weak self](response: Data?, data: URLResponse?, error: NSError?) in
     if let _self = self {
     
     if error != nil {
     DispatchQueue.main.async {
     _self.loadUnderlyingImageComplete()
     }
     }
     
     if let res = response, let image = UIImage(data: res) {
     if _self.shouldCachePhotoURLImage {
     UIImage.sharedSKPhotoCache().setObject(image, forKey: _self.photoURL as AnyObject)
     }
     DispatchQueue.main.async {
     _self.underlyingImage = image
     _self.loadUnderlyingImageComplete()
     }
     }
     session.finishTasksAndInvalidate()
     }
     } as! (Data?, URLResponse?, Error?) -> Void).resume()
     }
     }
     }
     }*/
    open func loadUnderlyingImageAndNotify() {
        guard photoURL != nil, let URL = URL(string: photoURL) else { return }
        
        // Fetch Image
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var task: URLSessionTask?
        task = session.dataTask(with: URL, completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer { session.finishTasksAndInvalidate() }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadUnderlyingImageComplete()
                }
                return
            }
            
            //if TweetStruct.isVideo == false {
                if let data = data, let response = response, let image = UIImage(data: data) {
                    if self.shouldCachePhotoURLImage {
                        UIImage.sharedSKPhotoCache().setObject(image, forKey: self.photoURL as AnyObject)
                    }
                    DispatchQueue.main.async {
                        self.underlyingImage = image
                        self.loadUnderlyingImageComplete()
                    }
                }
//            } else {
//
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadIm"), object: self)
//                let videoURL   = URL
//
//                //DispatchQueue.main.async {
//                    if TweetStruct.isVideoTime == 0 {
//
//                        if self.shouldCachePhotoURLImage {
//                            UIImage.sharedSKPhotoCache().setObject(self.underlyingImage, forKey: self.photoURL as AnyObject)
//                        }
//
//                        let asset = AVAsset(url: videoURL)
//                        let duration = asset.duration
//                        let durationTime = CMTimeGetSeconds(duration)
//
//                        //let regift = Regift(sourceFileURL: videoURL, frameCount: 20, delayTime: 0, loopCount: 0)
//                        let regift = Regift(sourceFileURL: videoURL, startTime: 0, duration: Float(durationTime), frameRate: 10, loopCount: 0)
//
//                        if let theProfileImageUrl = regift.createGif() {
//                            do {
//                                let imageData = try Data(contentsOf: theProfileImageUrl as URL)
//                                DispatchQueue.main.async {
//                                    self.underlyingImage = UIImage.gifImageWithData(imageData)
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loadImD"), object: self)
//                                    self.loadUnderlyingImageComplete()
//                                }
//                            } catch {
//                                print("Unable to load data: \(error)")
//                            }
//                        }
//                    } else {
//
//                        if self.shouldCachePhotoURLImage {
//                            UIImage.sharedSKPhotoCache().setObject(self.underlyingImage, forKey: self.photoURL as AnyObject)
//                        }
//
//                        let regift = Regift(sourceFileURL: videoURL, startTime: 0, duration: Float(TweetStruct.isVideoTime), frameRate: 10, loopCount: 0)
//
//                        if let theProfileImageUrl = regift.createGif() {
//                            do {
//                                let imageData = try Data(contentsOf: theProfileImageUrl as URL)
//                                DispatchQueue.main.async {
//                                    self.underlyingImage = UIImage.gifImageWithData(imageData)
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loadImD"), object: self)
//                                    self.loadUnderlyingImageComplete()
//                                }
//                            } catch {
//                                print("Unable to load data: \(error)")
//                            }
//                        }
//                    }
//
//
//
//                //}
//
//                /*
//                 if let source = CGImageSourceCreateWithData(data as! CFData, nil) {
//                 self.underlyingImage = UIImage.animatedImageWithSource(source)
//                 self.loadUnderlyingImageComplete()
//                 }*/
//                /*
//                 if let source = CGImageSourceCreateWithData(data as! CFData, nil) {
//                 DispatchQueue.main.async {
//                 self.underlyingImage = UIImage.animatedImageWithSource(source)
//                 self.loadUnderlyingImageComplete()
//                 }
//                 }
//                 */
//            }
        })
        task?.resume()
    }
    
    
    open func loadUnderlyingImageComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SKPHOTO_LOADING_DID_END_NOTIFICATION), object: self)
    }
    
    // MARK: - class func
    open class func photoWithImage(_ image: UIImage) -> SKPhoto {
        return SKPhoto(image: image)
    }
    
    open class func photoWithImageURL(_ url: String) -> SKPhoto {
        return SKPhoto(url: url)
    }
    
    open class func photoWithImageURL(_ url: String, holder: UIImage?) -> SKPhoto {
        return SKPhoto(url: url, holder: holder)
    }
}

// MARK: - extension UIImage
public extension UIImage {
    fileprivate class func sharedSKPhotoCache() -> NSCache<AnyObject, AnyObject>! {
        struct StaticSharedSKPhotoCache {
            static var sharedCache = NSCache<AnyObject, AnyObject>()
            static var onceToken: Int = 0
        }
        //dispatch_once(&StaticSharedSKPhotoCache.onceToken) {
        StaticSharedSKPhotoCache.sharedCache = NSCache()
        //}
        return StaticSharedSKPhotoCache.sharedCache
    }
}
