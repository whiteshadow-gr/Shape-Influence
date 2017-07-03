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

// MARK: Protocol

internal protocol SelectedPhotosProtocol: class {
    
    // MARK: - Variables

    /// User's selected photos
    var selectedPhotos: [UIImage] { get set }
    /// User's selected files
    var selectedFiles: [FileUploadObject] { get set }
    
    // MARK: - Functions
    
    /**
     Sets the images received in selectedPhotos variable
     
     - parameter images: An array of the user selected images
     */
    func setSelectedImages(images: [UIImage])
    /**
     Sets the files received in selectedFiles variable
     
     - parameter files: An array of the user selected files
     */
    func setSelectedFiles(files: [FileUploadObject])
}

// MARK: - Extension

extension SelectedPhotosProtocol {
    
    // MARK: - Set selected images
    
    func setSelectedImages(images: [UIImage]) {
        
        self.selectedPhotos = images
    }
    
    // MARK: - Set selected files
    
    func setSelectedFiles(files: [FileUploadObject]) {
        
        self.selectedFiles = files
    }
}
