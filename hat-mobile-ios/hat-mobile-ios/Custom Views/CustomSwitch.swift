/**
 * Copyright (C) 2017 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import UIKit

// MARK: Class

/// A custom UIView representing a UISwitch.
@IBDesignable
internal class CustomSwitch: UIControl {
    
    // MARK: - Inspectable variables

    /// The padding of the UISwitch
    @IBInspectable public var padding: CGFloat = 1 {
        
        didSet {
            
            self.layoutSubviews()
        }
    }
    
    /// The tint color of the UISwitch when on
    @IBInspectable public var onTintColor: UIColor = .onSwitchTintColor {
        
        didSet {
            
            self.setupUI()
        }
    }
    
    /// The tint color of the UISwitch when off
    @IBInspectable public var offTintColor: UIColor = .lightGray {
        
        didSet {
            
            self.setupUI()
        }
    }
    
    /// The corner radius of the UISwitch
    @IBInspectable public var cornerRadius: CGFloat = 0.5 {
        
        didSet {
            
            self.layoutSubviews()
        }
    }
    
    /// The tint color of the thumb
    @IBInspectable public var thumbTintColor: UIColor = .white {
        
        didSet {
            
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    
    /// The corner radius of the thumb
    @IBInspectable public var thumbCornerRadius: CGFloat = 0.5 {
        
        didSet {
            
            self.layoutSubviews()
        }
    }
    
    /// The size of the thumb
    @IBInspectable public var thumbSize: CGSize = CGSize.zero {
        
        didSet {
            
            self.layoutSubviews()
        }
    }

    /// A bool value determing if the switch is on or off
    @IBInspectable public var isOn: Bool = true {
        
        didSet {
            
            self.setupUI()
        }
    }
    
    /// The animation duration from on to off and off to on
    @IBInspectable public var animationDuration: Double = 0.5
    
    /// A bool indicating if the labels are shown
    @IBInspectable public var areLabelsShown: Bool = true {
        
        didSet {
            
            self.setupUI()
        }
    }
    
    // MARK: - Variables
    
    /// The off label
    public var labelOff: UILabel = UILabel()
    /// The on label
    public var labelOn: UILabel = UILabel()
    
    /// The thumb. Base on a UIView
    fileprivate var thumbView: UIView = UIView(frame: CGRect.zero)
    
    /// The on point of the switch
    fileprivate var onPoint: CGPoint = CGPoint.zero
    
    /// The off point of the switch
    fileprivate var offPoint: CGPoint = CGPoint.zero
    
    /// A bool value indicatinf if the switch is animated or no
    fileprivate var isAnimating: Bool = false
    
    // MARK: - Clear view
    
    /**
     Clears the switch and removes it from the superview
     */
    private func clear() {
        
        for view in self.subviews {
            
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Setup view
    
    /**
     Sets up the switch.
     */
    func setupUI() {
        
        // remove everything if any
        self.clear()
        
        // configure it
        self.clipsToBounds = false
        
        // create and configure the thumb
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        self.thumbView.layer.shadowColor = UIColor.black.cgColor
        self.thumbView.layer.shadowRadius = 1.5
        self.thumbView.layer.shadowOpacity = 0.4
        self.thumbView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        
        // set up the labels
        self.setupLabels()
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if !self.isAnimating {
            
            // set the corner radius
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            // set the background color
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            // thumb set up
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(
                width: self.bounds.size.height - 2,
                height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            // set the on and off point of the switch
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            // set the frame of the thumb view based on the on and off points
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            // set thumbs' corner radius
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        }
        
        // set up labels
        if self.areLabelsShown {
            
            // set label width
            let labelWidth = self.bounds.width / 2 - self.padding * 2
            
            // set up on and of labels frame
            self.labelOn.frame = CGRect(x: 2, y: 2, width: labelWidth, height: self.frame.height)
            self.labelOff.frame = CGRect(x: -2 + self.frame.width - labelWidth, y: 2, width: labelWidth, height: self.frame.height)
        }
    }
    
    /**
     Sets up the on and off labels
     */
    fileprivate func setupLabels() {
        
        // set labels alpha value based on if they are visible or not
        guard self.areLabelsShown else {
            
            self.labelOff.alpha = 0
            self.labelOn.alpha = 0
            
            return
        }
        
        self.labelOff.alpha = 1
        self.labelOn.alpha = 1
        
        // set label width
        let labelWidth = self.bounds.width / 2 - self.padding * 2
        
        // set their frame
        self.labelOn.frame = CGRect(x: 2, y: 2, width: labelWidth, height: self.frame.height)
        self.labelOff.frame = CGRect(x: -2 + self.frame.width - labelWidth, y: 2, width: labelWidth, height: self.frame.height)
        
        // run size to fit to draw the view correctly
        self.labelOff.sizeToFit()
        self.labelOn.sizeToFit()
        
        // set their icons
        self.labelOff.attributedText = NSAttributedString(string: "\u{1F512}", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 15.5)!])
        self.labelOn.attributedText = NSAttributedString(string: "\u{1F513}", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 15.5)!])
        
        // align them in center
        self.labelOff.textAlignment = .center
        self.labelOn.textAlignment = .center
        
        // add them in the subview
        self.insertSubview(self.labelOff, belowSubview: self.thumbView)
        self.insertSubview(self.labelOn, belowSubview: self.thumbView)
    }
    
    // MARK: - Animate view
    
    /**
     Animates between the on and off position
     */
    private func animate() {
        
        self.isOn = !self.isOn
        
        self.isAnimating = true
        
        UIView.animate(
            withDuration: self.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options:
                [UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState],
            animations: {
                                                    
                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
                
            },
            completion: { _ in

                self.isAnimating = false
                self.sendActions(for: UIControlEvents.valueChanged)
            }
        )
    }
    
    // MARK: - Begin tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        super.beginTracking(touch, with: event)
        
        self.animate()
        
        return true
    }
}
