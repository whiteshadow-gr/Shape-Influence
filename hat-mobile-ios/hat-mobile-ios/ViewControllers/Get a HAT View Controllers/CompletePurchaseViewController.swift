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

import UIKit

// MARK: Class

/// The class responsible for notifying the user about the purchase and giving some info
internal class CompletePurchaseViewController: UIViewController {
    
    // MARK: - Variables
    
    /// The UIImage to show the user, passed from the previous view controller
    var image: UIImage?
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the hat provider image
    @IBOutlet private weak var hatProviderImage: UIImageView!
    
    /// An IBOutlet for handling the hat button
    @IBOutlet private weak var homeButton: UIButton!
    
    /// An IBOutlet for handling the arrow bar image on top
    @IBOutlet private weak var arrowbar: UIImageView!
    
    // MARK: - IBActions
    
    /**
     Redirects user back to home screen
     
     - parameter sender: The object that called this function
     */
    @IBAction func homeButtonAction(_ sender: Any) {
        
       _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // config the arrowBar
        self.arrowbar.image = self.arrowbar.image!.withRenderingMode(.alwaysTemplate)
        self.arrowbar.tintColor = UIColor.rumpelVeryLightGray
        
        // add border to home button
        self.homeButton.addBorderToButton(width: 1, color: .rumpelDarkGray)
        
        // check if the image is nil, if not assign it to the imageview
        if self.image != nil {
            
            self.hatProviderImage.image = self.image
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
