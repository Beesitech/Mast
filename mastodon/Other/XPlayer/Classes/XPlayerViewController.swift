//
//  XPlayerViewController.swift
//  XPlayer
//
//  Created by duan on 16/6/21.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class XPlayerViewController: WOViewController {
	// UI
	let playerVC = AVPlayerViewController(nibName: nil, bundle: nil)
	let playButtton = UIButton()
	let fullScreenButton = UIButton()
	let closeButton = MNGExpandedTouchAreaButton()
	let timelineLabel = UILabel()
	let timelineViewContainer = UIView()
	let timelineView = UIView()
	let timelineProgressedView = UIView()
	let timelineDotView = UIView()
	let topGradientLayer = CAGradientLayer()
	let bottomGradientLayer = CAGradientLayer()
	// Gesture
	var sliderPanGesture: UIPanGestureRecognizer!
	var toggleControlTapGesture: UITapGestureRecognizer!
	// State
	var progress: CGFloat = 0 {
		didSet {
			timelineProgressedView.frame = CGRect(x: 0, y: 0, width: self.timelineView.bounds.width * self.progress, height: 2)
			timelineDotView.center = CGPoint(
				x: self.timelineProgressedView.bounds.width,
				y: self.timelineProgressedView.bounds.height / 2
			)
		}
	}
	var showingControls = true
	
	let themeColor: UIColor
	
	init(url: URL, themeColor: UIColor){
		self.themeColor = themeColor
		super.init()
		let playerItem = AVPlayerItem(url: url)
		self.playerVC.player = AVPlayer(playerItem: playerItem)
		self.playerVC.view.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		// Action
		playButtton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
		fullScreenButton.addTarget(self, action: #selector(toggleOrientationSwitch), for: .touchUpInside)
		closeButton.addTarget(self, action: #selector(didPressClose), for: .touchUpInside)
		// Gesture
		sliderPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSliderPan))
		timelineViewContainer.addGestureRecognizer(sliderPanGesture)
		toggleControlTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleShowControls))
		view.addGestureRecognizer(toggleControlTapGesture)
		// State
		transitionPanGesture.isEnabled = false
        fullScreenButton.alpha = 0
        
	}
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
		playerVC.player!.addObserver(self,
		                             forKeyPath: "rate",
		                             options: [.new],
		                             context: nil)
		playerVC.player!.currentItem!.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        playerVC.player!.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: nil) { [weak self] (time) in
			guard let timecode = self?.playerVC.player?.currentItem?.duration.timecode() else { return }
			guard let currentTimecode = self?.playerVC.player?.currentItem?.currentTime().timecode() else { return }
			self?.timelineLabel.text = currentTimecode + " / " + timecode
		}
        playerVC.player!.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: nil) { [weak self] (time) in
			guard let timecode = self?.playerVC.player?.currentItem?.duration else { return }
			guard let currentTimecode = self?.playerVC.player?.currentItem?.currentTime() else { return }
			let percentage = CMTimeGetSeconds(currentTimecode) / CMTimeGetSeconds(timecode)
			if !percentage.isNaN {
				self?.progress = CGFloat(percentage)
			}
		}
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            if self.playerVC.player != nil {
                self.playerVC.player!.seek(to: CMTime.zero)
            self.playerVC.player!.play()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
		playerVC.player?.play()
	}
	
	override func viewDidLayoutSubviews() {
		topGradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/6)
		bottomGradientLayer.frame = CGRect(x: 0, y: (self.view.bounds.height/6)*5, width: self.view.bounds.width, height: self.view.bounds.height/6)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		// play & stop
		if keyPath == "rate" {
			guard let rate = change?[NSKeyValueChangeKey.newKey] as? Float else { return }
			if rate == 0 {
				// stopped & lag
				playButtton.setImage(UIImage(named: "play_24")?.withRenderingMode(.alwaysTemplate), for: .normal)
			}
			if rate == 1.0 {
				// start play
				playButtton.setImage(UIImage(named: "pause_24")?.withRenderingMode(.alwaysTemplate), for: .normal)
			}
		}
		// finish loading
		if keyPath == "status" {
            if playerVC.player!.currentItem!.status == AVPlayerItem.Status.readyToPlay {
				self.timelineViewContainer.isUserInteractionEnabled = true
				if let presentationSize = self.playerVC.player?.currentItem?.presentationSize , presentationSize != CGSize.zero {
					let pipHeight = WOMaintainerInfo.pipDefaultSize.width * presentationSize.height / presentationSize.width
					let pipSize = CGSize(width: WOMaintainerInfo.pipDefaultSize.width, height: pipHeight)
					self.PIPRect = WOMaintainerInfo.pipRect(size: pipSize)
				}
				self.transitionPanGesture.isEnabled = true
			}
            if playerVC.player!.currentItem!.status == AVPlayerItem.Status.failed {
			}
		}
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return [.landscape, .portrait]
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
}

// MARK: Utils
extension CMTime {
	func timecode() -> String? {
		let totalSeconds = CMTimeGetSeconds(self)
		if totalSeconds.isNaN { return nil }
		let minutes = Int(floor(CGFloat(totalSeconds) / 60))
		let seconds = Int(totalSeconds) % 60
		if minutes < 0 || seconds < 0 { return nil }
		let minuteString = minutes >= 10 ? "\(minutes)" : "0\(minutes)"
		let secondString = seconds >= 10 ? "\(seconds)" : "0\(seconds)"
		return minuteString + ":" + secondString
	}
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orientationLock = orientation
//        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}
