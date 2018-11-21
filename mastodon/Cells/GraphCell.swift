//
//  GraphCell.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class GraphCell: UITableViewCell {
    
    var graphView = ScrollableGraphView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [Double], labels: [String]) {
        
        self.graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 10, width: CGFloat(UIScreen.main.bounds.width), height: 200))
        
        self.graphView.lineWidth = 2.5
        self.graphView.lineColor = Colours.tabSelected
        self.graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
        self.graphView.dataPointSize = 1
        self.graphView.rangeMax = 5
        self.graphView.shouldFill = true
        self.graphView.fillType = ScrollableGraphViewFillType.gradient
        self.graphView.fillColor = Colours.tabSelected
        self.graphView.fillGradientType = ScrollableGraphViewGradientType.linear
        self.graphView.fillGradientStartColor = Colours.tabSelected
        self.graphView.fillGradientEndColor = Colours.white
        self.graphView.dataPointLabelsSparsity = 2
        //self.graphView.dataPointSpacing = (self.view.bounds.width / 8) - 3
        self.graphView.dataPointSize = 2
        self.graphView.dataPointFillColor = Colours.clear
        
        self.graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        self.graphView.referenceLineColor = UIColor.gray.withAlphaComponent(0.3)
        self.graphView.referenceLineLabelColor = UIColor.darkGray
        self.graphView.dataPointLabelColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        self.graphView.isScrollEnabled = false
        self.graphView.shouldAnimateOnStartup = false
        self.graphView.shouldAnimateOnAdapt = false
        self.graphView.shouldAdaptRange = true
        self.graphView.animationDuration = 1
        self.graphView.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        
        self.graphView.alpha = 1
        
        contentView.addSubview(self.graphView)
        self.graphView.set(data: data, withLabels: labels)
    }
    
}

