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

/// A class responsible for the profile picture UIViewController of the PHATA section
internal class PhataPictureViewController: UIViewController, UserCredentialsProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PhotoPickerDelegate, SelectedPhotosProtocol {

    // MARK: - Protocol's Variables
    
    /// User's selected files
    var selectedFiles: [FileUploadObject] = []
    
    /// User's selected photos
    var selectedPhotos: [UIImage] = []
    
    // MARK: - Variables
    
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    private var images: [FileUploadObject] = []
    
    /// The selected image file to view full screen
    private var selectedFileToView: FileUploadObject?
    
    /// The Photo picker used to upload a new photo
    private let photoPicker: PhotosHelperViewController = PhotosHelperViewController()
    
    /// User's profile passed on from previous view controller
    var profile: HATProfileObject?
    
    // MARK: - IBoutlets

    /// An IBOutlet for handling the image view
    @IBOutlet private weak var imageView: UIImageView!
    
    /// An IBOutlet for handling the custom switch
    @IBOutlet private weak var customSwitch: CustomSwitch!
    
    /// An IBOutlet for handling the collectionView
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - IBActions
    
    /**
     Sets the isPrivate according to the value of the switch
     
     - parameter sender: The object that calls this function
     */
    @IBAction func customSwitchAction(_ sender: Any) {
        
        self.profile?.data.facebookProfilePhoto.isPrivate = !(self.customSwitch.isOn)
        if (profile?.data.isPrivate)! && self.customSwitch.isOn {
            
            profile?.data.isPrivate = false
        }
    }
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select options", message: "Select from where to upload image", preferredStyle: .actionSheet)
        
        // create alert actions
        let cameraAction = UIAlertAction(title: "Take photo", style: .default, handler: { [unowned self] (_) -> Void in
            
            let photoPickerContorller = self.photoPicker.presentPicker(sourceType: .camera)
            self.present(photoPickerContorller, animated: true, completion: nil)
        })
        
        let libraryAction = UIAlertAction(title: "Choose from library", style: .default, handler: { [unowned self] (_) -> Void in
            
            let photoPickerContorller = self.photoPicker.presentPicker(sourceType: .photoLibrary)
            self.present(photoPickerContorller, animated: true, completion: nil)
        })
        
        let selectFromHATAction = UIAlertAction(title: "Choose from HAT", style: .default, handler: { [unowned self] (_) -> Void in
            
            self.performSegue(withIdentifier: Constants.Segue.profileToHATPhotosSegue, sender: self)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addActions(actions: [cameraAction, libraryAction, selectFromHATAction, cancel])
        if let button = sender as? UIButton {
            
            alertController.addiPadSupport(sourceRect: button.frame, sourceView: button)
        }
        
        // present alert controller
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Sends the profile data to hat
     
     - parameter sender: The object that calls this function
     */
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.darkView = UIView(frame: self.view.frame)
        self.darkView.backgroundColor = .black
        self.darkView.alpha = 0.4
        
        self.view.addSubview(self.darkView)
        
        self.loadingView = UIView.createLoadingView(with: CGRect(x: (self.view?.frame.midX)! - 70, y: (self.view?.frame.midY)! - 15, width: 140, height: 30), color: .teal, cornerRadius: 15, in: self.view, with: "Updating profile...", textColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 12)!)
        
        func tableExists(dict: Dictionary<String, Any>, renewedUserToken: String?) {
            
            HATPhataService.postProfile(
                userDomain: userDomain,
                userToken: userToken,
                hatProfile: self.profile!,
                successCallBack: {
                
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    _ = self.navigationController?.popViewController(animated: true)
                },
                errorCallback: {error in
                    
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                }
            )
        }
        
        HATAccountService.checkHatTableExistsForUploading(
            userDomain: userDomain,
            tableName: Constants.HATTableName.Profile.name,
            sourceName: Constants.HATTableName.Profile.source,
            authToken: userToken,
            successCallback: tableExists,
            errorCallback: {[weak self] _ in
            
                if let weakSelf = self {
                    
                    weakSelf.loadingView.removeFromSuperview()
                    weakSelf.darkView.removeFromSuperview()
                }
            }
        )
    }
    
    // MARK: - View controller methods
    
    func profileImageTapped() {
        
        let alertController = UIAlertController(title: "Options", message: "Please select one option", preferredStyle: .actionSheet)
        
        // create alert actions
        let removeAction = UIAlertAction(title: "Remove profile photo", style: .default, handler: { [unowned self] (_) -> Void in
            
            self.imageView.image = UIImage(named: Constants.ImageNames.placeholderImage)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addActions(actions: [removeAction, cancel])
        alertController.addiPadSupport(sourceRect: self.imageView.frame, sourceView: self.imageView)
        
        // present alert controller
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func handleLongTapGesture(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
            
        case .began:
            
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            
            self.collectionView.endInteractiveMovement()
        default:
            
            self.collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imageView.isUserInteractionEnabled = true
        let recogniser = UITapGestureRecognizer()
        recogniser.addTarget(self, action: #selector(profileImageTapped))
        self.imageView.addGestureRecognizer(recogniser)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTapGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        
        if self.profile == nil {
            
            self.profile = HATProfileObject()
        }
        
        self.customSwitch.isOn = !((profile?.data.facebookProfilePhoto.isPrivate)!)
        
        DispatchQueue.main.async {
            
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        }
        
        func failed(error: HATError) {
            
            // log error
            _ = CrashLoggerHelper.hatErrorLog(error: error)
            self.collectionView.isHidden = true
        }
        
        func success(filesReceived: [FileUploadObject], newToken: String?) {
            
            for file in filesReceived {
                
                if file.tags.contains("photo") {
                    
                    self.images.append(file)
                }
            }
            
            self.collectionView.reloadData()
        }
        
        // search for available files on hat
        HATFileService.searchFiles(userDomain: userDomain, token: userToken, successCallback: success, errorCallBack: failed)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Collection view
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.Segue.profileImageHeader, for: indexPath) as? PhotosHeaderCollectionReusableView {
            
            return headerView.setUp(stringToShow: "My Profile Photos")
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.Segue.profileImageHeader, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tempItem = self.images[sourceIndexPath.row]
        
        self.images.remove(at: sourceIndexPath.row)
        self.images.insert(tempItem, at: destinationIndexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Segue.profilePictureCell, for: indexPath) as? PhotosCollectionViewCell
        
        return (cell?.setUpCell(userDomain: userDomain, userToken: userToken, files: self.images, indexPath: indexPath, completion: { [weak self] image in
            
            cell?.cropImage()
            
            self?.images[indexPath.row].image = image
        }))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedFileToView = self.images[indexPath.row]
        self.performSegue(withIdentifier: Constants.Segue.profilePhotoToFullScreenPhotoSegue, sender: self)
    }
    
    // MARK: - Image picker methods
    
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    func didChooseImageWithInfo(_ info: [String : Any]) {
        
        func addFileToImages(file: FileUploadObject) {
            
            self.images.append(file)
            
            self.collectionView.isHidden = false
        }
        
        photoPicker.handleUploadImage(info: info, completion: addFileToImages, callingViewController: self, fromReference: self.photoPicker)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PhotoFullScreenViewerViewController {
            
            weak var destinationVC = segue.destination as? PhotoFullScreenViewerViewController
            
            destinationVC?.file = self.selectedFileToView
            destinationVC?.image = self.selectedFileToView?.image
            destinationVC?.isImageForProfile = true
            destinationVC?.profileViewControllerDelegate = self
        } else if segue.destination is PhotoViewerViewController {
            
            weak var destinationVC = segue.destination as? PhotoViewerViewController
            
            destinationVC?.selectedPhotosDelegate = self
            destinationVC?.allowsMultipleSelection = true
        }
    }
    
    // MARK: - Delegate functions
    
    func setImageAsProfileImage(image: UIImage) {
        
        self.imageView.image = image
    }
    
    func setImageAsProfileImage(file: FileUploadObject) {
        
        func updateProfileImage() {
            
        }
        
        if file.image != nil {
            
            self.imageView.image = file.image
            updateProfileImage()
        } else {
            
            if let imageURL: URL = URL(string: Constants.HATEndpoints.fileInfoURL(fileID: file.fileID, userDomain: userDomain)) {
                
                self.imageView.downloadedFrom(url: imageURL, userToken: userToken, progressUpdater: nil, completion: updateProfileImage)
            }
        }
    }
}
