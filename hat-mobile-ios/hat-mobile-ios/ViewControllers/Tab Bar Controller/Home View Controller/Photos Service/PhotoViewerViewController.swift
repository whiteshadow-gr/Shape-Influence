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

internal class PhotoViewerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PhotoPickerDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The files, images, to show in the cells
    private var files: [FileUploadObject] = []
    
    /// The Photo picker used to upload a new photo
    private let photoPicker: PhotosHelperViewController = PhotosHelperViewController()
    
    /// The selected image file to view full screen
    private var selectedFileToView: FileUploadObject?
    
    weak var selectedPhotosDelegate: SelectedPhotosProtocol?
    
    private var selectedFiles: [FileUploadObject] = []
    
    /// A variable passed by another View Controller indicating the way of selecting photos
    var allowsMultipleSelection: Bool = false
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the collection view
    @IBOutlet private weak var collectionView: UICollectionView!
    
    /// An IBOutlet for handling the imageView
    @IBOutlet private weak var addFirstPhotoFileImageView: UIImageView!
    
    /// An IBOutlet for handling the add picture button
    @IBOutlet private weak var addPictureButtonOutlet: UIButton!
    
    // MARK: - IBActions

    /**
     Upload picture to hat
     
     - parameter sender: The object that called this method
     */
    @IBAction func addPictureButtonAction(_ sender: Any) {
        
        if self.selectedPhotosDelegate != nil {
            
            selectedPhotosDelegate?.setSelectedFiles(files: self.selectedFiles)
            self.navigationController?.popViewController(animated: true)
        } else {
            
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
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addActions(actions: [cameraAction, libraryAction, cancel])
            alertController.addiPadSupport(sourceRect: self.addPictureButtonOutlet.frame, sourceView: self.addPictureButtonOutlet)
            
            // present alert controller
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()

        photoPicker.delegate = self
        self.addPictureButtonOutlet.addBorderToButton(width: 1, color: .white)
        
        self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection
        
        if self.selectedPhotosDelegate != nil {
            
            self.addPictureButtonOutlet.setTitle("Done", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        func success(filesReceived: [FileUploadObject], userToken: String?) {
            
            if !filesReceived.isEmpty {
                
                self.collectionView.isHidden = false
                
                // save the files received
                if self.files != filesReceived {
                    
                    self.files.removeAll()
                    
                    for file in filesReceived {
                                                
                        if !file.tags.contains("photo") {
                            
                            var tempFile = file
                            tempFile.tags.append("photo")
                            HATFileService.updateParametersOfFile(
                                fileID: tempFile.fileID,
                                fileName: tempFile.name,
                                token: userToken!,
                                userDomain: userDomain,
                                tags: tempFile.tags,
                                completion: {[weak self] file2 in
                                
                                    if self != nil {
                                        
                                        var tempFile2 = file2
                                        tempFile2.0.image = UIImage(named: Constants.ImageNames.placeholderImage)
                                        self!.files.append(tempFile2.0)
                                    }
                                },
                                errorCallback: {error in
                                
                                    _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                                }
                            )
                        } else {
                            
                            var tempFile = file
                            tempFile.image = UIImage(named: Constants.ImageNames.placeholderImage)
                            self.files.append(tempFile)
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
            } else {
                
                self.files = []
                self.collectionView.reloadData()
                self.collectionView.isHidden = true
            }
            
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: userToken)
        }
        
        func failed(error: HATError) {
            
            // log error
            _ = CrashLoggerHelper.hatErrorLog(error: error)
            self.collectionView.isHidden = true
        }
        
        // search for available files on hat
        HATFileService.searchFiles(userDomain: userDomain, token: userToken, successCallback: success, errorCallBack: failed)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
       NetworkHelper.stopBackgroundNetworkTasks()
    }
    
    // MARK: - Image picker methods
    
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    func didChooseImageWithInfo(_ info: [String : Any]) {
        
        func addFileToImages(file: FileUploadObject) {
            
            self.files.append(file)
            self.collectionView.isHidden = false
        }
        
        photoPicker.handleUploadImage(info: info, completion: addFileToImages, callingViewController: self, fromReference: self.photoPicker)
    }
    
    // MARK: - UICollectionView methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIDs.photosCell, for: indexPath) as? PhotosCollectionViewCell
        
        return (cell?.setUpCell(userDomain: userDomain, userToken: userToken, files: self.files, indexPath: indexPath, completion: { [weak self] image in
            
            cell?.cropImage()

            self?.files[indexPath.row].image = image
        }))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.allowsMultipleSelection {
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.contentView.layer.borderWidth = 3.0
            cell?.contentView.layer.borderColor = UIColor.teal.cgColor
            
            self.selectedFiles.append(self.files[indexPath.row])
        } else {
            
            self.selectedFileToView = self.files[indexPath.row]
            self.performSegue(withIdentifier: Constants.Segue.fullScreenPhotoViewerSegue, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.layer.borderWidth = 3.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        
        for (index, file) in self.files.enumerated() where file == self.files[indexPath.row] {
            
            self.selectedFiles.remove(at: index)
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return PhotosCollectionViewCell.calculateCellSize(collectionViewWidth: collectionView.frame.width)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PhotoFullScreenViewerViewController {
            
            weak var destinationVC = segue.destination as? PhotoFullScreenViewerViewController
            
            destinationVC?.file = self.selectedFileToView
            destinationVC?.image = self.selectedFileToView?.image
        }
    }

}
