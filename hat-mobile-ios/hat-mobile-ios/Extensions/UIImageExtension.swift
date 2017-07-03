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

extension UIImage {
    
    // MARK: - Resized UIImage
    
    /**
     Resize UIImage based on maximum allowed size
     
     - parameter fileSize: The current file size of the UIImage
     - parameter maximumSize: The maxium allowed file size

     - returns: The resized UIImage
     */
    func resized(fileSize: Float, maximumSize: Float) -> UIImage? {
        
        let percentage = CGFloat(maximumSize / fileSize)
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /**
     Resize UIImage based on width
     
     - parameter width: The width to resize this UIImage
     
     - returns: The resized UIImage
     */
    func resized(toWidth width: CGFloat) -> UIImage? {
        
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
