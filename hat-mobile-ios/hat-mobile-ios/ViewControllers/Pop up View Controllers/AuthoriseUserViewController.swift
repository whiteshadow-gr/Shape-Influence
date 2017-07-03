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
import SafariServices

// MARK: Class

/// Authorise view controller, really a blank view controller needed to present the safari view controller
internal class AuthoriseUserViewController: UIViewController, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The func to execute after completing the authorisation
    var completionFunc: ((String?) -> Void)?

    /// The safari view controller that opened to authorise user again
    private var safari: SFSafariViewController?
    
    // MARK: - View Controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        // add notif observer
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name(Constants.NotificationNames.reauthorised), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // launch safari
        self.launchSafari()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Dismiss view controller
    
    /**
     Dismisses view controller from view hierarchy
     
     - parameter notif: A Notification object that called this function
     */
    @objc
    private func dismissView(notif: Notification) {
        
        // get the url form the auth callback
        if let url = notif.object as? NSURL {
            
            // first of all, we close the safari vc
            self.safari?.dismissSafari(animated: true, completion: nil)
            
            // authorize with hat
            HATLoginService.loginToHATAuthorization(
                userDomain: userDomain,
                url: url,
                success: {token in
            
                    self.completionFunc?(token)
                    
                    // remove authorise view controller, that means remove self and notify the view controllers listening
                    self.removeViewController()
                    
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(Constants.NotificationNames.reauthorised), object: nil)
                },
                failed: { (_: AuthenicationError) -> Void in return }
            )
        }
    }
    
    // MARK: - Set up view controller

    /**
     Sets up a new AuthoriseUserViewController in order to present it to one UIView
     
     - parameter view: The UIView to show the view controller
     
     - returns: A ready to use AuthoriseUserViewController
     */
    class func setupAuthoriseViewController(view: UIView) -> AuthoriseUserViewController {
        
        let authorise = AuthoriseUserViewController()
        authorise.view.backgroundColor = .clear
        authorise.view.frame = CGRect(x: view.center.x - 50, y: view.center.y - 20, width: 100, height: 40)
        authorise.view.layer.cornerRadius = 15
        authorise.completionFunc = nil
        
        return authorise
    }
    
    // MARK: - Launch safari
    
    /**
     Launches safari
     */
    private func launchSafari() {
        
        self.safari = SFSafariViewController.openInSafari(url: Constants.HATEndpoints.hatLoginURL(userDomain: self.userDomain), on: self, animated: true, completion: nil)
    }
    
}
