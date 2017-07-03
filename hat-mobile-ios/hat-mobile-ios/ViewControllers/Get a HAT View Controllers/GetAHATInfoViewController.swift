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

/// Get A hat info view controller, used in onboarding of new users. A pop up view in GetAHATViewController
internal class GetAHATInfoViewController: UIViewController {
    
    // MARK: - Variables
    
    /// the HAT provider object
    var hatProvider: HATProviderObject?
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the hatProviderImage image view
    @IBOutlet private weak var hatProviderImage: UIImageView!

    /// An IBOutlet for handling the hatProviderDetailedInfo label
    @IBOutlet private weak var hatProviderDetailedInfo: UITextView!
    /// An IBOutlet for handling the hatProviderInfo label
    @IBOutlet private weak var hatProviderInfo: UITextView!
    
    /// An IBOutlet for handling the hatProviderTitle label
    @IBOutlet private weak var hatProviderTitle: UILabel!

    /// An IBOutlet for handling the signUpButton button
    @IBOutlet private weak var signUpButton: UIButton!
    /// An IBOutlet for handling the cancelButton button
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - IBActions
    
    /**
     User taped on sign up button. Open URL or hide pop up view depending on the data
     
     - parameter sender: The object that called this method
     */
    @IBAction func signUpAction(_ sender: Any) {
        
        if self.hatProvider?.name == "HALL Free HAT" {
            
            if let url = URL(string: "http://hubofallthings.com/hall/") {
                
                UIApplication.shared.openURL(url)
            }
        } else if self.hatProvider?.kind.kind == "External" {
            
            if let url = URL(string: (self.hatProvider?.kind.link)!) {
                
                UIApplication.shared.openURL(url)
            }
        } else {
            
            self.dismissView {
                
                NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideGetAHATPopUp), object: "1")
            }
        }
    }
    
    /**
     User taped on cancel button, hide pop up view
     
     - parameter sender: The object that called this method
     */
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismissView {
            
            NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideGetAHATPopUp), object: nil)
        }
    }
    
    // MARK: - View Controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set up cancel button
        self.cancelButton.imageView?.image = cancelButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.cancelButton.tintColor = .black
        
        // if we have a passed value from parent view controler, set up the view with this value
        if self.hatProvider != nil {
            
            // assigning values to objects
            self.hatProviderImage.image = self.hatProvider?.hatProviderImage!
            self.hatProviderTitle.text = self.hatProvider?.name
            self.hatProviderInfo.text = self.hatProvider?.category.description
            self.hatProviderInfo.layoutIfNeeded()
            self.hatProviderDetailedInfo.text = self.hatProvider?.description
            self.hatProviderDetailedInfo.sizeToFit()
            
            let buttonTitle = HATProviderObject.setupLabelForInfoViewController(hatProvider: self.hatProvider!)
            self.signUpButton.setAttributedTitle(buttonTitle, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Set up info view controller
    
    /**
     Creates and returns a new GetAHATInfoViewController
     
     - parameter storyBoard: The storyboard to initiate the view controller from
     - parameter hatProvider: The HATProviderObject to pass on the new view controller
     
     - returns: An optional GetAHATInfoViewController
     */
    class func setUpInfoHatProviderViewControllerPopUp(from storyBoard: UIStoryboard, hatProvider: HATProviderObject) -> GetAHATInfoViewController? {
        
        // set up page controller
        if let pageItemController = storyBoard.instantiateViewController(withIdentifier: "HATProviderInfo") as? GetAHATInfoViewController {
            
            pageItemController.hatProvider = hatProvider
            
            pageItemController.view.createFloatingView(frame: CGRect(x: pageItemController.view.frame.origin.x + 15, y: pageItemController.view.bounds.maxY, width: pageItemController.view.frame.width - 30, height: pageItemController.view.bounds.height - 30), color: .white, cornerRadius: 15)
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Dismiss view controller
    
    /**
     Dismisses the view controller with animation
     */
    private func dismissView(completion: @escaping () -> Void) {
        
        AnimationHelper.animateView(
            self.view,
            duration: 0.2,
            animations: {[weak self] () -> Void in
                
                if let weakSelf = self {
                    
                    weakSelf.view.frame = CGRect(x: weakSelf.view.frame.origin.x, y: weakSelf.view.frame.maxY, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
                }
            },
            completion: {[weak self] (_) -> Void in
                
                if self != nil {
                    
                    self!.removeViewController()
                    completion()
                }
        })
    }
}
