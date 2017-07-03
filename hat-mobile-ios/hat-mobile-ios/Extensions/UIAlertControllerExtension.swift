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

// MARK: Extension

extension UIAlertController {
    
    // MARK: - Functions

    /**
     Adds as many actions as we want to the alert controller that called this method
     
     - parameter actions: The actions to add to the alert controller that called this method
     */
    func addActions(actions: [UIAlertAction]) {
        
        for action in actions {
            
          self.addAction(action)
        }
    }
    
    /**
     Adds iPad support for the alert controller. In iPad the action sheet styled alert controller has a pop up bubble theme and therefore it's essential to provide the source rect and source view of that bubble.
     
     - parameter sourceRect: The source rect that will show the bubble pop up
     - parameter sourceView: The source view that will show the bubble pop up
     */
    func addiPadSupport(sourceRect: CGRect, sourceView: UIView) {
        
        // if user is on ipad show as a pop up
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            self.popoverPresentationController?.sourceRect = sourceRect
            self.popoverPresentationController?.sourceView = sourceView
        }
    }
    
    /**
     Adds iPad support for the alert controller. In iPad the action sheet styled alert controller has a pop up bubble theme and therefore it's essential to provide the source rect and source view of that bubble.
     
     - parameter sourceRect: The source rect that will show the bubble pop up
     - parameter sourceView: The source view that will show the bubble pop up
     */
    func addiPadSupport(barButtonItem: UIBarButtonItem, sourceView: UIView) {
        
        // if user is on ipad show as a pop up
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            self.popoverPresentationController?.barButtonItem = barButtonItem
            self.popoverPresentationController?.sourceView = sourceView
        }
    }
    
    /**
     Creates an ok alert styled UIAlertController
     
     - parameter alertMessage: The desired alert message
     - parameter alertTitle: The desired alert title
     - parameter okTitle: The desired button title
     - parameter proceedCompletion: The desired function to execute on button press
     
     - returns: A UIAlertController ready to be presented from the view
     */
    class func createOKAlert(alertMessage: String, alertTitle: String, okTitle: String, proceedCompletion: @escaping () -> Void) -> UIAlertController {
        
        //change font
        let attrTitleString = NSAttributedString(string: alertTitle, attributes: [NSFontAttributeName: UIFont(name: Constants.FontNames.openSans, size: 32)!])
        let attrMessageString = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: UIFont(name: Constants.FontNames.openSans, size: 32)!])
        
        // create the alert
        let alert = UIAlertController(title: attrTitleString.string, message: attrMessageString.string, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (_: UIAlertAction) in
            
            proceedCompletion()
        }))
        
        return alert
    }
}
