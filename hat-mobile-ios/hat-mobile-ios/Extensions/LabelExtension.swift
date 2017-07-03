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

extension UILabel {
    
    // MARK: - Create label
    
    /**
     Creates an UILabel according to the parameters passed
     
     - parameter frame: The desired frame of the UILabel
     - parameter text: The text to display on the UILabel
     - parameter textColor: The color of the text
     - parameter textAlignment: The alignment of the text
     - parameter font: The desired font for the text
     
     - returns: A formatted UILabel according to the parameters passed
     */
    func createLabel(frame: CGRect, text: String, textColor: UIColor, textAlignment: NSTextAlignment, font: UIFont?) -> UILabel {
        
        // create label to show in loading view
        self.frame = frame
        self.text = text
        self.numberOfLines = 0
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        
        return self
    }
}
