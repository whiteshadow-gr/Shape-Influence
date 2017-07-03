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

/// A class responsible for the full screen viewer UIViewController
internal class PhotoFullScreenViewerViewController: UIViewController, UserCredentialsProtocol, UIScrollViewDelegate {
    
    // MARK: - Variables
    
    /// The image URL to download, passed on from previous view controller
    var imageURL: String?
    
    /// The file object, passed on from previous view controller
    var file: FileUploadObject?
    
    /// The image, passed on from previous view controller
    var image: UIImage?
    
    weak var profileViewControllerDelegate: PhataPictureViewController?
    
    /// A Bool value to determine if the image is shown is from profile pictures
    var isImageForProfile: Bool = false
    /// A Bool value to determine of the ui is visible or not
    private var isUIHidden: Bool = false
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the image view
    @IBOutlet private weak var imageView: UIImageView!
    
    /// An IBOutlet for handling the delete button
    @IBOutlet private weak var deleteButton: UIButton!
    /// An IBOutlet for handling the set image as profilel image button
    @IBOutlet private weak var setImageAsProfileImageButton: UIButton!
    
    /// An IBOutlet for handling the ring progress bar
    @IBOutlet private weak var ringProgressBar: RingProgressCircle!
    
    /// An IBOutlet for handling the scrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - IBActions

    /**
     Sets image as profile image
     
     - parameter sender: The object that called this method
     */
    @IBAction func setImageAsProfileImageAction(_ sender: Any) {
        
        if self.image != nil {
            
            profileViewControllerDelegate?.setImageAsProfileImage(image: image!)
        } else {
            
            profileViewControllerDelegate?.setImageAsProfileImage(file: file!)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Deletes the image visible
     
     - parameter sender: The object that called this method
     */
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        if file != nil {
            
            func success(isSuccess: Bool, renewedUserToken: String?) {
                
                // refresh user token
                _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
                
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            func fail(error: HATError) {
                
                _ = CrashLoggerHelper.hatErrorLog(error: error)
            }
            
            func delete() {
                
                HATFileService.deleteFile(fileID: file!.fileID, token: self.userToken, userDomain: self.userDomain, successCallback: success, errorCallBack: fail)
            }
            
            if (file?.tags.contains("notes"))! {
                
                self.createClassicAlertWith(alertMessage: "This photo is attached to a notable, removing it will remove the image in the note as well", alertTitle: "Warning", cancelTitle: "Cancel", proceedTitle: "Delete", proceedCompletion: delete, cancelCompletion: {})
            } else {
                
                delete()
            }
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideUI))
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(gesture)

        self.ringProgressBar.ringRadius = 20
        self.ringProgressBar.animationDuration = 0.2
        self.ringProgressBar.ringLineWidth = 4
        self.ringProgressBar.ringColor = .white
        
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.setImageAsProfileImageButton.isHidden = !self.isImageForProfile
        
        if self.image != nil && self.image != UIImage(named: Constants.ImageNames.placeholderImage) {
            
            self.imageView.image = self.image!
        } else  if self.file != nil {
            
            self.ringProgressBar.isHidden = false
            
            self.imageView!.downloadedFrom(
                url: URL(string: Constants.HATEndpoints.fileInfoURL(fileID: file!.fileID, userDomain: self.userDomain))!,
                userToken: userToken,
                progressUpdater: {progress in
                
                    let completion = Float(progress)
                    self.ringProgressBar.updateCircle(end: CGFloat(completion), animate: Float(self.ringProgressBar.endPoint), removePreviousLayer: false)
                },
                completion: {
                    
                    self.ringProgressBar.isHidden = true
                }
            )
        } else if self.imageURL != nil {
            
            let url = URL(string: self.imageURL!)
            
            self.ringProgressBar.isHidden = false
            
            self.imageView.downloadedFrom(
                url: url!,
                userToken: userToken,
                progressUpdater: {progress in
                
                    let completion = Float(progress)
                    self.ringProgressBar.updateCircle(end: CGFloat(completion), animate: Float(self.ringProgressBar.endPoint), removePreviousLayer: false)
                },
                completion: {
                    
                    self.deleteButton.isHidden = true
                    self.deleteButton = nil
                    self.ringProgressBar.isHidden = true
                }
            )
        }
        
        self.view.backgroundColor = .black
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Hide UI
    
    /**
     Hides the navigation bar, tab bar and delete button
     */
    @objc
    private func hideUI() {
        
        self.navigationController?.setNavigationBarHidden(!(self.isUIHidden), animated: true)
        self.tabBarController?.tabBar.isHidden = !(self.isUIHidden)
        self.tabBarController?.hidesBottomBarWhenPushed = !(self.isUIHidden)
        if self.deleteButton != nil {
            
            self.deleteButton.isHidden = !(self.isUIHidden)
        }
        if self.setImageAsProfileImageButton != nil {
            
            self.setImageAsProfileImageButton.isHidden = !(self.isUIHidden)
        }
        self.isUIHidden = !(self.isUIHidden)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }

}
