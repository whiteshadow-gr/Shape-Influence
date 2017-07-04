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

/// The collection view cell class for data plugs screen
internal class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    /// The service's image
    @IBOutlet private weak var serviceImageView: UIImageView!
    
    /// The name of the service
    @IBOutlet private weak var serviceNameLabel: UILabel!
    /// The description of the service
    @IBOutlet private weak var serviceDescriptionLabel: UILabel!
    
    // MARK: - Set up cell
    
    /**
     Sets up a cell according to our needs
     
     - parameter cell: The UICollectionViewCell to set up
     - parameter indexPath: The index path of the cell
     - parameter object: The HomeScreenObject to take the values from
     - parameter orientation: The current orientation of the phone
     
     - returns: An UICollectionViewCell
     */
    class func setUp(cell: HomeCollectionViewCell, indexPath: IndexPath, object: HomeScreenObject, orientation: UIInterfaceOrientation) -> UICollectionViewCell {
        
        // Configure the cell
        cell.serviceNameLabel.text = object.serviceName
        cell.serviceDescriptionLabel.text = object.serviceDescription
        cell.serviceImageView.image = object.serviceImage
        cell.backgroundColor = self.backgroundColorOfCellForIndexPath(indexPath, in: orientation)
        
        // return cell
        return cell
    }
    
    // MARK: - Decide background color
    
    /**
     Decides the colof of the cell based on the index path and the device orientation
     
     - parameter indexPath: The index path of the cell
     - parameter orientation: The device current orientation
     
     - returns: The color of the cell based on the index path and the device orientation
     */
    private class func backgroundColorOfCellForIndexPath(_ indexPath: IndexPath, in orientation: UIInterfaceOrientation) -> UIColor {
        
        if orientation.isPortrait {
            
            // create this zebra like color based on the index of the cell
            if indexPath.row % 4 == 0 {
                
                return .shapeInfluencePinkLight
            } else if indexPath.row % 4 == 1 {
                
                return .shapeInfluencePinkLighter
            } else if indexPath.row % 4 == 2 {
                
                return .shapeInfluencePinkLighter
            }
            
            return .shapeInfluencePinkLight
        } else {
            
            // create this zebra like color based on the index of the cell
            if indexPath.row % 6 == 0 {
                
                return .shapeInfluencePinkLight
            } else if indexPath.row % 6 == 3 {
                
                return .shapeInfluencePinkLighter
            } else if indexPath.row % 6 == 2 {
                
                return .shapeInfluencePinkLight
            }
            
            return .shapeInfluencePinkLighter
        }
    }
}
