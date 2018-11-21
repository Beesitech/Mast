//
//  FloatingPanel v1.3
//  TNFloatingPanel.swift
//
//  Created by Thomas NAUDET @tomn94 on 07/07/2017.
//  Copyright © 2017 Thomas NAUDET. Under MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
/**
 Usage example:
 
 let panelController = FloatingPanelController()
 panelController.addTo(parent: viewController)
 panelController.resizeTo(CGSize(width: 320, height: 328))
 panelController.pinTo(position: .topLeading)
 panelController.set(viewController: yourContent)
 panelController.showPanel()
 
 More on:
 https://github.com/Tomn94/TNFloatingPanel
 */

import UIKit


/// View displayed in the FloatingPanelController
open class FloatingPanel: UIVisualEffectView {
    
    /// Margins between the panel and its parent view
    open static let defaultMargins = UIEdgeInsets(top:    10, left:  10,
                                                  bottom: 10, right: 10)
    
    /// Size of the rounded corners of the panel
    open static let cornerRadius: CGFloat = 10
    
    /// Available positions for the floating panel.
    /// Prefer using leading/trailing instead of left/right to support right-to-left languages
    public enum Position {
        case top
        case bottom
        case leading
        case trailing
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
        case left
        case right
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        /// By default, position undetermined, or you provided your own
        case custom
    }
    
    
    /// Current position of the floating panel
    open var position = Position.custom
    
    /// Margins applied to the floating panel
    open var margins = FloatingPanel.defaultMargins
    
    
    override public init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        /* Add clipping rounded corners */
        self.layer.cornerRadius = FloatingPanel.cornerRadius
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: -
/// View controller for a floating panel inside a view controller
open class FloatingPanelController: UIViewController {
    
    /// View containing the panel, on which shadows are applied.
    /// Use this view if you want to apply constraints/position/resize panel manually.
    open let panelContainer = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    
    /// View displayed by this custom view controller
    /// Use `panelContainer` instead of this view
    /// if you want to apply constraints/position/resize panel manually.
    open let panel: FloatingPanel
    
    /// Current view controller displayed by the panel
    open var viewController: UIViewController?
    
    /// Whether the panel is currently collapsed or visible on the parent
    open var isPanelVisible = false
    
    /// Horizontal constraints on `panelContainer` after calling `pinTo(position:margins:)`.
    /// First is leading/left, second is trailing/right
    private var hConstraints = [NSLayoutConstraint]()
    
    /// Vertical constraints on `panelContainer` after calling `pinTo(position:margins:)`
    /// First is top, second is bottom
    private var vConstraints = [NSLayoutConstraint]()
    
    
    /// Instantiates a new controller and its panel
    ///
    /// - Parameter style: Blur effect style for the panel.
    ///                    Default is extraLight.
    public init(style: UIBlurEffect.Style = .extraLight) {
        
        panel = FloatingPanel(effect: UIBlurEffect(style: style))
        
        super.init(nibName: nil, bundle: nil)
        
        /* Set up panel inside a container view */
        panel.frame = panelContainer.bounds
        panel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        panelContainer.addSubview(panel)
        
        /* Creating a countainer view allows adding a shadow on iOS 11 */
        panelContainer.layer.shadowOpacity  = 0.2
        panelContainer.layer.shadowOffset   = .zero
        if #available(iOS 11, *) {
        } else {
            panelContainer.layer.shadowPath = CGPath(roundedRect:  panelContainer.bounds,
                                                     cornerWidth:  FloatingPanel.cornerRadius,
                                                     cornerHeight: FloatingPanel.cornerRadius,
                                                     transform:    nil)
        }
        
        /* Add a thin border, on the container and not the panel itself
         (the panel has clipsToBounds = false, which would make the border weird in corners) */
        panelContainer.layer.cornerRadius = FloatingPanel.cornerRadius  // not clipped, used only by the border
        panelContainer.layer.borderColor  = UIColor.gray.withAlphaComponent(0.5).cgColor
        panelContainer.layer.borderWidth  = 1 / UIScreen.main.scale
        
        panelContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view = panelContainer
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11, *) {
        } else {
            panelContainer.layer.shadowPath = CGPath(roundedRect:  panelContainer.bounds,
                                                     cornerWidth:  FloatingPanel.cornerRadius,
                                                     cornerHeight: FloatingPanel.cornerRadius,
                                                     transform:    nil)
        }
    }
    
    
    // MARK: - Set Up Content
    
    /// Populates the panel with specified content
    ///
    /// - Parameter viewController: View controller to display in the panel
    open func set(viewController: UIViewController) {
        
        /* Remove any previous view controller */
        if let previousViewController = self.viewController {
            previousViewController.willMove(toParent: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }
        
        /* Set the new view controller as current */
        self.viewController = viewController
        self.addChild(viewController)
        self.panel.contentView.addSubview(viewController.view)
        
        /* Set up frame */
        viewController.view.frame = panel.contentView.bounds
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /* Finish */
        viewController.didMove(toParent: self)
    }
    
    
    // MARK: - Set Up Layout
    
    /// Helper to add a floating panel to the view of the given container
    /// You can call `resizeTo(_:)` then `pinTo(position:margins:)` after.
    ///
    /// - Parameter parentViewController: Parent view controller as the container
    open func addTo(parent parentViewController: UIViewController) {
        
        parentViewController.addChild(self)
        parentViewController.view.addSubview(panelContainer)
        self.didMove(toParent: parentViewController)
    }
    
    /// Helper to define size of the panel.
    /// Width is ignored if the panel position is top or bottom.
    /// Height is ignored if the panel position is leading, left, trailing or right.
    /// You can call `pinTo(position:margins:)` after.
    ///
    /// - Parameter size: New size for the panel.
    ///                   Uses the width or height of the parent view controller
    ///                   when the latter is not big enough
    open func resizeTo(_ size: CGSize) {
        
        panelContainer.removeConstraints(panelContainer.constraints)
        
        let widthConstraint  = panelContainer.widthAnchor.constraint(equalToConstant:  size.width)
        let heightConstraint = panelContainer.heightAnchor.constraint(equalToConstant: size.height)
        widthConstraint.priority  = .defaultHigh
        heightConstraint.priority = .defaultHigh
        
        switch panel.position {
        case .top, .bottom:
            heightConstraint.isActive = true
        case .leading, .left, .trailing, .right:
            widthConstraint.isActive  = true
        default:
            widthConstraint.isActive  = true
            heightConstraint.isActive = true
        }
    }
    
    /// Helper to position panel on a parent view controller.
    /// Better to call `resizeTo(_:)` before this method.
    ///
    /// - Parameters:
    ///   - position: New position of the panel in its parent view controller
    ///   - margins: Eventually provide custom margins to apply offset from the position
    ///              Default is 10pt on each side.
    ///              Note: Left & Right components are used for Leading & Trailing respectively
    open func pinTo(position: FloatingPanel.Position,
                    margins: UIEdgeInsets = FloatingPanel.defaultMargins) {
        
        panel.position = position
        panel.margins  = margins
        
        /* Remove any previous constraints */
        vConstraints.forEach { $0.isActive = false }
        hConstraints.forEach { $0.isActive = false }
        
        guard let parentViewController = self.parent else { return }
        
        /* Set Vertical position */
        if #available(iOS 11.0, *) {
            let guide = parentViewController.view.safeAreaLayoutGuide
            switch position {
            case .top, .topLeading, .topTrailing, .topLeft, .topRight:
                vConstraints = [panelContainer.topAnchor.constraint(equalTo: guide.topAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor,
                                                                       constant: -margins.bottom)]
            case .bottom, .bottomLeading, .bottomTrailing, .bottomLeft, .bottomRight:
                vConstraints = [panelContainer.topAnchor.constraint(greaterThanOrEqualTo: guide.topAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(equalTo: guide.bottomAnchor,
                                                                       constant: -margins.bottom)]
            case .leading, .trailing, .left, .right:
                vConstraints = [panelContainer.topAnchor.constraint(equalTo: guide.topAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(equalTo: guide.bottomAnchor,
                                                                       constant: -margins.bottom)]
            case .custom:
                vConstraints = []
            }
        } else {
            switch position {
            case .top, .topLeading, .topTrailing, .topLeft, .topRight:
                vConstraints = [panelContainer.topAnchor.constraint(equalTo: parentViewController.topLayoutGuide.bottomAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(lessThanOrEqualTo: parentViewController.bottomLayoutGuide.topAnchor,
                                                                       constant: -margins.bottom)]
            case .bottom, .bottomLeading, .bottomTrailing, .bottomLeft, .bottomRight:
                vConstraints = [panelContainer.topAnchor.constraint(greaterThanOrEqualTo: parentViewController.topLayoutGuide.bottomAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(equalTo: parentViewController.bottomLayoutGuide.topAnchor,
                                                                       constant: -margins.bottom)]
            case .leading, .trailing, .left, .right:
                vConstraints = [panelContainer.topAnchor.constraint(equalTo: parentViewController.topLayoutGuide.bottomAnchor,
                                                                    constant: margins.top),
                                panelContainer.bottomAnchor.constraint(equalTo: parentViewController.bottomLayoutGuide.topAnchor,
                                                                       constant: -margins.bottom)]
            case .custom:
                vConstraints = []
            }
        }
        vConstraints.forEach { $0.isActive = true }
        
        /* Set Horizontal position */
        let guide: UILayoutGuide
        if #available(iOS 11.0, *) { guide = parentViewController.view.safeAreaLayoutGuide }
        else { guide = parentViewController.view.layoutMarginsGuide }
        
        switch position {
        case .leading, .topLeading, .bottomLeading:
            hConstraints = [panelContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor,
                                                                    constant: margins.left),
                            panelContainer.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor,
                                                                     constant: -margins.right)]
        case .left, .topLeft, .bottomLeft:
            hConstraints = [panelContainer.leftAnchor.constraint(equalTo: guide.leftAnchor,
                                                                 constant: margins.left),
                            panelContainer.rightAnchor.constraint(lessThanOrEqualTo: guide.rightAnchor,
                                                                  constant: -margins.right)]
        case .trailing, .topTrailing, .bottomTrailing:
            hConstraints = [panelContainer.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor,
                                                                    constant: margins.left),
                            panelContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor,
                                                                     constant: -margins.right)]
        case .right, .topRight, .bottomRight:
            hConstraints = [panelContainer.leftAnchor.constraint(greaterThanOrEqualTo: guide.leftAnchor,
                                                                 constant: margins.left),
                            panelContainer.rightAnchor.constraint(equalTo: guide.rightAnchor,
                                                                  constant: -margins.right)]
        case .top, .bottom:
            hConstraints = [panelContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor,
                                                                    constant: margins.left),
                            panelContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor,
                                                                     constant: -margins.right)]
        case.custom:
            hConstraints = []
        }
        hConstraints.forEach { $0.isActive = true }
        
        
        /* Reposition panel if animated before */
        if !isPanelVisible {
            self.hidePanel(animated: false)
        } else {
            self.showPanel()
        }
    }
    
    
    // MARK: - Animate Panel
    
    /// Present the panel, using constraints set up in `pinTo(position:margins:)`
    ///
    /// - Parameters:
    ///   - animated: Whether expanding the panel should be animated
    ///   - inCornerAlongXAxis: Whether the panel should animate translation on the X axis,
    ///                         if the panel is pinned in a corner. Default is true.
    ///   - inCornerAlongYAxis: Whether the panel should animate translation on the Y axis,
    ///                         if the panel is pinned in a corner. Defaults to false.
    open func showPanel(animated:           Bool = true,
                        inCornerAlongXAxis: Bool = true,
                        inCornerAlongYAxis: Bool = false) {
        
        isPanelVisible = true
        
        /* Apply to UI */
        guard animated else {
            self.panelContainer.transform = .identity
            return
        }
        
        UIView.animate(withDuration: 0.42,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: [.beginFromCurrentState],
                       animations: {
                        self.panelContainer.transform = .identity
        })
    }
    
    /// Dismiss the panel, using constraints set up in `pinTo(position:margins:)`
    ///
    /// - Parameters:
    ///   - animated: Whether collapsing the panel should be animated
    ///   - inCornerAlongXAxis: Whether the panel should animate translation on the X axis,
    ///                         if the panel is pinned in a corner. Default is true.
    ///   - inCornerAlongYAxis: Whether the panel should animate translation on the Y axis,
    ///                         if the panel is pinned in a corner. Defaults to false.
    open func hidePanel(animated:           Bool = true,
                        inCornerAlongXAxis: Bool = true,
                        inCornerAlongYAxis: Bool = false) {
        
        isPanelVisible = false
        
        /* Compute off-screen position */                 // landscape iPhone iOS 10 fix
        var xOffset = panel.frame.width  + panel.margins.left + panel.margins.right + 15
        var yOffset = panel.frame.height + panel.margins.top  + panel.margins.bottom
        
        switch panel.position {
        case .leading, .left:
            xOffset *= -1
            yOffset  =  0
        case .trailing, .right:
            yOffset  =  0
        case .top:
            xOffset  =  0
            yOffset *= -1
        case .bottom:
            xOffset  =  0
        case .topLeading, .topLeft:
            xOffset  =  inCornerAlongXAxis ? xOffset * -1 : 0
            yOffset  =  inCornerAlongYAxis ? yOffset * -1 : 0
        case .topTrailing, .topRight:
            xOffset  =  inCornerAlongXAxis ? xOffset      : 0
            yOffset  =  inCornerAlongYAxis ? yOffset * -1 : 0
        case .bottomLeading, .bottomLeft:
            xOffset  =  inCornerAlongXAxis ? xOffset * -1 : 0
            yOffset  =  inCornerAlongYAxis ? yOffset      : 0
        case .bottomTrailing, .bottomRight:
            xOffset  =  inCornerAlongXAxis ? xOffset      : 0
            yOffset  =  inCornerAlongYAxis ? yOffset      : 0
        case .custom:
            return
        }
        
        /* Handle right-to-left languages */
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft &&
            inCornerAlongXAxis &&
            (panel.position == .leading  || panel.position == .topLeading  || panel.position == .bottomLeading ||
                panel.position == .trailing || panel.position == .topTrailing || panel.position == .bottomTrailing) {
            xOffset *= -1
        }
        
        /* Apply to UI */
        guard animated else {
            self.panelContainer.transform = CGAffineTransform(translationX: xOffset,
                                                              y: yOffset)
            return
        }
        
        UIView.animate(withDuration: 0.42,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: [.beginFromCurrentState],
                       animations: {
                        self.panelContainer.transform = CGAffineTransform(translationX: xOffset,
                                                                          y: yOffset)
        })
    }
    
}
