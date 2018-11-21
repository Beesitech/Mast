//
//  XPlayerViewController+UI.swift
//  XPlayer
//
//  Created by duan on 16/9/18.
//  Copyright © 2016年 monk-studio. All rights reserved.
//

import UIKit
import TinyConstraints


extension XPlayerViewController {
	func setupUI() {
        addChild(playerVC)
		playerVC.view.isUserInteractionEnabled = false
		view.insertSubview(playerVC.view, belowSubview: pipCloseButton)
        playerVC.didMove(toParent: self)

		[topGradientLayer, bottomGradientLayer].forEach { (layer) in
			layer.opacity = 0
            self.view.layer.addSublayer(layer)
		}
		[playButtton, closeButton, fullScreenButton, timelineLabel].forEach { button in
			button.layer.zPosition = 10
			self.view.addSubview(button)
		}
		timelineViewContainer.translatesAutoresizingMaskIntoConstraints = false
		timelineView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(timelineViewContainer)
		timelineViewContainer.addSubview(timelineView)
		timelineView.addSubview(timelineProgressedView)
		timelineView.addSubview(timelineDotView)


        playerVC.view.edgesToSuperview()

        playButtton.size(CGSize.square(24))
        playButtton.leadingToSuperview(offset: 16)
        playButtton.bottomToSuperview(offset: -36)

        fullScreenButton.size(CGSize.square(24))
        fullScreenButton.trailingToSuperview(offset: 16)
        fullScreenButton.bottomToSuperview(offset: -36)

        closeButton.size(CGSize.square(36))
        closeButton.leadingToSuperview(offset: 20)
        closeButton.topToSuperview(offset: 20)

        timelineLabel.centerY(to: fullScreenButton)
        timelineLabel.trailingToSuperview(offset: 16)

        timelineViewContainer.height(30)
        timelineViewContainer.leadingToTrailing(of: playButtton, offset: 16)
        timelineViewContainer.trailingToLeading(of: timelineLabel, offset: -16)
        timelineView.centerY(to: playButtton)

        timelineViewContainer.leading(to: timelineView)
        timelineViewContainer.trailing(to: timelineView)
        timelineViewContainer.centerY(to: timelineView)
        timelineView.height(2)

		timelineProgressedView.frame = CGRect(x: 0, y: 0, width: 0, height: 2)
		timelineDotView.frame = CGRect(x: -16 / 2, y: 2 / 2 - 16 / 2, width: 16, height: 16)

		view.backgroundColor = UIColor.black
        view.tintColor = UIColor.white
		playerVC.showsPlaybackControls = false
        playButtton.setImage(UIImage(named: "play_24")?.withRenderingMode(.alwaysTemplate), for: [])
		playButtton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
		playButtton.imageView?.contentMode = .scaleAspectFit
		fullScreenButton.setImage(UIImage(named: "maximize_24")?.withRenderingMode(.alwaysTemplate), for: [])
		fullScreenButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
		fullScreenButton.imageView?.contentMode = .scaleAspectFit
        fullScreenButton.alpha = 0
		closeButton.setImage(UIImage(named: "x_24")?.withRenderingMode(.alwaysTemplate), for: [])
		closeButton.imageView?.contentMode = .scaleAspectFit
		timelineView.backgroundColor = UIColor(white: 1, alpha: 0.2)
		timelineProgressedView.backgroundColor = Colours.tabSelected
		timelineDotView.backgroundColor = UIColor.white
		timelineView.layer.cornerRadius = 2
		timelineProgressedView.layer.cornerRadius = 2
		timelineDotView.layer.cornerRadius = 8
		timelineLabel.font = UIFont.boldSystemFont(ofSize: 12)
		timelineLabel.textAlignment = .center
		timelineLabel.textColor = UIColor.white
		timelineLabel.text = "00:00 / 00:00"
		topGradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		topGradientLayer.opacity = 1
		bottomGradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		bottomGradientLayer.opacity = 1
		timelineViewContainer.isUserInteractionEnabled = true
	}
}
