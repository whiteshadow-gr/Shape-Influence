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

extension UIButton {
    
    // MARK: - Extension's functions
    
    /**
     adds a border to the button
     
     - parameter width: The width as a CGFloat
     - parameter color: The color of the border
     */
    public func addBorderToButton(width: CGFloat, color: UIColor) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
