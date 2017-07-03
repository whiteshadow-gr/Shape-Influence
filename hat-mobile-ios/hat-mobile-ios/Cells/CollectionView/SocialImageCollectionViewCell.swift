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

/// The Social Image collection view cell class. Used in notables table view to show in which social networks is this note posted
internal class SocialImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the imageview of the cell
    @IBOutlet private weak var socialImage: UIImageView!
    
    // MARK: - Set image
    
    /**
     Sets up a cell based on the sharedOn String. If sharedOn is Facebook then the socialImageCell becomes the facebook image
     
     - parameter sharedOn: The string that shows which image to load
     */
    func setUpCell(_ sharedOn: String) -> UICollectionViewCell {
        
        // update the image of the cell accordingly
        if sharedOn == "facebook" {
            
            self.socialImage.image = UIImage(named: Constants.ImageNames.facebookImage)
        } else if sharedOn == "marketsquare" {
            
            self.socialImage.image = UIImage(named: Constants.ImageNames.marketsquareImage)
        } else if sharedOn == "twitter" {
            
            self.socialImage.image = UIImage(named: Constants.ImageNames.twitterImage)
        } else if sharedOn == "location" {
            
            self.socialImage.image = UIImage(named: Constants.ImageNames.gpsFilledImage)
        }
        
        // flip the image to appear correctly
        self.socialImage.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        //return the cell
        return self
    }
}
