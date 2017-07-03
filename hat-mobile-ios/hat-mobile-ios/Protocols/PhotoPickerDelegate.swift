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

// MARK: Protocol

/// Provides delegate methods of the picker view
internal protocol PhotoPickerDelegate: class {
    
    // MARK: - Protocol's functions

    /**
     A function to execute when image has being selected
     
     - parameter info: A dictionary of type <String, Any> containing info about the selected image
     */
    func didChooseImageWithInfo(_ info: [String : Any])
    
    /**
     A function to execute when there is an error selecting an image
     
     - parameter image: The UIImage that produced the error
     - parameter error: The actual error
     - parameter contextInfo: Some more info about the error
     */
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
}
