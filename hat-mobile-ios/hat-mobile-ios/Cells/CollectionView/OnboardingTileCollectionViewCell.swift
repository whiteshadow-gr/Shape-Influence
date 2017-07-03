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

/// The collection view cell class for onboarding screen
internal class OnboardingTileCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the imageview of the hat providen in the cell
    @IBOutlet private weak var hatProviderImage: UIImageView!
    
    /// An IBOutlet for handling the title label of the cell
    @IBOutlet private weak var titleLabel: UILabel!
    /// An IBOutlet for handling the info label of the cell
    @IBOutlet private weak var infoLabel: UILabel!
    
    /// An IBOutlet for handling the sign up button
    @IBOutlet private weak var signUpButton: UIButton!
    
    // MARK: - Get Image
    
    /**
     Returns provider image, if any
     
     - returns: An optional UIImage
     */
    func getProviderImage() -> UIImage? {
        
        return self.hatProviderImage.image
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up a cell according to our needs
     
     - parameter cell: The UICollectionViewCell to set up
     - parameter indexPath: The index path of the cell
     - parameter hatProvider: The object to take the values from
     - parameter orientation: The current orientation of the phone
     
     - returns: An UICollectionViewCell
     */
    class func setUp(cell: OnboardingTileCollectionViewCell, indexPath: IndexPath, hatProvider: HATProviderObject, orientation: UIInterfaceOrientation) -> UICollectionViewCell {
        
        // set cell's color
        cell.backgroundColor = self.backgroundColorOfCellForIndexPath(indexPath, in: orientation)

        // set cell's title
        cell.titleLabel.text = hatProvider.name
        
        // set cell's description
        cell.infoLabel.text = self.createInfoStringFromData(hatProvider: hatProvider)
        
        cell.signUpButton.addBorderToButton(width: 1, color: .teal)
        
        // get image from url and set it to the image view
        if let url: URL = URL(string: "https://hatters.hubofallthings.com/assets" + hatProvider.illustration) {
            
            cell.hatProviderImage.downloadedFrom(url: url, userToken: userToken, progressUpdater: nil, completion: nil)
        }
        
        if hatProvider.price != 0 || hatProvider.kind.kind == "External" {
            
            cell.isUserInteractionEnabled = false
            
            DispatchQueue.main.async {
                
                let view = UIView(frame: cell.contentView.frame)
                view.alpha = 0.5
                view.backgroundColor = .gray
                cell.contentView.addSubview(view)
            }
        }
        
        // return cell
        return cell
    }
    
    // MARK: - Create description label
    
    /**
     Creates the info string based on the price availability and purchased hats
     
     - parameter hatProvider: The hatProvider object containing the values we need
     
     - returns: String containing the info to show
     */
    private class func createInfoStringFromData(hatProvider: HATProviderObject) -> String {
        
        // return the string to show to the info label according to the type of the hat provider
        if hatProvider.price == 0 {
            
            if hatProvider.available - hatProvider.purchased != 0 {
                
                return String(hatProvider.available - hatProvider.purchased) + " of " + String(hatProvider.available) + " remaining"
            } else {
                
                return "Coming soon"
            }
        } else if hatProvider.kind.kind == "External" {
            
            return "Coming soon"
        } else {
            
            let price: Double = Double(Double(hatProvider.price) / 100.0)
            
            return "£ " + String(price)
        }
    }
    
    // MARK: - Decide background color
    
    /**
     Decides the colof of the cell based on the index path and the device orientation
     
     - parameter indexPath: The index path of the cell
     - parameter orientation: The device current orientation
     
     - returns: The color of the cell based on the index path and the device orientation
     */
    private class func backgroundColorOfCellForIndexPath(_ indexPath: IndexPath, in orientation: UIInterfaceOrientation) -> UIColor {
        
        // check if device is in portrait mode, 3 tiles per row vs 2
        if orientation.isPortrait {
            
            // set the color of the cell accordingly based on the indexPath.row
            if indexPath.row % 4 == 0 || indexPath.row % 3 == 0 {
                
                return .rumpelVeryLightGray
            }
        } else {
            
            // set the color of the cell accordingly based on the indexPath.row
            if indexPath.row % 2 == 0 {
                
                return .rumpelVeryLightGray
            }
        }
        
        return .white
    }
}
