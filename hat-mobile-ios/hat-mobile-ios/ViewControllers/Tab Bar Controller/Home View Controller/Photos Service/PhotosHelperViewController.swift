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

/// A class responsible for handling the photo picker
internal class PhotosHelperViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The photo picker delegate
    weak var delegate: PhotoPickerDelegate?
    /// The source type of the photo picker
    private var sourceType: UIImagePickerControllerSourceType?
    
    /// A loading ring progress bar used while uploading a new image
    private var loadingScr: LoadingScreenWithProgressRingViewController?
    
    /// A variable holding a reference to the image picker view used to present the photo library or camera
    private var imagePicker: UIImagePickerController?
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        self.loadingScr?.view.frame = CGRect(x: self.view.frame.midX - 75, y: self.view.frame.midY - 80, width: 150, height: 160)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Image picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.imagePicker?.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        delegate?.didChooseImageWithInfo(info)
        
        if image != nil && self.sourceType == .camera {
            
            PhotosHelper.sharedInstance.saveImage(image: image!)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func presentPicker(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.sourceType = sourceType
        self.sourceType = sourceType
        
        if sourceType == .photoLibrary {
            
            self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary)!
        }
        
        return self.imagePicker!
    }
    
    /**
     Shows the progress ring view controller whilst the image is being uploaded to hat
     */
    private func showProgressRing() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.loadingScr = LoadingScreenWithProgressRingViewController.customInit(completion: 0, from: storyboard)
        
        self.loadingScr!.view.createFloatingView(frame:CGRect(x: self.view.frame.midX - 75, y: self.view.frame.midY - 80, width: 150, height: 160), color: .teal, cornerRadius: 15)
        
        self.addViewController(self.loadingScr!)
    }
    
    // MARK: - Remove progress ring
    
    /**
     Removes the progress ring view controller on error or after the upload has been completed
     */
    private func removeProgressRing() {
        
        if self.loadingScr != nil {
            
            self.loadingScr?.removeFromParentViewController()
            self.loadingScr?.view.removeFromSuperview()
            self.loadingScr = nil
        }
    }
    
    // MARK: - Image picker methods
    
    func handleUploadImage(info: [String : Any], completion: @escaping (FileUploadObject) -> Void, callingViewController: UIViewController, fromReference: PhotosHelperViewController) {
        
        callingViewController.view.addSubview(fromReference.view)
        callingViewController.view.bringSubview(toFront: fromReference.view)
        fromReference.willMove(toParentViewController: callingViewController)
        
        if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) {
            
            self.showProgressRing()
            
            HATFileService.uploadFileToHATWrapper(
                token: self.userToken,
                userDomain: self.userDomain,
                fileToUpload: image,
                tags: ["iphone", "viewer", "photo"],
                progressUpdater: {progress in
                    
                    let endPoint = self.loadingScr?.getRingEndPoint()
                    self.loadingScr?.updateView(completion: progress, animateFrom: Float((endPoint)!), removePreviousRingLayer: false)
            },
                completion: {[weak self] (file, renewedUserToken) in
                    
                    self?.removeProgressRing()
                    
                    completion(file)
                    
                    // refresh user token
                    _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
                },
                errorCallBack: {[weak self] error in
                    
                    if self != nil {
                        
                        self?.removeProgressRing()
                        
                        self!.createClassicOKAlertWith(alertMessage: "There was an error with the uploading of the file, please try again later", alertTitle: "Upload failed", okTitle: "OK", proceedCompletion: {})
                        
                        _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                    }
                }
            )
        }
    }

}
