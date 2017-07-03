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

/// A class responsible for handling the Data Offers Collection View cell
internal class DataOffersCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the imageView
    @IBOutlet private weak var imageView: UIImageView!
    
    /// An IBOutlet for handling the title UILabel
    @IBOutlet private weak var titleLabel: UILabel!
    /// An IBOutlet for handling the details UILabel
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var ringProgressBar: RingProgressCircle!
    
    // MARK: - Set up cell
    
    /**
     Sets up the cell to show the data we need
     
     - parameter cell: The cell to set up
     - parameter dataOffer: The data to set up the cell from
     
     - returns: An UICollectionViewCell already been set up
     */
    func setUpCell(cell: DataOffersCollectionViewCell, dataOffer: DataOfferObject, completion: ((UIImage) -> Void)?) -> UICollectionViewCell {
        
        cell.titleLabel.text = dataOffer.title
        cell.detailsLabel.text = dataOffer.shortDescription
        cell.imageView.image = dataOffer.image
        
        cell.ringProgressBar.ringColor = .white
        cell.ringProgressBar.ringRadius = 45
        cell.ringProgressBar.ringLineWidth = 4
        cell.ringProgressBar.animationDuration = 0.2
        cell.ringProgressBar.isHidden = true

        if dataOffer.image == nil {
            
            if let url = URL(string: dataOffer.illustrationURL) {
                
                cell.ringProgressBar.isHidden = false
                cell.imageView.downloadedFrom(
                    url: url,
                    userToken: self.userToken,
                    progressUpdater: updateProgressBar,
                    completion: {
                
                        cell.ringProgressBar.isHidden = true
                        if let image = cell.imageView.image {
                            
                            completion?(image)
                        } else {
                            
                            cell.imageView.image = UIImage(named: Constants.ImageNames.placeholderImage)
                            completion?(cell.imageView.image!)
                        }
                    }
                )
            } else {
                
                cell.ringProgressBar.isHidden = true
                cell.imageView.image = UIImage(named: Constants.ImageNames.placeholderImage)
                completion?(cell.imageView.image!)
            }
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(colorLiteralRed: 231 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1.0).cgColor
        
        return cell
    }
    
    func updateProgressBar(completion: Double) {
        
        print(completion)
        ringProgressBar.updateCircle(end: CGFloat(completion), animate: 0.2, removePreviousLayer: true)
    }
    
    // MARK: - Download image
    
    /**
     Downloads the offer image
     
     - parameter url: The url to connect to in order to get the image
     - parameter userToken: The user's token. Needed for authentication
     - parameter ringProgressBarToAnimate: The progress bar to animate, default value nil
     - parameter imageView: The image view to show the image
     - parameter completion: A completion handler to execute after the download has been completed
     */
    func downloadOfferImage(url: String, userToken: String, ringProgressBarToAnimate: RingProgressCircle? = nil, imageView: UIImageView, completion: @escaping (UIImage?) -> Void) {
        
        if let tempURL = URL(string: url) {
            
            imageView.downloadedFrom(
                url: tempURL,
                userToken: userToken,
                progressUpdater: { progress in
                                        
                    if ringProgressBarToAnimate != nil {
                        
                        let completion = Float(progress)
                        ringProgressBarToAnimate?.updateCircle(end: CGFloat(completion), animate: Float((ringProgressBarToAnimate?.endPoint)!), removePreviousLayer: false)
                    }
                },
                completion: {
                    
                    ringProgressBarToAnimate?.isHidden = false
                    completion(imageView.image)
                }
            )
        }
    }
    
    /**
     Formats the offer descripion as needed
     
     - parameter dataOfferDescription: The data offer object
     
     - returns: An NSMutableString with the description formated as needed
     */
    func formatOfferDescription(dataOfferDescription: String) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: "OFFER DESCRIPTION:\n\(dataOfferDescription)", attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 12)!])
    }
}
