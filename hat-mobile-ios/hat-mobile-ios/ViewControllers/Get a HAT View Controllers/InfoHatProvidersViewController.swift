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

/// The class responsible for showing info about hat providers
internal class InfoHatProvidersViewController: UIViewController {
    
    // MARK: - IBOutlets

    /// An IBOutlet for handling the textLabel we want to show
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - IBActions
    
    /**
     Hides the pop up info view controller via a notification
     
     - parameter sender: The object called this method
     */
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        AnimationHelper.animateView(
            self.view,
            duration: 0.2,
            animations: { [weak self] () -> Void in
                
                if let weakSelf = self {
                    
                    weakSelf.view.frame = CGRect(x: weakSelf.view.frame.origin.x, y: weakSelf.view.frame.maxY, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height)
                }
            },
            completion: {[weak self](_: Bool) -> Void in
                
                if self != nil {
                    
                    self!.removeViewController()
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideGetAHATPopUp), object: nil)
                }
        })
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textLabel.text = "All HAT providers are certified by the HAT Community Foundation to have achieved the required confidentiality, privacy and security credentials. Each HAT provider has its own unique domain name for your personal HAT address"
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Set up info view controller
    
    /**
     Creates and returns an InfoHatProvidersViewController
     
     - parameter storyBoard: The storyboard to init the view controller from
     
     - returns: An optional InfoHatProvidersViewController
     */
    class func setUpInfoHatProviderViewControllerPopUp(from storyBoard: UIStoryboard) -> InfoHatProvidersViewController? {
        
        // set up page controller
        let view = storyBoard.instantiateViewController(withIdentifier: "HATInfo") as? InfoHatProvidersViewController
        
        view?.view.createFloatingView(frame: CGRect(x: view!.view.frame.origin.x + 15, y: view!.view.bounds.maxY, width: view!.view.frame.width - 30, height: view!.view.bounds.height), color: .white, cornerRadius: 15)
        
        return view
    }

}
