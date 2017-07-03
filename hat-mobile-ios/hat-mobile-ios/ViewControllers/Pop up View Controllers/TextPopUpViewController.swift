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

/// The class responsible for the text pop up view controller
internal class TextPopUpViewController: UIViewController {
    
    // MARK: - Variables
    
    /// The text to show on the pop up
    var textToShow: String = ""
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for controlling the UILabel in order to show the text
    @IBOutlet private weak var textLabel: UILabel!
    
    // MARK: - IBActions
    
    /**
     Executed when the cancel button has been tapped
     
     - parameter sender: The object that called this method
     */
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        // Animate the view and at the end remove it from the superview
        AnimationHelper.animateView(
            self.view,
            duration: 0.2,
            animations: {[weak self]() -> Void in
                
                if self != nil {
                    
                    self!.view.frame = CGRect(x: self!.view.frame.origin.x, y: self!.view.frame.height, width: self!.view.frame.width, height: self!.view.frame.height)
                }
            },
            completion: {[weak self] (_: Bool) -> Void in
                
                self?.removeViewController()
                NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.hideDataServicesInfo), object: nil)
            }
        )
    }
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.textLabel.text = textToShow
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init view
    
    /**
     Inits a TextPopUpViewController for immediate use
     
     - parameter stringToShow: The string to show to the pop up
     - parameter storyBoard: The storyboard to init the view from
     
     - returns: An optional instance of TextPopUpViewController ready to present from a view controller
     */
    class func customInit(stringToShow: String, from storyBoard: UIStoryboard) -> TextPopUpViewController? {
        
        let textPopUpViewController = storyBoard.instantiateViewController(withIdentifier: "textPopUpViewController") as? TextPopUpViewController
        textPopUpViewController?.textToShow = stringToShow
        textPopUpViewController?.view.alpha = 0.7
        
        return textPopUpViewController
    }

}
