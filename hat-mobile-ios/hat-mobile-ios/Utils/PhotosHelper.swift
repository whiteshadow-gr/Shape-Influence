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

import Photos

// MARK: Class

/// A class responsible for all photo related methods such as saving a photo, creating an album etc.
internal class PhotosHelper: NSObject {
    
    // MARK: - Variables

    /// The album name to create
    private static let albumName: String = "HAT"
    /// A signletone instance
    static let sharedInstance: PhotosHelper = PhotosHelper()
    
    /// The asset collection
    private var assetCollection: PHAssetCollection?
    
    // MARK: - Initialisers
    
    override init() {
        
        super.init()
        
        // get asset collection
        if let assetCollection = fetchAssetCollectionForAlbum() {
            
            self.assetCollection = assetCollection
            return
        }
        
        // authorize
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            
            PHPhotoLibrary.requestAuthorization({ (_: PHAuthorizationStatus) -> Void in
                
                //status
            })
        }
        
        // if authorised create album else request authorasation
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            self.createAlbum()
        } else {
            
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    // MARK: - Authorisation
    
    /**
     Request authorisation handler
     
     - parameter status: The returned authorisation status
     */
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    // MARK: - Create album
    
    /**
     Creates an album in the photo library
     */
    private func createAlbum() {
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: PhotosHelper.albumName)})
        { success, error in
            
            if success {
                
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                
                print("error \(String(describing: error))")
            }
        }
    }
    
    // MARK: - Fetch collection
    
    /**
     Fetches the assetCollection for the specified album
     
     - returns: PHAssetCollection
     */
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", PhotosHelper.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject: AnyObject = collection.firstObject {
            
            return firstObject as? PHAssetCollection
        }
        return nil
    }
    
    // MARK: - Save image
    
    /**
     Saves the image to the photo library
     
     - parameter image: The image to save to the photo library
     */
    func saveImage(image: UIImage) {
        
        if assetCollection == nil {
            
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection!)
            albumChangeRequest?.addAssets([assetPlaceHolder!] as NSArray)
        },
                                               completionHandler: nil)
    }
}
