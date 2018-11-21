//
//  GifIt.swift
//  Flightbase
//
//  Created by Shihab Mehboob on 16/05/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import AVFoundation

public class gifit {
    
    func optimalGIFfromURL(_ videoURL: URL?, loopCount: Int, completion completionBlock: @escaping (_ GifURL: URL?) -> Void) {
        let delayTime: Float = 0.02
        // Create properties dictionaries
        let fileProperties = loopCount
        let frameProperties = delayTime
        var asset: AVURLAsset? = nil
        if let anURL = videoURL {
            asset = AVURLAsset(url: anURL)
        }
        let videoWidth = Float(asset?.tracks(withMediaType: .video)[0].naturalSize.width ?? 0.0)
        let videoHeight = Float(asset?.tracks(withMediaType: .video)[0].naturalSize.height ?? 0.0)
        var optimalSize = 5
        if videoWidth >= 1200 || videoHeight >= 1200 {
            optimalSize = 2
        } else if videoWidth >= 800 || videoHeight >= 800 {
            optimalSize = 3
        } else if videoWidth >= 400 || videoHeight >= 400 {
            optimalSize = 5
        } else if videoWidth < 400 || videoHeight < 400 {
            optimalSize = 7
        }
        // Get the length of the video in seconds
        var videoLength = Float(asset?.duration.value ?? 1) / Float(asset?.duration.timescale ?? 1)
        var framesPerSecond: Int = 4
        var frameCount = Int(videoLength * Float(framesPerSecond))
        // How far along the video track we want to move, in seconds.
        var increment = videoLength / Float(frameCount)
        // Add frames to the buffer
        var timePoints = [AnyHashable]()
        for currentFrame in 0..<frameCount {
            var seconds = Float(increment) * Float(currentFrame)
            var time: CMTime = CMTimeMakeWithSeconds(Float64(seconds), preferredTimescale: 600)
            timePoints.append(NSValue(time: time))
        }
        // Prepare group for firing completion block
        var gifQueue = DispatchGroup()
        gifQueue.enter()
        var gifURL: URL?
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //gifURL = self.createGIFforTimePoints(timePoints, fromURL: videoURL, fileProperties: fileProperties, frameProperties: frameProperties, frameCount: frameCount, gifSize: optimalSize)
            gifQueue.leave()
        })
        //DispatchGroup().notify(queue: .main, work: gifQueue {() -> Void in
            // Return GIF URL
            completionBlock(gifURL)
        //})
    }
    /*
    func createGIFforTimePoints(_ timePoints: [Any]?, from url: URL?, fileProperties: [AnyHashable: Any]?, frameProperties: [AnyHashable: Any]?, frameCount: Int, gifSize: GIFSize) -> URL? {
        let timeEncodedFileName = "\(fileName)-\(UInt(Date().timeIntervalSince1970 * 10.0)).gif"
        let temporaryFile = NSTemporaryDirectory() + (timeEncodedFileName)
        let fileURL = URL(fileURLWithPath: temporaryFile)
        if fileURL == nil {
            return nil
        }
        let destination = CGImageDestinationCreateWithURL(fileURL as? CFURL?, kUTTypeGIF, frameCount, nil)
        CGImageDestinationSetProperties(destination, fileProperties as? CFDictionaryRef?)
        var asset = AVURLAsset(url: url, options: nil)
        var generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        var tol: CMTime = CMTimeMakeWithSeconds(tolerance, timeInterval)
        generator.requestedTimeToleranceBefore = tol
        generator.requestedTimeToleranceAfter = tol
        var error: Error? = nil
        var previousImageRefCopy: CGImageRef? = nil
        
    }
 */
}
