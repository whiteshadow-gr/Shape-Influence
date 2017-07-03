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

// MARK: Extension

extension SFSafariViewController {
    
    // MARK: - Open url in safari
    
    /**
     Opens safari with the url passed as parameter
     
     - parameter url: The url to connect to as String
     - parameter viewController: The view controller to present the safari
     - parameter animated: A bool value to enable or disable the animated presentation
     - parameter completion: An optional completion handler to execute some code after presenting the safari
     
     - returns: An optional SFSafariViewController. In case the string cannot be converted to URL return nil, else returns the SFSafariViewController
     */
    class func openInSafari(url: String, on viewController: UIViewController, animated: Bool, completion: (() -> Void)?) -> SFSafariViewController? {
        
        if let authURL = URL(string: url) {
            
            // open the log in procedure in safari
            let tempView = SFSafariViewController(url: authURL)
            viewController.present(tempView, animated: animated, completion: completion)
            
            return tempView
        }
        
        return nil
    }
    
    // MARK: - Dismiss safari
    
    /**
     Dismisses the safari
     
     - parameter animated: A Bool value to dermine if the presenting of the safari will be animated or not
     - parameter completion: An optional function of type (Void) -> Void)? to execute on completion
     */
    func dismissSafari(animated: Bool, completion: (() -> Void)?) {
        
        self.dismiss(animated: animated, completion: completion)
        self.removeFromParentViewController()
    }
    
}
