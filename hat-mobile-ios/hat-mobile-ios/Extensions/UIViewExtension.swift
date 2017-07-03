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

// MARK: Extension

extension UIView {
    
    // MARK: - Create floating view
    
    /**
     Creates a pop up view to present it to the view controller
     
     - parameter frame: The frame of the view
     - parameter color: The background color of the view
     - parameter cornerRadius: The corner radius of the view
     */
    func createFloatingView(frame: CGRect, color: UIColor, cornerRadius: CGFloat) {
        
        // init loading view
        self.frame = frame
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
    }
    
    // MARK: - Create floating view
    
    /**
     Adds a floating view while fetching the data plugs
     
     - parameter frame: The frame of the view
     - parameter color: The background color of the view
     - parameter cornerRadius: The corner radius of the view
     - parameter view: The view to create the floating view to
     - parameter text: The text to display in the floating view
     - parameter textColor: The color of the text in the floating view
     - parameter font: The font of the text in the floating view
     */
    class func createLoadingView(with frame: CGRect, color: UIColor, cornerRadius: CGFloat, in view: UIView, with text: String, textColor: UIColor, font: UIFont) -> UIView {
        
        // init loading view
        let tempView = UIView()
        tempView.createFloatingView(frame: frame, color: color, cornerRadius: cornerRadius)
        
        let label = UILabel().createLabel(frame: CGRect(x: 8, y: 8, width: frame.width - 16, height: frame.height - 16), text: text, textColor: textColor, textAlignment: .center, font: font)
        
        // add label to loading view
        tempView.addSubview(label)
        
        // present loading view
        view.addSubview(tempView)
        
        return tempView
    }
    
    // MARK: - Create half circles
    
    /**
     Draws and applies a CAShapeLayer to mask the view, specifically draws a circle with the x y and radius values passed as arguments
     
     - parameter view: The view to add a layer to
     - parameter xOffset: the x point offset to add the overlay
     - parameter yOffset: the y point offset to add the overlay
     - parameter radius: the radius of the circle to draw
     
     - returns: The CAShapeLayer created for the view
     */
    func createOverlay(view: UIView, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> CAShapeLayer {
        
        let path = CGMutablePath()
        path.addRect(view.bounds)
        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.closeSubpath()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Release the path since it's not covered by ARC.
        view.layer.mask = maskLayer
        view.clipsToBounds = true
        
        return maskLayer
    }
    
    /**
     Draws and applies a CAShapeLayer to mask the view, respecting the previous mask layer, specifically draws a circle with the x y and radius values passed as arguments
     
     - parameter view: The view to add a layer to
     - parameter layer: The previous layer of the view
     - parameter xOffset: the x point offset to add the overlay
     - parameter yOffset: the y point offset to add the overlay
     - parameter radius: the radius of the circle to draw
     
     - returns: The CAShapeLayer created for the view
     */
    func createOverlay(view: UIView, layer: CAShapeLayer, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> CAShapeLayer {
        
        let path = CGMutablePath()
        path.addPath(layer.path!)
        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.closeSubpath()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Release the path since it's not covered by ARC.
        view.layer.mask = maskLayer
        view.clipsToBounds = true
        
        return maskLayer
    }
    
    /**
     Draws a dashed line in the UIView
     
     - parameter color: The color of the dashed line
     - parameter view: The UIView to add the dashed line to
     - parameter xPoint: The x Point to start drawing the dashed line
     - parameter yPoint: The y Point to start drawing the dashed line
     */
    func addDashedLine(color: UIColor = .lightGray, view: UIView, xPoint: CGFloat, yPoint: CGFloat) {
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: xPoint + 30, y: yPoint))
        path.addLine(to: CGPoint(x: view.frame.width - 20, y: yPoint))
        path.closeSubpath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = Constants.UIViewLayerNames.dashedLine
        shapeLayer.bounds = view.bounds
        shapeLayer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
    
    /**
     Draws a line in the UIView
     
     - parameter color: The color of the line
     - parameter view: The UIView to add the line to
     - parameter xPoint: The x Point to start drawing the line
     - parameter yPoint: The y Point to start drawing the line
     */
    func addLine(color: UIColor = .lightGray, view: UIView, xPoint: CGFloat, yPoint: CGFloat) {
        
        _ = view.layer.sublayers?.filter({ $0.name == Constants.UIViewLayerNames.line }).map({ $0.removeFromSuperlayer() })
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: xPoint, y: yPoint + 10))
        path.addLine(to: CGPoint(x: xPoint, y: view.bounds.maxY - 10))
        path.closeSubpath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = Constants.UIViewLayerNames.line
        shapeLayer.bounds = view.bounds
        shapeLayer.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = path
        
        view.layer.addSublayer(shapeLayer)
    }
    
    /**
     Transforms a UIView to a ticket like UIView
     */
    func drawTicketView() {
        
        self.layer.mask = nil
        
        _ = self.layer.sublayers?.filter({ $0.name == Constants.UIViewLayerNames.dashedLine }).map({ $0.removeFromSuperlayer() })
        
        let maskLayer = self.createOverlay(view: self, xOffset: -5, yOffset: self.bounds.origin.y + 20, radius: 20)
        let maskLayer2 = self.createOverlay(view: self, layer: maskLayer, xOffset: -5, yOffset: self.bounds.maxY - 20, radius: 20)
        
        self.addDashedLine(view: self, xPoint: -5, yPoint: self.bounds.minY + 18)
        
        let maskLayer3 = self.createOverlay(view: self, layer: maskLayer2, xOffset: self.bounds.maxX + 5, yOffset: self.bounds.origin.y + 20, radius: 20)
        _ = self.createOverlay(view: self, layer: maskLayer3, xOffset: self.bounds.maxX + 5, yOffset: self.bounds.maxY - 20, radius: 20)
        
        self.addDashedLine(view: self, xPoint: -5, yPoint: self.bounds.maxY - 18)
        
        //        self.stackView.layer.borderWidth = 2
        //        self.stackView.layer.borderColor = UIColor(colorLiteralRed: 231/255, green: 231/255, blue: 231/255, alpha: 1.0).cgColor
    }
}
