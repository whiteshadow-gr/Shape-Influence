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

/// The first onboarding view controller class
class FirstOnboardingViewController: UIViewController {
    
    // MARK: - Variables
    
    /// The current page index, used to load the correct content
    var pageIndex = 0
    
    // MARK: - IBOutlets

    /// An IBOutlet for handling the image view
    @IBOutlet weak var image: UIImageView!
    
    /// An IBOutlet for handling the message label
    @IBOutlet weak var messages: UILabel!
    
    /// An IBOutlet for handling the learn more button
    @IBOutlet weak var learnMoreButton: UIButton!
    
    // MARK: - IBActions
    
    /**
     Hides pop up screen
     
     - parameter sender: The object that called this method
     */
    @IBAction func clearButtonAction(_ sender: Any) {
        
        AnimationHelper.animateView(self.view,
                                    duration: 0.2,
                                    animations: {() -> Void in

                                        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.maxY, width: self.view.frame.width, height: self.view.frame.height)
                                }, completion: {(bool: Bool) -> Void in

                                        self.removeViewController()
                                        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideNewbie.rawValue), object: nil)
        })
        
    }
    
    /**
     Hides pop up screen
     
     - parameter sender: The object that called this method
     */
    @IBAction func learnMoreButtonAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideNewbie.rawValue), object: nil)
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // init the content we want based on the page index
        let learnMoreObject = LearnMoreObject(pageNumber: 20 + self.pageIndex)
        
        // format the label based on the page index
        self.messages.attributedText = LearnMoreObject.setUpTitleString(for: self.pageIndex, learnMoreObject: learnMoreObject, learnMoreButton: self.learnMoreButton)
        
        self.image.image = learnMoreObject.image
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
