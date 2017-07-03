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

/// The class responsible for the selected images to upload in the shareOptionsViewController
internal class ShareOptionsSelectedImageCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    /// The selected image to upload
    @IBOutlet private weak var selectedImage: UIImageView!
    
    /// A button to remove the image from uploading
    @IBOutlet private weak var cancelButton: UIButton!
    
    /// A ring progress circe bar to track progress of download
    @IBOutlet private weak var ringProgressCircle: RingProgressCircle!
    
    // MARK: - IBActions
    
    /**
     Removes the image from the uploading list
     
     - parameter sender: The object that called this method
     */
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.selectedImage.image = nil
    }
    
    // MARK: - Set up cell
    
    /**
     Sets up the cell according to the UIImage
     
     - parameter imagesToUpload: An array of UIImage objects
     - parameter imageLink: The URL of the image to download
     - parameter indexPath: The indexPath of cell to set up
     - parameter completion: A completion handler to execute after the image has been downloaded and the cell has been set up
     
     - returns: Returns an already set up cell according to the image
     */
    func setUpCell(imagesToUpload: [UIImage], imageLink: String, indexPath: IndexPath, completion: @escaping (UIImage) -> Void) -> UICollectionViewCell {
        
        // Configure the cell
        if !imagesToUpload.isEmpty {
            
            if imagesToUpload[0] != UIImage(named: Constants.ImageNames.placeholderImage) {
                
                self.selectedImage.image = imagesToUpload[indexPath.row]
                self.selectedImage.cropImage(width: self.frame.width, height: self.frame.height)
            } else if let url = URL(string: imageLink) {
                
                self.selectedImage.image = UIImage(named: Constants.ImageNames.placeholderImage)
                self.ringProgressCircle.isHidden = false
                self.ringProgressCircle.ringRadius = 10
                self.ringProgressCircle.ringLineWidth = 4
                self.ringProgressCircle.ringColor = .white
                
                self.selectedImage.downloadedFrom(
                    url: url,
                    userToken: userToken,
                    progressUpdater: { [weak self] progress in
                        
                        if self != nil {
                            
                            let completion = Float(progress)
                            self!.ringProgressCircle.updateCircle(end: CGFloat(completion), animate: Float((self!.ringProgressCircle.endPoint)), removePreviousLayer: false)
                        }
                    },
                    completion: { [weak self] in
                        
                        if let weakSelf = self {
                            
                            weakSelf.ringProgressCircle.isHidden = true
                            
                            if !imagesToUpload.isEmpty && weakSelf.selectedImage.image != nil {
                                
                                completion(weakSelf.selectedImage.image!)
                                weakSelf.selectedImage.cropImage(width: weakSelf.frame.width, height: weakSelf.frame.height)
                            }
                        }
                    }
                )
            }
        }
        
        return self
    }
}
