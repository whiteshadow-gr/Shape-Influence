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

import HatForIOS

// MARK: Class

/// The collection view cell class for data plugs screen
internal class DataPlugCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    /// The image for the data plug
    @IBOutlet private weak var dataPlugImage: UIImageView!
    /// The checkmark image for the data plug. It's hidden if it's not active
    @IBOutlet private weak var checkMarkImage: UIImageView!
    
    /// The title for the data plug
    @IBOutlet private weak var dataPlugTitleLabel: UILabel!
    /// Some details for the data plug
    @IBOutlet private weak var dataPlugDetailsLabel: UILabel!
    
    // MARK: - Set up cell
    
    /**
     Sets up a cell according to our needs
     
     - parameter cell: The UICollectionViewCell to set up
     - parameter indexPath: The index path of the cell
     - parameter dataPlug: The HATDataPlugObject to take the values from
     - parameter orientation: The current orientation of the phone
     
     - returns: An UICollectionViewCell
     */
    class func setUp(cell: DataPlugCollectionViewCell, indexPath: IndexPath, dataPlug: HATDataPlugObject, orientation: UIInterfaceOrientation) -> UICollectionViewCell {
        
        // Configure the cell
        cell.dataPlugTitleLabel.text = dataPlug.name
        cell.dataPlugDetailsLabel.text = dataPlug.description
        cell.dataPlugImage.downloadedFrom(url: URL(string: dataPlug.illustrationUrl)!, userToken: userToken, progressUpdater: nil, completion: nil)
        cell.checkMarkImage.isHidden = !dataPlug.showCheckMark
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
            if (indexPath.row % 4 == 0) || (indexPath.row % 3 == 0) {
                
                return .rumpelVeryLightGray
            }
        } else {
            
            // create this zebra like color based on the index of the cell
            if indexPath.row % 2 == 0 {
                
                return .rumpelVeryLightGray
            }
        }
        
        return .white
    }
}
