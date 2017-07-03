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

import Foundation

// MARK: Extension

extension NSAttributedString {
    
    // MARK: - Combine 2 attributed strings
    
    /**
     Adds 2 attributed strings together
     
     - parameter attributedText: The second attributed string
     
     - returns: An attributed string based on the string that called this method and the string passed as parameter
     */
    func combineWith(attributedText: NSAttributedString) -> NSAttributedString {
        
        let combination = NSMutableAttributedString()
        
        combination.append(self)
        combination.append(attributedText)
        
        return combination
    }
}
