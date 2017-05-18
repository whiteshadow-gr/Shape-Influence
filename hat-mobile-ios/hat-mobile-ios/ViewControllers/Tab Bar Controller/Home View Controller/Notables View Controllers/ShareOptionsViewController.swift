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

import SafariServices
import HatForIOS

// MARK: Class

/// The share options view controller
class ShareOptionsViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate, PhotoPickerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SendLocationDataDelegate, UserCredentialsProtocol {
    
    func locationDataReceived(latitude: Double, longitude: Double, accuracy: Double) {
        
        self.receivedNote?.data.locationData.latitude = latitude
        self.receivedNote?.data.locationData.longitude = longitude
        self.receivedNote?.data.locationData.accuracy = accuracy
    }

    // MARK: - Variables
    
    private var loadingScr: LoadingScreenWithProgressRingViewController?
    
    private let photosViewController = PhotosHelperViewController()
    
    /// An array of strings holding the selected social networks to share the note
    private var shareOnSocial: [String] = []
    
    /// An array of strings holding the available data plugs
    private var dataPlugs: [HATDataPlugObject] = []
    
    private var imagesToUpload: [UIImage] = []
    
    /// A variable holding the selected image from the image picker
    private var imageSelected: UIImageView = UIImageView()
    var selectedImage: UIImage?
    var selectedFileImage: FileUploadObject?
    
    /// A string passed from Notables view controller about the kind of the note
    var kind: String = "note"
    /// The previous title for publish button
    private var previousPublishButtonTitle: String? = nil
    
    /// the received note to edit from notables view controller
    var receivedNote: HATNotesData? = nil
    
    /// the cached received note to edit from notables view controller
    private var cachedIsNoteShared: Bool = false
    /// a bool value to determine if the user is editing an existing value
    var isEditingExistingNote: Bool = false
    /// a flag to define if the keyboard is visible
    private var isKeyboardVisible: Bool = false
    
    /// A reference to safari view controller in order to show or hide it
    private var safariVC: SFSafariViewController? = nil
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the public/private label
    @IBOutlet weak var publicLabel: UILabel!
    /// An IBOutlet for handling the public icon label
    @IBOutlet weak var publicImageLabel: UILabel!
    /// An IBOutlet for handling the share for... icon label
    @IBOutlet weak var shareImageLabel: UILabel!
    /// An IBOutlet for handling the share with label
    @IBOutlet weak var shareWithLabel: UILabel!
    /// An IBOutlet for handling the share for... label
    @IBOutlet weak var shareForLabel: UILabel!
    /// An IBOutlet for handling the durationSharedLabel
    @IBOutlet weak var durationSharedForLabel: UILabel!
    
    /// An IBOutlet for handling the public/private switch
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// An IBOutlet for handling the delete button
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    /// An IBOutlet for handling the facebook button
    @IBOutlet weak var facebookButton: UIButton!
    /// An IBOutlet for handling the twitter button
    @IBOutlet weak var twitterButton: UIButton!
    /// An IBOutlet for handling the marketsquare button
    @IBOutlet weak var marketsquareButton: UIButton!
    /// An IBOutlet for handling the publish button
    @IBOutlet weak var publishButton: UIButton!
    /// An IBOutlet for handling the add button
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    /// An IBOutlet for handling the action view
    @IBOutlet weak var actionsView: UIView!
    /// An IBOutlet for handling the shareForView
    @IBOutlet weak var shareForView: UIView!
    @IBOutlet weak var settingsContentView: UIView!
    
    /// An IBOutlet for handling the scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// An IBOutlet for handling the UITextView
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select options", message: "Select from where to upload image", preferredStyle: .actionSheet)
        
        // create alert actions
        let cameraAction = UIAlertAction(title: "Take photo", style: .default, handler: { [unowned self] (action) -> Void in
            
            let picker = self.photosViewController.presentPicker(sourceType: .camera)
            self.present(picker, animated: true, completion: nil)
        })
        
        let libraryAction = UIAlertAction(title: "Choose from library", style: .default, handler: { [unowned self] (action) -> Void in
            
            let picker = self.photosViewController.presentPicker(sourceType: .photoLibrary)
            self.present(picker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addActions(actions: [cameraAction, libraryAction, cancel])
        alertController.addiPadSupport(sourceRect: self.addButton.frame, sourceView: self.shareForView)
        
        // present alert controller
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addLocationButtonAction(_ sender: Any) {
        
        if self.receivedNote?.data.locationData.latitude != 0 && self.receivedNote?.data.locationData.longitude != 0 && self.receivedNote?.data.locationData.accuracy != 0 {
            
            self.receivedNote?.data.locationData.latitude = 0
            self.receivedNote?.data.locationData.longitude = 0
            self.receivedNote?.data.locationData.accuracy = 0
            
            self.addLocationButton.setImage(UIImage(named: "Add Location"), for: .normal)
        } else {
            
            self.performSegue(withIdentifier: "checkInSegue", sender: self)
        }
    }
    
    /**
     This function is called when the user touches the add media button
     
     - parameter sender: The object that called this function
     */
    @IBAction func addButtonAction(_ sender: Any) {
        
    }
    
    /**
     This function is called when the user touches the twitter button
     
     - parameter sender: The object that called this function
     */
    @IBAction func twitterButtonAction(_ sender: Any) {
        
        // change publish button settings
        self.changePublishButtonTo(title: "Please Wait..", userEnabled: false)
        
        // check if twitter is enabled
        self.isTwitterEnabled()
        
        // refresh twitter button based on the bool value if it is user interaction enabled
        self.refreshTwitterButton()
    }
    
    /**
     This function is called when the user touches the duration button
     
     - parameter sender: The object that called this function
     */
    @IBAction func shareForDurationAction(_ sender: Any) {
        
        self.textView.resignFirstResponder()
        // create alert controller
        let alertController = UIAlertController(title: "Share for...", message: "Select the duration you want this note to be shared for", preferredStyle: .actionSheet)
        
        // create alert actions
        let oneDayAction = UIAlertAction(title: "1 day", style: .default, handler: { [unowned self] (action) -> Void in
            
            self.updateShareOptions(buttonTitle: action.title!, byAdding: .day, value: 1)
        })
        
        let sevenDaysAction = UIAlertAction(title: "7 days", style: .default, handler: { [unowned self] (action) -> Void in
            
            self.updateShareOptions(buttonTitle: action.title!, byAdding: .day, value: 7)
        })
        
        let fourteenDaysAction = UIAlertAction(title: "14 days", style: .default, handler: { [unowned self] (action) -> Void in
            
            self.updateShareOptions(buttonTitle: action.title!, byAdding: .day, value: 14)
        })
        
        let oneMonthAction = UIAlertAction(title: "1 month", style: .default, handler: { [unowned self] (action) -> Void in
            
            self.updateShareOptions(buttonTitle: action.title!, byAdding: .month, value: 1)
        })
        
        let forEverAction = UIAlertAction(title: "Forever", style: .default, handler: { [unowned self] (action) -> Void in
            
            self.updateShareOptions(buttonTitle: action.title!, byAdding: nil, value: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // add those actions to the alert controller
        let actionsArray = [oneDayAction, sevenDaysAction, fourteenDaysAction, oneMonthAction, forEverAction, cancelButton]
        alertController.addActions(actions: actionsArray)
        alertController.addiPadSupport(sourceRect: self.durationSharedForLabel.frame, sourceView: self.shareForView)
        
        // present alert controller
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func changePublishButtonTo(title: String, userEnabled: Bool) {
        
        self.previousPublishButtonTitle = self.publishButton.titleLabel?.text
        
        // change button title to saving
        self.publishButton.setTitle(title, for: .normal)
        self.publishButton.isUserInteractionEnabled = userEnabled
        
        if !userEnabled {
            
            self.publishButton.alpha = 0.5
        } else {
            
            self.publishButton.alpha = 1.0
        }
    }
    
    func restorePublishButtonToPreviousState(isUserInteractionEnabled: Bool) {
        
        // change publish button back to default state
        self.publishButton.setTitle(self.previousPublishButtonTitle!, for: .normal)
        self.publishButton.isUserInteractionEnabled = isUserInteractionEnabled
        
        if isUserInteractionEnabled {
            
            self.publishButton.alpha = 1
        }
    }
    
    /**
     This function is called when the user touches the share button
     
     - parameter sender: The object that called this function
     */
    @IBAction func shareButton(_ sender: Any) {
        
        func post(token: String?) {
            
            // hide keyboard
            self.textView.resignFirstResponder()
            
            self.changePublishButtonTo(title: "Saving...", userEnabled: false)
            
            func defaultCancelAction() {
                
                // change publish button back to default state
                self.restorePublishButtonToPreviousState(isUserInteractionEnabled: true)
            }
            
            func postNote() {
                
                // save text
                self.receivedNote?.data.message = self.textView.text!
                
                HATNotablesService.postNote(userDomain: userDomain, userToken: userToken, note: self.receivedNote!, successCallBack: {[weak self] () -> Void in
                    
                    if self?.loadingScr != nil {
                        
                        self?.loadingScr?.removeFromParentViewController()
                        self?.loadingScr?.view.removeFromSuperview()
                    }
                    
                    if self != nil {
                        
                        _ = self!.navigationController?.popViewController(animated: true)
                    }
                })
            }
            
            // if note is shared and users have not selected any social networks to share show alert message
            if (self.receivedNote?.data.shared)! && ((self.receivedNote?.data.sharedOn)! == "") {
                
                self.createClassicOKAlertWith(alertMessage: "Please select at least one shared destination", alertTitle: "", okTitle: "OK", proceedCompletion: defaultCancelAction)
            }
            
            // not editing note
            if !isEditingExistingNote {
                
                if (receivedNote?.data.shared)! && self.imagesToUpload.count == 0 {
                    
                    self.createClassicAlertWith(alertMessage: "You are about to share your post. \n\nTip: to remove a note from the external site, edit the note and make it private.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "Share now", proceedCompletion: postNote, cancelCompletion: defaultCancelAction)
                } else {
                    
                    func proceed() {
                        
                        if self.imagesToUpload.count > 0 {
                            
                            self.showProgressRing()
                            
                            HATAccountService.uploadFileToHATWrapper(token: userToken, userDomain: userDomain, fileToUpload: self.imageSelected.image!, tags: ["iphone", "notes"], progressUpdater: {[weak self](completion) -> Void in
                                
                                if self != nil {
                                    
                                    self!.updateProgressRing(completion: completion)
                                }
                                }, completion: {[weak self](fileUploaded, renewedUserToken) -> Void in
                                    
                                    if let weakSelf = self {
                                        
                                        if (weakSelf.receivedNote?.data.shared)! {
                                            
                                            // do another call to make image public
                                            HATFileService.makeFilePublic(fileID: fileUploaded.fileID, token: weakSelf.userToken, userDomain: weakSelf.userDomain, successCallback: {(result) -> Void in return}, errorCallBack: {(error) -> Void in
                                                
                                                _ = CrashLoggerHelper.hatErrorLog(error: error)
                                            })
                                        }
                                        
                                        // add image to note
                                        weakSelf.receivedNote?.data.photoData.link = "https://" + weakSelf.userDomain + "/api/v2/files/content/" + fileUploaded.fileID
                                        
                                        // post note
                                        postNote()
                                    }
                                    
                                    // refresh user token
                                    if renewedUserToken != nil {
                                        
                                        _ = KeychainHelper.SetKeychainValue(key: "UserToken", value: renewedUserToken!)
                                    }
                                }, errorCallBack: {[weak self] (error) -> Void in
                                    
                                    if self != nil {
                                        
                                        if self?.loadingScr != nil {
                                            
                                            self?.loadingScr?.removeFromParentViewController()
                                            self?.loadingScr?.view.removeFromSuperview()
                                        }
                                        
                                        self!.createClassicOKAlertWith(alertMessage: "There was an error with the uploading of the file, please try again later", alertTitle: "Upload failed", okTitle: "OK", proceedCompletion: {})
                                        
                                        _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                                    }
                            })
                        } else {
                            
                            postNote()
                        }
                    }
                    
                    if (receivedNote?.data.shared)! {
                        
                        self.createClassicAlertWith(alertMessage: "You are about to share your post. \n\nTip: to remove a note from the external site, edit the note and make it private.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "Share now", proceedCompletion: proceed, cancelCompletion: defaultCancelAction)
                    } else {
                        
                       postNote() 
                    }
                }
            // else delete the existing note and post a new one
            } else {
                
                func proceedCompletion() {
                    
                    // delete note
                    HATNotablesService.deleteNote(id: (receivedNote?.id)!, tkn: userToken, userDomain: userDomain)
                    
                    if self.imagesToUpload.count > 0 {
                        
                        self.showProgressRing()
                        
                        HATAccountService.uploadFileToHATWrapper(token: userToken, userDomain: userDomain, fileToUpload: self.imageSelected.image!, tags: ["iphone", "notes"], progressUpdater: {[weak self](completion) -> Void in
                        
                            if self != nil {
                                
                                self!.updateProgressRing(completion: completion)
                            }
                        }, completion: {[weak self](fileUploaded, renewedUserToken) -> Void in
                        
                            if let weakSelf = self {
                                
                                if (weakSelf.receivedNote?.data.shared)! {
                                    
                                    // do another call to make image public
                                    HATFileService.makeFilePublic(fileID: fileUploaded.fileID, token: weakSelf.userToken, userDomain: weakSelf.userDomain, successCallback: {(result) -> Void in return}, errorCallBack: {(error) -> Void in
                                        
                                        _ = CrashLoggerHelper.hatErrorLog(error: error)
                                    })
                                } else {
                                    
                                    HATFileService.makeFilePrivate(fileID: fileUploaded.fileID, token: weakSelf.userToken, userDomain: weakSelf.userDomain, successCallback: {(result) -> Void in return}, errorCallBack: {(error) -> Void in
                                        
                                        _ = CrashLoggerHelper.hatErrorLog(error: error)
                                    })
                                }
                                
                                // add image to note
                                weakSelf.receivedNote?.data.photoData.link = "https://" + weakSelf.userDomain + "/api/v2/files/content/" + fileUploaded.fileID
                                
                                // post note
                                postNote()
                            }
                            
                            // refresh user token
                            if renewedUserToken != nil {
                                
                                _ = KeychainHelper.SetKeychainValue(key: "UserToken", value: renewedUserToken!)
                            }
                        }, errorCallBack: {[weak self](error) -> Void in
                            
                            if self != nil {
                                
                                if self?.loadingScr != nil {
                                    
                                    self?.loadingScr?.removeFromParentViewController()
                                    self?.loadingScr?.view.removeFromSuperview()
                                }
                                
                                self!.createClassicOKAlertWith(alertMessage: "There was an error with the uploading of the file, please try again later", alertTitle: "Upload failed", okTitle: "OK", proceedCompletion: {})
                                
                                _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                            }
                        })
                    } else {
                        
                        postNote()
                    }
                }
                
                // if note is shared and user has changed the text show alert message
                if cachedIsNoteShared && (receivedNote?.data.message != self.textView.text!) {
                    
                    self.createClassicAlertWith(alertMessage: "Your post would not be edited at the destination.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "OK", proceedCompletion: proceedCompletion, cancelCompletion: defaultCancelAction)
                    
                    // if note is shared show message
                } else if (receivedNote?.data.shared)! {
                    
                    self.createClassicAlertWith(alertMessage: "You are about to share your post. \n\nTip: to remove a note from the external site, edit the note and make it private.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "Share now", proceedCompletion: proceedCompletion, cancelCompletion: defaultCancelAction)
                } else {
                    
                    proceedCompletion()
                }
            }
        }
        
        // check if the token has expired
        HATAccountService.checkIfTokenExpired(token: userToken,
                                              expiredCallBack: self.checkIfReauthorisationIsNeeded(completion: post),
                                              tokenValidCallBack: post,
                                              errorCallBack: self.createClassicOKAlertWith)
    }
    
    func checkIfReauthorisationIsNeeded(completion: @escaping (String?) -> Void) -> (Void) -> Void {
        
        return {
            
            let authoriseVC = AuthoriseUserViewController()
            authoriseVC.view.frame = CGRect(x: self.view.center.x - 50, y: self.view.center.y - 20, width: 100, height: 40)
            authoriseVC.view.layer.cornerRadius = 15
            authoriseVC.completionFunc = completion
            
            // add the page view controller to self
            self.addChildViewController(authoriseVC)
            self.view.addSubview(authoriseVC.view)
            authoriseVC.didMove(toParentViewController: self)
            
            self.publishButton.setTitle("Please try again", for: .normal)
        }
    }
    
    /**
     This function is called when the user touches the delete button
     
     - parameter sender: The object that called this function
     */
    @IBAction func deleteButton(_ sender: Any) {
        
        func delete(token: String?) {
            
            // if not a previous note then nothing to delete
            if isEditingExistingNote {
                
                func proceedCompletion() {
                    
                    // delete note
                    HATNotablesService.deleteNote(id: (receivedNote?.id)!, tkn: userToken, userDomain: userDomain)
                    
                    //go back
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                // if note shared show message
                if cachedIsNoteShared {
                    
                    self.createClassicAlertWith(alertMessage: "Deleting a note that has already been shared will not delete it at the destination. \n\nTo remove a note from the external site, first make it private. You may then choose to delete it.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "Proceed", proceedCompletion: proceedCompletion, cancelCompletion: {})
                } else {
                    
                    proceedCompletion()
                }
            }
        }
        
        // check if the token has expired
        HATAccountService.checkIfTokenExpired(token: userToken,
                                              expiredCallBack: self.checkIfReauthorisationIsNeeded(completion: delete),
                                              tokenValidCallBack: delete,
                                              errorCallBack: self.createClassicOKAlertWith)
    }
    
    /**
     This function is called when the user switches the switch
     
     - parameter sender: The object that called this function
     */
    @IBAction func publicSwitchStateChanged(_ sender: Any) {
        
        // hide keyboard if active
        if self.textView.isFirstResponder {
            
            self.textView.resignFirstResponder()
        }
        
        func proceedCompletion() {
            
            // based on the switch state change the label accordingly
            if self.publicSwitch.isOn {
                
                // update the ui accordingly
                self.turnUIElementsOn()
                self.turnImagesOn()
                self.facebookButton.isUserInteractionEnabled = true
                self.twitterButton.isUserInteractionEnabled = true
                self.marketsquareButton.isUserInteractionEnabled = true
                self.receivedNote?.data.shared = true
            } else {
                
                // update the ui accordingly
                self.turnUIElementsOff()
                self.turnImagesOff()
                self.facebookButton.isUserInteractionEnabled = false
                self.twitterButton.isUserInteractionEnabled = false
                self.marketsquareButton.isUserInteractionEnabled = false
                self.receivedNote?.data.shared = false
                self.durationSharedForLabel.text = "Forever"
            }
            
            for view in self.settingsContentView.subviews {
                
                self.settingsContentView.bringSubview(toFront: view)
            }
        }
        
        func cancelCompletion() {
            
            self.publicSwitch.isOn = true
        }
        
        if cachedIsNoteShared && !self.publicSwitch.isOn {
            
            self.createClassicAlertWith(alertMessage: "This will remove your post at the shared destinations. \n\nWarning: any comments at the destinations would also be deleted.", alertTitle: "", cancelTitle: "Cancel", proceedTitle: "Proceed", proceedCompletion: proceedCompletion, cancelCompletion: cancelCompletion)
        } else {
            
            proceedCompletion()
        }
    }
    
    /**
     This function is called when the user touches the facebook image
     
     - parameter sender: The object that called this function
     */
    @IBAction func facebookButton(_ sender: Any) {
        
        // if button is enabled
        if self.facebookButton.isUserInteractionEnabled {
            
            // if button was selected deselect it and remove the button from the array
            if self.facebookButton.alpha == 1 {
                
                self.facebookButton.alpha = 0.4
                self.removeFromArray(string: "facebook")
                // else select it and add it to the array
            } else {
                
                func facebookTokenReceived(token: String, renewedUserToken: String?) {
                    
                    // refresh user token
                    if renewedUserToken != nil {
                        
                        _ = KeychainHelper.SetKeychainValue(key: "UserToken", value: renewedUserToken!)
                    }
                    
                    func successfulCallback(isActive: Bool) {
                        
                        if isActive {
                            
                            self.changePublishButtonTo(title: "Save", userEnabled: true)
                        } else {
                            
                            failedCallback()
                        }
                    }
                    
                    func failedCallback() {
                        
                        func noAction() {
                            
                            // if button was selected deselect it and remove the button from the array
                            if self.facebookButton.alpha == 1 {
                                
                                self.facebookButton.alpha = 0.4
                                self.removeFromArray(string: "facebook")
                                // else select it and add it to the array
                            } else {
                                
                                self.facebookButton.alpha = 1
                                self.shareOnSocial.append("facebook")
                                
                                // construct string from the array and save it
                                self.receivedNote?.data.sharedOn = (self.constructStringFromArray(array: self.shareOnSocial))
                            }
                            
                            self.changePublishButtonTo(title: "Save", userEnabled: true)
                        }
                        
                        func yesAction() {
                            
                            func successfullCallBack(dataPlugs: [HATDataPlugObject], renewedUserToken: String?) {
                                
                                for i in 0 ... dataPlugs.count - 1 {
                                    
                                    if dataPlugs[i].name == "facebook" {
                                        
                                        let url = "https://" + self.userDomain + "/hatlogin?name=Facebook&redirect=" + dataPlugs[i].url.replacingOccurrences(of: "dataplug", with: "hat/authenticate")
                                        
                                        self.safariVC = SFSafariViewController(url: URL(string: url)!)
                                        self.changePublishButtonTo(title: "Save", userEnabled: true)
                                        self.present(self.safariVC!, animated: true, completion: nil)
                                        self.claimOffer()
                                    }
                                }
                                
                                if renewedUserToken != nil {
                                    
                                    _ = KeychainHelper.SetKeychainValue(key: "UserToken", value: renewedUserToken!)
                                }
                            }
                            
                            HATDataPlugsService.getAvailableDataPlugs(succesfulCallBack: successfullCallBack, failCallBack: {(error) in
                                
                                _ = CrashLoggerHelper.dataPlugErrorLog(error: error)
                            })
                        }
                        
                        self.createClassicAlertWith(alertMessage: "You have to enable Facebook data plug before sharing on Facebook, do you want to enable now?", alertTitle: "Data plug not enabled", cancelTitle: "No", proceedTitle: "Yes", proceedCompletion: yesAction, cancelCompletion: noAction)
                    }
                    
                    HATFacebookService.isFacebookDataPlugActive(token: token, successful: successfulCallback, failed: {_ in failedCallback()})
                }
                
                self.publishButton.setTitle("Please Wait..", for: .normal)
                
                HATFacebookService.getAppTokenForFacebook(token: userToken, userDomain: userDomain, successful: facebookTokenReceived, failed: {[weak self] (error) in
                    
                    if self != nil {
                        
                        self!.createClassicOKAlertWith(alertMessage: "There was an error checking for data plug. Please try again later.", alertTitle: "Failed checking Data plug", okTitle: "OK", proceedCompletion: {})
                    }
                    
                    CrashLoggerHelper.JSONParsingErrorLogWithoutAlert(error: error)
                })
                
                self.facebookButton.alpha = 1
                shareOnSocial.append("facebook")
            }
            
            // construct string from the array and save it
            self.receivedNote?.data.sharedOn = self.constructStringFromArray(array: self.shareOnSocial)
        }
    }
    
    /**
     This function is called when the user touches the marketsquare image
     
     - parameter sender: The object that called this function
     */
    @IBAction func marketSquareButton(_ sender: Any) {
        
        // if button is enabled
        if self.marketsquareButton.isUserInteractionEnabled {
            
            // if button was selected deselect it and remove the button from the array
            if self.marketsquareButton.alpha == 1 {
                
                self.marketsquareButton.alpha = 0.4
                self.removeFromArray(string: "marketsquare")
                // else select it and add it to the array
            } else {
                
                self.claimOffer()
                self.marketsquareButton.alpha = 1
                shareOnSocial.append("marketsquare")
            }
            
            // construct string from the array and save it
            self.receivedNote?.data.sharedOn = self.constructStringFromArray(array: self.shareOnSocial)
        }
    }
    
    // MARK: - Image picker Controller
    
    func didFinishWithError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func didChooseImageWithInfo(_ info: [String : Any]) {
        
        if self.imagesToUpload.count > 0 {
            
            self.imagesToUpload.removeAll()
        }
        
        self.imageSelected.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        self.imagesToUpload.append(self.imageSelected.image!)
        self.collectionView.isHidden = false
        self.collectionView.reloadData()
    }
    
    // MARK: - Check if twitter is available
    
    /**
     Check if twitter data plug is enabled
     */
    private func isTwitterEnabled() {
        
        // check data plug
        func checkDataPlug(appToken: String, renewedUserToken: String?) {
            
            // refresh user token
            if renewedUserToken != nil {
                
                _ = KeychainHelper.SetKeychainValue(key: "UserToken", value: renewedUserToken!)
            }
            
            // data plug enabled, set up publish button accordingly
            func dataPlugIsEnabled(isActive: Bool) {
                
                if isActive {
                    
                    self.changePublishButtonTo(title: "Save", userEnabled: true)
                    self.publishButton.isUserInteractionEnabled = true
                } else {
                    
                    dataPlugIsNotEnabled()
                }
            }
            
            // data plug not enabled
            func dataPlugIsNotEnabled() {
                
                // reset twitter button
                func noAction() {
                    
                    self.refreshTwitterButton()
                    
                    self.changePublishButtonTo(title: "Save", userEnabled: true)
                }
                
                // set up data plug
                func yesAction() {
                    
                    func successfullCallBack(data: [HATDataPlugObject], renewedUserToken: String?) {
                        
                        for i in 0 ... data.count - 1 {
                            
                            if data[i].name == "twitter" {
                                
                                // construct twitter
                                let url = "https://" + userDomain + "/hatlogin?name=Twitter&redirect=" + data[i].url + "/authenticate/hat"
                                
                                self.restorePublishButtonToPreviousState(isUserInteractionEnabled: true)

                                // open safari
                                self.safariVC = SFSafariViewController(url: URL(string: url)!)
                                self.present(self.safariVC!, animated: true, completion: nil)
                                
                                // claim offer
                                self.claimOffer()
                            }
                        }
                    }
                    
                    // get available data plugs
                    HATDataPlugsService.getAvailableDataPlugs(succesfulCallBack: successfullCallBack, failCallBack: {(error) in
                    
                        _ = CrashLoggerHelper.dataPlugErrorLog(error: error)
                    })
                }
                
                // show an alert
                self.createClassicAlertWith(alertMessage: "You have to enable Twitter data plug before sharing on Twitter, do you want to enable now?", alertTitle: "Data plug not enabled", cancelTitle: "No", proceedTitle: "Yes", proceedCompletion: yesAction, cancelCompletion: noAction)
            }
            
            // check if twitter data plug is active
            HATTwitterService.isTwitterDataPlugActive(token: appToken, successful: dataPlugIsEnabled, failed: {_ in dataPlugIsNotEnabled()})
        }
        
        self.changePublishButtonTo(title: "Please Wait..", userEnabled: false)
        
        // get app token for twitter
        HATTwitterService.getAppTokenForTwitter(userDomain: userDomain, token: userToken, successful: checkDataPlug, failed: { [weak self] (error) in
            
            if self != nil {
                
                // if something wrong show error
                self!.createClassicOKAlertWith(alertMessage: "There was an error checking for data plug. Please try again later.", alertTitle: "Failed checking Data plug", okTitle: "OK", proceedCompletion: {})
                
                // reset ui
                self!.turnUIElementsOn()
            }
            
            CrashLoggerHelper.JSONParsingErrorLogWithoutAlert(error: error)
        })
    }
    
    // MARK: - Remove from array
    
    /**
     Removes from array the given string if found
     
     - parameter string: The string to remove from the array
     */
    private func removeFromArray(string: String) -> Void {
        
        // check in the array
        var found = false
        var index = 0
        
        repeat {
            
            if self.shareOnSocial[index] == string {
                
                // remove the string
                self.shareOnSocial.remove(at: index)
                found = true
            } else {
                
                index += 1
            }
        } while found == false
    }
    
    // MARK: - Construct string
    
    /**
     Combines an Array of strings in one string
     
     - parameter array: The array that has all the strings we want to combine
     - returns: A String
     */
    private func constructStringFromArray(array: [String]) -> String {
        
        // init a string
        var stringToReturn: String = ""
        
        // check if array is empty
        if array.count > 0 {
            
            // go through the array
            for item in 0...array.count - 1 {
                
                // add the string to the stringToReturn
                stringToReturn = stringToReturn.appending(array[item] + ",")
            }
        }
        
        // return the string
        return stringToReturn
    }
    
    // MARK: - Autogenerated
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.photosViewController.delegate = self
        
        // set title in the navigation bar
        self.navigationItem.title = self.kind.capitalized
        
        // set image fonts
        self.publicImageLabel.attributedText = NSAttributedString(string: "\u{1F512}", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 22)!])
        self.publicImageLabel.sizeToFit()
        self.shareImageLabel.attributedText = NSAttributedString(string: "\u{23F2}", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 22)!])
        self.shareImageLabel.sizeToFit()
        
        // setup text field
        self.textView.keyboardAppearance = .dark
        
        // add gesture recognizer to share For view
        let tapGestureToShareForAction = UITapGestureRecognizer(target: self, action: #selector (self.shareForDurationAction(_:)))
        tapGestureToShareForAction.cancelsTouchesInView = false
        self.shareForView.addGestureRecognizer(tapGestureToShareForAction)
        
        // add gesture recognizer to text view
        let tapGestureTextView = UITapGestureRecognizer(target: self, action: #selector (self.enableEditingTextView))
        tapGestureTextView.cancelsTouchesInView = false
        self.textView.addGestureRecognizer(tapGestureTextView)
        
        // change title in publish button
        self.publishButton.titleLabel?.minimumScaleFactor = 0.5
        self.publishButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // keep the green bar at the top
        self.view.bringSubview(toFront: actionsView)
        
        // if user is editing existing note set up the values accordingly
        if isEditingExistingNote {
            
            self.setUpUIElementsFromReceivedNote(self.receivedNote!)
            self.cachedIsNoteShared = (self.receivedNote?.data.shared)!
            if (self.receivedNote?.data.shared)! {
                
                self.publishButton.setTitle("Save", for: .normal)
            }
            if let unwrappedDate = self.receivedNote?.data.publicUntil {
                
                if unwrappedDate > Date() && self.receivedNote!.data.shared {
                    
                    self.durationSharedForLabel.text = FormatterHelper.formatDateStringToUsersDefinedDate(date: unwrappedDate, dateStyle: .short, timeStyle: .none)
                    self.shareForLabel.text = "Shared until"
                } else if self.receivedNote!.data.shared {
                    
                    self.durationSharedForLabel.text = FormatterHelper.formatDateStringToUsersDefinedDate(date: unwrappedDate, dateStyle: .short, timeStyle: .none)
                    self.shareForLabel.text = "Expired on"
                }
            }
            
            if self.selectedImage != nil {
                
                self.imageSelected.image = self.selectedImage
                self.imagesToUpload.append(self.imageSelected.image!)
                self.collectionView.isHidden = false
            }
            // else init a new value
        } else {
            
            self.receivedNote = HATNotesData()
            self.deleteButtonOutlet.isHidden = true
        }
        
        // save kind of note
        self.receivedNote?.data.kind = self.kind
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow2), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide2), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertForDataPlug), name: Notification.Name("dataPlugMessage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // add keyboard handling
        self.hideKeyboardWhenTappedAround()
        
        // if no text add a placeholder
        if (textView.text == "") {
            
            self.textView.textColor = .lightGray
            self.textView.text = "What's on your mind?"
        }
        
        if self.receivedNote?.data.locationData.accuracy != 0 && self.receivedNote?.data.locationData.latitude != 0 && self.receivedNote?.data.locationData.latitude != 0 {
            
            self.addLocationButton.setImage(UIImage(named: "gps filled"), for: .normal)
        }
    }
    
    func showProgressRing() {
        
        self.loadingScr = LoadingScreenWithProgressRingViewController.customInit(completion: 0, from: self.storyboard!)
        
        self.loadingScr!.view.createFloatingView(frame:CGRect(x: self.view.frame.midX - 75, y: self.view.frame.midY - 160, width: 150, height: 160), color: .teal, cornerRadius: 15)
        
        self.addViewController(self.loadingScr!)
    }
    
    func updateProgressRing(completion: Double) {
        
        self.loadingScr?.updateView(completion: completion, animateFrom: Float((self.loadingScr?.progressRing.endPoint)!), removePreviousRingLayer: false)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        self.loadingScr?.view.frame = CGRect(x: self.view.frame.midX - 75, y: self.view.frame.midY - 160, width: 150, height: 160)

        self.viewWillLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Safari View controller notification
    
    func showAlertForDataPlug(notif: Notification) {
        
        // if safari view controller not nil, hide it
        if safariVC != nil {
            
            safariVC?.dismiss(animated: true, completion: nil)
            self.publishButton.setTitle("Save", for: .normal)
            self.publishButton.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Setup UI functins
    
    /**
     Update the ui from the received note
     */
    private func setUpUIElementsFromReceivedNote(_ receivedNote: HATNotesData) {
        
        // add message to the text field
        self.textView.text = receivedNote.data.message
        // set public switch state
        self.publicSwitch.setOn(receivedNote.data.shared, animated: false)
        // if switch is on update the ui accordingly
        if self.publicSwitch.isOn {
            
            self.shareOnSocial = receivedNote.data.sharedOn.stringToArray()
            self.turnUIElementsOn()
            self.turnImagesOn()
        }
    }
    
    /**
     Turns on the ui elemets
     */
    private func turnUIElementsOn() {
        
        // enable share for view
        self.shareForView.isUserInteractionEnabled = true
        
        // show the duration shared label
        self.durationSharedForLabel.isHidden = false
        
        // set teal color
        let color: UIColor = .teal
        
        // set the text of the public label
        self.publicLabel.text = "Shared"
        // set the colors of the labels
        self.shareWithLabel.textColor = .black
        self.shareForLabel.textColor = .black
        
        // enable social images
        self.facebookButton.isUserInteractionEnabled = true
        self.twitterButton.isUserInteractionEnabled = true
        self.marketsquareButton.isUserInteractionEnabled = true
        
        // set image fonts
        self.publicImageLabel.attributedText = NSAttributedString(string: "\u{1F513}", attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 21)!])
        self.shareImageLabel.attributedText = NSAttributedString(string: "\u{23F2}", attributes: [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 21)!])
        
        if self.isEditingExistingNote {
            
            self.publishButton.setTitle("Save", for: .normal)
        } else {
            
            self.publishButton.setTitle("Share", for: .normal)
        }
    }
    
    /**
     Turns off the ui elemets
     */
    private func turnUIElementsOff() {
        
        // disable share for view
        self.shareForView.isUserInteractionEnabled = false
        
        // hide the duration shared label
        self.durationSharedForLabel.isHidden = true
        
        // set the text of the public label
        self.publicLabel.text = "Private"
        self.shareForLabel.text = "Share for..."
        // set the colors of the labels
        self.shareWithLabel.textColor = .lightGray
        self.shareForLabel.textColor = .lightGray
        
        // disable social images
        self.facebookButton.isUserInteractionEnabled = false
        self.twitterButton.isUserInteractionEnabled = false
        self.marketsquareButton.isUserInteractionEnabled = false
        
        // set image fonts
        self.publicImageLabel.attributedText = NSAttributedString(string: "\u{1F512}", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 21)!])
        self.shareImageLabel.attributedText = NSAttributedString(string: "\u{23F2}", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "SSGlyphish-Filled", size: 21)!])
        
        self.publishButton.setTitle("Save", for: .normal)
    }
    
    /**
     Turns on the images
     */
    private func turnImagesOn() {
        
        // check array for elements
        for socialName in self.shareOnSocial {
            
            // if facebook then enable facebook button
            if socialName == "facebook" {
                
                self.facebookButton.alpha = 1
            }
            //  enable marketsquare button
            if socialName == "marketsquare" {
                
                self.marketsquareButton.alpha = 1
            }
            //  enable marketsquare button
            if socialName == "twitter" {
                
                self.twitterButton.alpha = 1
            }
        }
    }
    
    /**
     Turns on the images
     */
    private func turnImagesOff() {
        
        // empty the array
        self.shareOnSocial.removeAll()
        // deselect buttons
        self.facebookButton.alpha = 0.4
        self.marketsquareButton.alpha = 0.4
        self.twitterButton.alpha = 0.4
    }
    
    private func refreshTwitterButton() {
        
        // if button is enabled
        if self.twitterButton.isUserInteractionEnabled {
            
            // if button was selected deselect it and remove the button from the array
            if self.twitterButton.alpha == 1 {
                
                self.twitterButton.alpha = 0.4
                self.removeFromArray(string: "twitter")
                // else select it and add it to the array
            } else {
                
                self.twitterButton.alpha = 1
                shareOnSocial.append("twitter")
            }
            
            // construct string from the array and save it
            self.receivedNote?.data.sharedOn = self.constructStringFromArray(array: self.shareOnSocial)
        }
    }
    
    private func updateShareOptions(buttonTitle: String, byAdding: Calendar.Component?, value: Int?) {
        
        self.durationSharedForLabel.text = buttonTitle
        if byAdding != nil && value != nil {
            
            self.receivedNote?.data.publicUntil = Calendar.current.date(byAdding: byAdding!, value: value!, to: Date())!
        }
        self.shareForLabel.text = "Share for..."
    }
    
    // MARK: - Keyboard handling
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow2(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        self.scrollView.contentInset.bottom = keyboardFrame.size.height
        
        let desiredOffset = CGPoint(x: 0, y: self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(desiredOffset, animated: true)
        self.isKeyboardVisible = true
    }
    
    func keyboardDidShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            
            self.actionsView.frame.origin.y = keyboardFrame.origin.y - self.actionsView.frame.height
        })
    }
    
    func keyboardWillHide2(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        self.actionsView.frame.origin.y = self.view.frame.height - self.actionsView.frame.height
        self.isKeyboardVisible = false
    }
    
    // MARK: - TextView Delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "What's on your mind?" {
            
            textView.attributedText = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            self.textView.textColor = .lightGray
            self.textView.text = "What's on your mind?"
        }
        
        self.textView.isEditable = false
    }
    
    @objc private func enableEditingTextView() {
        
        self.textView.isEditable = true
        
        textViewDidBeginEditing(self.textView)
        self.textView.becomeFirstResponder()
    }
    
    // MARK: - Claim offer
    
    /**
     Claims offer for data plug
     */
    private func claimOffer() {
        
        func failCallback(error: DataPlugError) {
            
            switch error {
            case .offerClaimed:
                
                break
            default:
                
                self.createClassicOKAlertWith(alertMessage: "There was a problem enabling offer. Please try again later", alertTitle: "Error enabling offer", okTitle: "OK", proceedCompletion: {
                
                    self.marketsquareButton.alpha = 0.4
                    self.removeFromArray(string: "marketsquare")
                })
            }
        }
        
        func success(appToken: String, renewedUserToken: String?) {
            
            HATDataPlugsService.ensureOfferDataDebitEnabled(offerID: "32dde42f-5df9-4841-8257-5639db222e41", succesfulCallBack: {_ in}, failCallBack: failCallback)(appToken)
        }
        
        HATService.getApplicationTokenFor(serviceName: "MarketSquare", userDomain: userDomain, token: userToken, resource: "https://marketsquare.hubofallthings.com", succesfulCallBack: success, failCallBack: {(error) in
            
            self.createClassicOKAlertWith(alertMessage: "There was a problem enabling offer. Please try again later", alertTitle: "Error enabling offer", okTitle: "OK", proceedCompletion: {})
            CrashLoggerHelper.JSONParsingErrorLogWithoutAlert(error: error)
        })
    }
    
    // MARK: - UICollectionView methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imagesToUpload.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addedImageCell", for: indexPath) as? ShareOptionsSelectedImageCollectionViewCell
        
        // Configure the cell
        cell?.selectedImage.image = self.imagesToUpload[indexPath.row]
        
        let tapGestureToShareForAction = UITapGestureRecognizer(target: self, action: #selector (self.didTapOnCell(sender:)))
        tapGestureToShareForAction.cancelsTouchesInView = false
        cell?.addGestureRecognizer(tapGestureToShareForAction)
        
        return cell!
    }
    
    func didTapOnCell(sender: UITapGestureRecognizer) {
        
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.location(in: self.collectionView)
        
        //if tapLocation.point.
        if tapLocation.x < 80 && tapLocation.y > 35 {
            
            //using the tapLocation, we retrieve the corresponding indexPath
            let indexPath = self.collectionView.indexPathForItem(at: tapLocation)
            
            self.selectedImage = self.imagesToUpload[(indexPath?.row)!]
            
            self.performSegue(withIdentifier: "goToFullScreenSegue", sender: self)
        } else {
            
            self.imagesToUpload.removeAll()
            self.receivedNote?.data.photoData.link = ""
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "checkInSegue" {
            
            let checkInMapVC = segue.destination as? CheckInMapViewController
            
            checkInMapVC?.noteOptionsDelegate = self
        } else if segue.identifier == "goToFullScreenSegue" {
            
            let fullScreenPhotoVC = segue.destination as? PhotoFullScreenViewerViewController
            
            fullScreenPhotoVC?.imageURL = self.receivedNote?.data.photoData.link
            //fullScreenPhotoVC?.file = self
        }
    }
}
