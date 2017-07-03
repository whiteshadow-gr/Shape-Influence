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

internal class PhotosHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - IBOutlets
    
    /// The header title
    @IBOutlet private weak var headerTitle: UILabel!
    
    /// The add image button
    @IBOutlet private weak var addImageButton: UIButton!
    
    // MARK: - Set Up
    
    /**
     Sets the desired title in the reusableView
     
     - parameter stringToShow: The string to show as title
     
     - returns: UICollectionReusableView
     */
    internal func setUp(stringToShow: String) -> UICollectionReusableView {
        
        self.headerTitle.text = stringToShow
        
        return self
    }
}
