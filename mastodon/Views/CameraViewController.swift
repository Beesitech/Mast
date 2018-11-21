//
//  CameraViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 27/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import NextLevel
import Regift

class CameraViewController: UIViewController {
    
    // MARK: - UIViewController
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - properties
    
    var finishedRec = false
    
    internal var previewView: UIView?
    internal var gestureView: UIView?
    //internal var focusView: FocusIndicatorView?
    internal var controlDockView: UIView?
    
    internal var recordButton: UIButton?
    internal var flipButton: UIButton?
    internal var flashButton: UIButton?
    internal var saveButton: UIButton?
    
    internal var longPressGestureRecognizer: UILongPressGestureRecognizer?
    internal var photoTapGestureRecognizer: UITapGestureRecognizer?
    internal var focusTapGestureRecognizer: UITapGestureRecognizer?
    internal var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    
    internal var _panStartPoint: CGPoint = .zero
    internal var _panStartZoom: CGFloat = 0.0
    
    var qrButton = UIButton()
    var newText = ""
    
    // MARK: - object lifecycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            print("Swipe Down")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func qrTap(button: UIButton) {
        let stringDict:[String: String] = ["text": "\(self.newText)"]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "qrstuff2"), object: nil , userInfo: stringDict)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func qrstuff(_ notification: NSNotification) {
        if let text = notification.userInfo?["text"] as? String {
            
            if self.newText == text {} else {
                
                let oneone = NSAttributedString(
                    string: "Tap to add detected link to your tweet\n",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: UIColor.white,
                        NSAttributedString.Key.kern: 0
                    ])
                let twotwo = NSAttributedString(
                    string: text,
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                        NSAttributedString.Key.kern: 0
                    ])
                
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 2688:
                        self.qrButton.frame = CGRect(x: 20, y: 55, width: self.view.bounds.width - 40, height: 55)
                    case 2436, 1792:
                        self.qrButton.frame = CGRect(x: 20, y: 55, width: self.view.bounds.width - 40, height: 55)
                    default:
                        self.qrButton.frame = CGRect(x: 20, y: 31, width: self.view.bounds.width - 40, height: 55)
                    }
                }
                
                let result = NSMutableAttributedString()
                result.append(oneone)
                result.append(twotwo)
                
                self.qrButton.backgroundColor = Colours.tabSelected
                self.qrButton.layer.cornerRadius = 12
                self.qrButton.setAttributedTitle(result, for: .normal)
                self.qrButton.contentHorizontalAlignment = .left
                self.qrButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                self.qrButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                self.qrButton.titleLabel?.numberOfLines = 2
                self.qrButton.titleLabel?.textAlignment = .left
                self.qrButton.layer.shadowColor = UIColor.black.cgColor
                self.qrButton.layer.shadowOffset = CGSize(width:0, height:6)
                self.qrButton.layer.shadowRadius = 16
                self.qrButton.layer.shadowOpacity = 0.3
                self.qrButton.addTarget(self, action: #selector(self.qrTap), for: .touchUpInside)
                self.qrButton.alpha = 0
                self.view.addSubview(self.qrButton)
                
                self.newText = text
                
                self.qrButton.transform = CGAffineTransform(translationX: 0, y: 60)
                springWithDelay(duration: 1, delay: 0, animations: {
                    self.qrButton.alpha = 1
                    self.qrButton.transform = CGAffineTransform(translationX: 0, y: 0)
                })
                
                print(text)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.qrstuff), name: NSNotification.Name(rawValue: "qrstuff"), object: nil)
        DispatchQueue.main.async {
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
        }
        self.view.backgroundColor = UIColor.black
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let screenBounds = UIScreen.main.bounds
        
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // preview
        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.view.addSubview(previewView)
        }
        
        //self.focusView = FocusIndicatorView(frame: .zero)
        
        // buttons
        /*
         self.recordButton = UIImageView(image: UIImage(named: "tick2"))
         self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
         if let recordButton = self.recordButton,
         let longPressGestureRecognizer = self.longPressGestureRecognizer {
         recordButton.isUserInteractionEnabled = true
         recordButton.sizeToFit()
         
         longPressGestureRecognizer.delegate = self
         longPressGestureRecognizer.minimumPressDuration = 0.05
         longPressGestureRecognizer.allowableMovement = 10.0
         recordButton.addGestureRecognizer(longPressGestureRecognizer)
         recordButton.addTarget(self, action: #selector(handlePhotoTapGestureRecognizer(_:)), for: .touchUpInside)
         }
         */
        
        
        var somePos = self.view.bounds.height - 49
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                somePos = self.view.bounds.height - 79 - 30
            case 2436, 1792:
                somePos = self.view.bounds.height - 79 - 30
            default:
                somePos = self.view.bounds.height - 49 - 30
            }
        }
        
        
        self.recordButton = UIButton(type: .custom)
        if let recordButton = self.recordButton {
            recordButton.backgroundColor = Colours.tabSelected
            recordButton.frame = (CGRect(x: self.view.bounds.width/2 - 35, y: somePos - 10, width: 70, height: 70))
            recordButton.layer.cornerRadius = 35
            recordButton.layer.shadowColor = UIColor.black.cgColor
            recordButton.layer.shadowOffset = CGSize(width:0, height:6)
            recordButton.layer.shadowRadius = 16
            recordButton.layer.shadowOpacity = 0.3
            //recordButton.setImage(UIImage(named: "tick2"), for: .normal)
            //recordButton.sizeToFit()
            recordButton.addTarget(self, action: #selector(handlePhotoTapGestureRecognizer(_:)), for: .touchUpInside)
            
            
//            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGestureRecognizer))
//            recordButton.isUserInteractionEnabled = true
//            longPressGestureRecognizer.delegate = self
//            longPressGestureRecognizer.minimumPressDuration = 0.02
//            longPressGestureRecognizer.allowableMovement = 10.0
//            recordButton.addGestureRecognizer(longPressGestureRecognizer)
            
            
            self.view.addSubview(recordButton)
        }
        
        self.flipButton = UIButton(type: .custom)
        if let flipButton = self.flipButton {
            DispatchQueue.main.async {
                flipButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                flipButton.frame = (CGRect(x: (self.view.bounds.width/2 - 25) + 110, y: somePos, width: 50, height: 50))
                flipButton.layer.cornerRadius = 25
                flipButton.setImage(UIImage(named: "fl")?.maskWithColor(color: UIColor.white.withAlphaComponent(0.9)), for: .normal)
                flipButton.imageEdgeInsets = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
                //flipButton.setImage(UIImage(named: "tick2"), for: .normal)
                //flipButton.sizeToFit()
                flipButton.addTarget(self, action: #selector(self.handleFlipButton(_:)), for: .touchUpInside)
                self.view.addSubview(flipButton)
            }
        }
        
        self.saveButton = UIButton(type: .custom)
        if let saveButton = self.saveButton {
            DispatchQueue.main.async {
                saveButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                saveButton.frame = (CGRect(x: (self.view.bounds.width/2 - 25) - 110, y: somePos, width: 50, height: 50))
                saveButton.layer.cornerRadius = 25
                saveButton.setImage(UIImage(named: "crcr")?.maskWithColor(color: UIColor.white.withAlphaComponent(0.9)), for: .normal)
                saveButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
                //saveButton.setImage(UIImage(named: "tick2"), for: .normal)
                //saveButton.sizeToFit()
                saveButton.addTarget(self, action: #selector(self.handleSaveButton(_:)), for: .touchUpInside)
                self.view.addSubview(saveButton)
            }
        }
        
        
        
        
        
        
        /*
         // capture control "dock"
         let controlDockHeight = screenBounds.height * 0.2
         self.controlDockView = UIView(frame: CGRect(x: 0, y: screenBounds.height - controlDockHeight, width: screenBounds.width, height: controlDockHeight))
         if let controlDockView = self.controlDockView {
         controlDockView.backgroundColor = UIColor.clear
         controlDockView.autoresizingMask = [.flexibleTopMargin]
         self.view.addSubview(controlDockView)
         
         if let recordButton = self.recordButton {
         recordButton.center = CGPoint(x: controlDockView.bounds.midX, y: controlDockView.bounds.midY)
         controlDockView.addSubview(recordButton)
         }
         
         if let flipButton = self.flipButton, let recordButton = self.recordButton {
         flipButton.center = CGPoint(x: recordButton.center.x + controlDockView.bounds.width * 0.25 + flipButton.bounds.width * 0.5, y: recordButton.center.y)
         controlDockView.addSubview(flipButton)
         }
         
         if let saveButton = self.saveButton, let recordButton = self.recordButton {
         saveButton.center = CGPoint(x: controlDockView.bounds.width * 0.25 - saveButton.bounds.width * 0.5, y: recordButton.center.y)
         controlDockView.addSubview(saveButton)
         }
         }*/
        
        // gestures
        self.gestureView = UIView(frame: screenBounds)
        if let gestureView = self.gestureView, let controlDockView = self.controlDockView {
            gestureView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            gestureView.frame.size.height -= controlDockView.frame.height
            gestureView.backgroundColor = .clear
            self.view.addSubview(gestureView)
            
            self.focusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFocusTapGestureRecognizer(_:)))
            if let focusTapGestureRecognizer = self.focusTapGestureRecognizer {
                focusTapGestureRecognizer.delegate = self
                focusTapGestureRecognizer.numberOfTapsRequired = 1
                gestureView.addGestureRecognizer(focusTapGestureRecognizer)
            }
        }
        
        // Configure NextLevel by modifying the configuration ivars
        let nextLevel = NextLevel.shared
        nextLevel.delegate = self
        nextLevel.deviceDelegate = self
        nextLevel.flashDelegate = self
        nextLevel.videoDelegate = self
        nextLevel.photoDelegate = self
        
        // video configuration
        nextLevel.videoConfiguration.bitRate = 2000000
        nextLevel.videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill
        
        // audio configuration
        nextLevel.audioConfiguration.bitRate = 96000
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextLevel = NextLevel.shared
        if nextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            nextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try nextLevel.start()
                nextLevel.photoStabilizationEnabled = true
                
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            nextLevel.requestAuthorization(forMediaType: AVMediaType.video)
            nextLevel.requestAuthorization(forMediaType: AVMediaType.audio)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
        }
        NextLevel.shared.stop()
    }
    
}

// MARK: - library
extension CameraViewController {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

// MARK: - capture
extension CameraViewController {
    
    @objc func startRec(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            startCapture()
        } else if recognizer.state == .ended {
            pauseCapture()
        }
    }
    
    internal func startCapture() {
        self.photoTapGestureRecognizer?.isEnabled = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.recordButton?.backgroundColor = Colours.red
            self.recordButton?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }) { (completed: Bool) in
        }
        NextLevel.shared.record()
        
    }
    
    internal func pauseCapture() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.recordButton?.backgroundColor = Colours.tabSelected
            self.recordButton?.transform = .identity
        }) { (completed: Bool) in
        }
        NextLevel.shared.pause()
        self.finishedRec = true
        //endCapture()
    }
    
    internal func endCapture() {
        self.photoTapGestureRecognizer?.isEnabled = true
        
        if let session = NextLevel.shared.session {
            
            if session.clips.count > 1 {
                NextLevel.shared.session?.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let videoUrl = url {
                        print("save video0")
                        self.saveVideo(withURL: videoUrl)
                    } else if let _ = error {
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else {
                if let videoUrl = session.lastClipUrl {
                    print("save video")
                    self.saveVideo(withURL: videoUrl)
                } else {
                    self.endCapture()
                }
            }
            
        }
        
    }
    
    internal func saveVideo(withURL url: URL) {
        
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: "Mast")
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Mast")
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: "Mast") {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            print("saved")
                            let stringDict:[String: String] = ["text": "\(url.absoluteString)"]
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "qrstuff3"), object: nil , userInfo: stringDict)
                        } else {
                            print("not saved")
                        }
                    })
                }
        })
        
        //var photoImage = UIImage()
        if let photoImage = self.getThumbnailImage(forUrl: url) {
            do {
                print("startsendvid0")
                let video = try Data(contentsOf: url, options: .mappedIfSafe)
                //TweetStruct.videoURL = video
                
                StoreStruct.photoNew = photoImage
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cpick"), object: self)
                self.dismissThis()
            } catch {
                print("startsendvid1")
                print(error)
                return
            }
            
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

// MARK: - UIButton
extension CameraViewController {
    
    @objc internal func handleFlipButton(_ button: UIButton) {
        
        if self.finishedRec {
            self.endCapture()
        } else {
            NextLevel.shared.flipCaptureDevicePosition()
            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
            }
        }
    }
    
    internal func handleFlashModeButton(_ button: UIButton) {
    }
    
    @objc internal func handleSaveButton(_ button: UIButton) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        self.dismissThis()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CameraViewController: UIGestureRecognizerDelegate {
    
    @objc internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.startCapture()
            self.beganAnim()
            self._panStartPoint = gestureRecognizer.location(in: self.view)
            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
            let newPoint = gestureRecognizer.location(in: self.view)
            let scale = (self._panStartPoint.y / newPoint.y)
            let newZoom = (scale * self._panStartZoom)
            NextLevel.shared.videoZoomFactor = Float(newZoom)
            break
        case .ended:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            self.pauseCapture()
            self.endAnim()
            fallthrough
        default:
            break
        }
    }
    
    func beganAnim() {
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.saveButton?.alpha = 0
            self.flipButton?.alpha = 0
        })
    }
    func endAnim() {
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.saveButton?.alpha = 1
            self.flipButton?.setImage(UIImage(named: "tick2")?.maskWithColor(color: UIColor.white.withAlphaComponent(0.9)), for: .normal)
            self.flipButton?.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
            self.flipButton?.alpha = 1
        })
    }
}

extension CameraViewController {
    
    @objc internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        NextLevel.shared.capturePhotoFromVideo()
    }
    
    @objc internal func handleFocusTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self.previewView)
        /*
         if let focusView = self.focusView {
         var focusFrame = focusView.frame
         focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
         focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
         focusView.frame = focusFrame
         
         self.previewView?.addSubview(focusView)
         focusView.startAnimation()
         }
         */
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
    
}

// MARK: - NextLevelDelegate
extension CameraViewController: NextLevelDelegate {
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType) {
        print("NextLevel, authorization updated for media \(mediaType) status \(status)")
        if nextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            nextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else if status == .notAuthorized {
            // gracefully handle when audio/video is not authorized
            print("NextLevel doesn't have authorization for audio or video")
        }
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelPreviewDelegate {
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelDeviceDelegate {
    
    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        /*if let focusView = self.focusView {
         if focusView.superview != nil {
         focusView.stopAnimation()
         }
         }*/
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        /*if let focusView = self.focusView {
         if focusView.superview != nil {
         focusView.stopAnimation()
         }
         }*/
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelFlashDelegate
extension CameraViewController: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelVideoDelegate
extension CameraViewController: NextLevelVideoDelegate {
    /*func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
     print("test")
     print(photoDict)
     }*/
    
    
    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }
    
    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }
    
    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }
    
    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
        self.endCapture()
    }
    
    // video frame photo
    
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: "Test")
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Test")
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: "Test") {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                StoreStruct.photoNew = photoImage
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "cpick"), object: self)
                                self.dismissThis()
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
            
        }
        
    }
    
    
    func dismissThis() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - NextLevelPhotoDelegate
extension CameraViewController: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                /*
                 let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
                 if albumAssetCollection == nil {
                 let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                 let _ = changeRequest.placeholderForCreatedAssetCollection
                 }
                 */
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {/*
                     if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                     PHPhotoLibrary.shared().performChanges({
                     if let data = photoData as? Data,
                     let photoImage = UIImage(data: data) {
                     let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                     let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                     let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                     assetCollectionChangeRequest?.addAssets(enumeration)
                     }
                     }, completionHandler: { (success2: Bool, error2: Error?) in
                     if success2 == true {
                     let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alertController.addAction(okAction)
                     self.present(alertController, animated: true, completion: nil)
                     }
                     })
                     }*/
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - KVO
private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension CameraViewController {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

