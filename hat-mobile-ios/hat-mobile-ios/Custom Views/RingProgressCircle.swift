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

///A custom UIView with a label and a ring around it
@IBDesignable
open class RingProgressCircle: UIView {
    
    // MARK: - IBInspectable variables
    
    ///The ring radius
    @IBInspectable open var ringRadius: CGFloat = 55
    ///The ring line width
    @IBInspectable open var ringLineWidth: CGFloat = 12.0
    
    ///The ring color
    @IBInspectable open var ringColor: UIColor = UIColor.red
    ///The ring fill color
    @IBInspectable open var ringFillColor: UIColor = UIColor.clear
    
    ///The background ring color
    @IBInspectable open var backgroundRingColor: UIColor = UIColor.gray
    ///The background ring fill color
    @IBInspectable open var backgroundRingFillColor: UIColor = UIColor.clear
    
    ///The ring's start point
    @IBInspectable open var startPoint: CGFloat = CGFloat(Double.pi / 2)
    ///The ring's end point
    @IBInspectable open var endPoint: CGFloat = CGFloat((Double.pi / 4) / 4)
    
    ///The ring's shadow radius
    @IBInspectable open var ringShadowRadius: CGFloat = 0.0
    
    ///The ring's shadow opacity
    @IBInspectable open var ringShadowOpacity: Float = 0.0
    
    ///The ring's shadow offset
    @IBInspectable open var ringShadowOffset: CGSize = CGSize.zero
    
    ///The animation duration.
    @IBInspectable open var animationDuration: CGFloat = 0.2
    
    // MARK: - Variables
    
    ///The UILabel in the middle of the UIView
    private var label: UILabel = UILabel()
    
    private var path: CGPath?
    
    private var previousArc: CAShapeLayer?
    
    private var timer: Timer?
    
    private var hasAnimationFinished: Bool = true

    // MARK: - Inits
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        //init circle
        self.initRingProgressCircle()
    }
    
    /**
     Initializes ring progress circle with the default values.
     
     - author: Marios-Andreas Tsekis
     - date: 15/7/16
     - version: 1.0
     - copyright: Copyright © 2016 Marios-Andreas Tsekis. All rights reserved.
     */
    func initRingProgressCircle() {
        
        //init ring progress bar
        ringRadius = 55
        ringColor = UIColor.red
        ringFillColor = UIColor.clear
        backgroundRingFillColor = UIColor.clear
        backgroundRingColor = UIColor.gray
        ringLineWidth = 12.0
        startPoint = CGFloat(-Double.pi / 2)
        endPoint = CGFloat(-Double.pi / 2)
        ringShadowRadius = 0.0
        ringShadowOpacity = 0.0
        ringShadowOffset = CGSize.zero
        animationDuration = 0.2
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //init circle
        self.initRingProgressCircle()
    }
    
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        //init circle
        self.initRingProgressCircle()
    }
    
    // MARK: - Create circle
    
    /**
     Creates a circle
     
     - parameter lineWidth: The width of the ring
     - parameter path: The path of the circle
     - parameter strokeStart: The starting point of the circle
     - parameter strokeEnd: The ending point of the circle
     - parameter strokeColor: The color of the ring
     - parameter fillColor: The fill color of the circle
     - parameter shadowRadius: The shadow radius
     - parameter shadowOpacity: The shadow opacity
     - parameter shadowOffsset: The shadow offset
     
     - author: Marios-Andreas Tsekis
     - date: 15/7/16
     - version: 1.0
     - copyright: Copyright © 2016 Marios-Andreas Tsekis. All rights reserved.
     */
    func addOval(_ lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat, strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor, shadowRadius: CGFloat, shadowOpacity: Float, shadowOffset: CGSize) -> CAShapeLayer {
        
        //create and setup the shape
        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        //arc.lineCap = "round"
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffset
        
        //add shape as a sublayer
        layer.addSublayer(arc)
        return arc
    }
    
    // MARK: - Draw Rect
    
    override open func draw(_ rect: CGRect) {
        
        //get the mid position of the view
        let X = self.bounds.midX
        let Y = self.bounds.midY
        let offset = -Double.pi / 2
        
        //create the background path of the circle
        let backgroundPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: self.ringRadius, startAngle: (CGFloat(0 + offset)), endAngle: CGFloat((Double.pi * 2) + offset), clockwise: true).cgPath
        //create the background path of the circle
        self.path = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: self.ringRadius, startAngle: self.startPoint, endAngle: self.endPoint, clockwise: true).cgPath
        
        //add a full background circle
        _ = self.addOval(self.ringLineWidth + 1, path: backgroundPath, strokeStart: 0, strokeEnd: 1, strokeColor: self.backgroundRingColor, fillColor: self.backgroundRingFillColor, shadowRadius: self.ringShadowRadius, shadowOpacity: self.ringShadowOpacity, shadowOffset: self.ringShadowOffset)
        
        //add a second cirlce representing the value we want
        let mainArc = self.addOval(self.ringLineWidth, path: self.path!, strokeStart: self.startPoint, strokeEnd: self.endPoint, strokeColor: self.ringColor, fillColor: self.ringFillColor, shadowRadius: self.ringShadowRadius, shadowOpacity: self.ringShadowOpacity, shadowOffset: self.ringShadowOffset)
        
        //animate main circle
        AnimationHelper.animateCircle(from: 0, toValue: 1, duration: TimeInterval(self.animationDuration), arc: mainArc)
    }
    
    // MARK: - Timer method
    
    /**
     A function to execute after the specified time in timer has elapsed
     */
    func animationFisnished() {
        
        self.hasAnimationFinished = true
    }
    
    // MARK: - Update Circle
    
    /**
    Updates the circle to represent the new value
     
     - parameter end: The new value to represent
     - parameter from: Animate circle from this point
     - parameter removePreviousLayer: A Bool value defining if it removes the previous arc or adds a new one on top
     */
    func updateCircle(end: CGFloat, animate from: Float, removePreviousLayer: Bool) {
        
        //get the mid position of the view
        let X = self.bounds.midX
        let Y = self.bounds.midY
        let offset = -Double.pi / 2
        
        self.path = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: self.ringRadius, startAngle: (CGFloat(0 + offset)), endAngle: (CGFloat(Double(end) * (Double.pi * 2) + offset)), clockwise: true).cgPath
        
        if self.previousArc != nil && removePreviousLayer {
    
            self.previousArc?.removeFromSuperlayer()
            self.previousArc?.removeAllAnimations()
        }
        
        if self.hasAnimationFinished {
            
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(animationFisnished), userInfo: nil, repeats: false)
            
            //add a second cirlce representing the value we want
            self.previousArc = self.addOval(self.ringLineWidth, path: self.path!, strokeStart: (CGFloat(0 + offset)), strokeEnd: (CGFloat(Double(end) * (Double.pi * 2) + offset)), strokeColor: self.ringColor, fillColor: self.ringFillColor, shadowRadius: self.ringShadowRadius, shadowOpacity: self.ringShadowOpacity, shadowOffset: self.ringShadowOffset)
        
            //animate main circle
        
            AnimationHelper.animateCircle(from: from, toValue: Float(end), duration: TimeInterval(self.animationDuration), arc: self.previousArc!)
            
            self.hasAnimationFinished = false
        }
    }
}
