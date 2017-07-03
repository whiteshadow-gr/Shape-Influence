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

import Alamofire

// MARK: Extension

extension UIImageView {
    
    // MARK: - Download image

    /**
     Downloads an Image from a url and shows it in the imageview that called this method
     
     - parameter url: The url to download the image from
     - parameter userToken: The user's token
     - parameter mode: The content mode of the image, default value = scaleAspectFit
     - parameter progressUpdater: A function to execute in order to get the current progress of the download
     - parameter completion: A function to execute when the download has completed
     */
    public func downloadedFrom(url: URL, userToken: String, contentMode mode: UIViewContentMode = .scaleAspectFit, progressUpdater: ((Double) -> Void)?, completion: (() -> Void)?) {
        
        let headers = [Constants.Headers.authToken: userToken]
        self.contentMode = mode
        
        Alamofire.request(
            url,
            method: .get,
            parameters: nil,
            encoding: Alamofire.JSONEncoding.default,
            headers: headers).downloadProgress(
                closure: { progress in
            
                    progressUpdater?(progress.fractionCompleted)
            }).responseData(
                completionHandler: { [weak self] response in
            
                    guard let data = response.result.value else {
                        
                        completion?()
                        return
                    }
                    let image = UIImage(data: data)
                    
                    if let weakSelf = self {
                        
                        if image != nil {
                            
                            weakSelf.image = image
                        } else {
                            
                            weakSelf.image = UIImage(named: Constants.ImageNames.imageDeleted)
                        }
                    }
                    
                    completion?()
                }
        )

    }
    
    // MARK: - Crop image
    
    /**
     Crops image to the specified width and height
     
     - parameter width: The width of the cropped image
     - parameter height: The height of the cropped image
     */
    public func cropImage(width: CGFloat, height: CGFloat) {
        
        if self.image != nil {
            
            var rect = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            if Float((self.image?.size.width)!) > Float((self.image?.size.height)!) {
                
                print("image is landscape")
                
                rect = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
                let scale = height / (self.image?.size.height)!
                let newWidth = (self.image?.size.width)! * scale
                UIGraphicsBeginImageContext(CGSize(width: newWidth, height: height))
                self.image?.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: height))
            } else {
                
                print("image is portrait")
                
                rect = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
                let scale = width / (self.image?.size.width)!
                let newHeight = (self.image?.size.height)! * scale
                UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
                self.image?.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
            }
            
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.setLineWidth(1)
            context?.stroke(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let unwrapImage = newImage, let unwrapCGImage = unwrapImage.cgImage {
                
                let imageRef = unwrapCGImage.cropping(to: rect)
                if imageRef != nil {
                    
                    let croppedImage: UIImage = UIImage(cgImage: imageRef!)
                    self.image = croppedImage
                }
            }
        }
    }
}
