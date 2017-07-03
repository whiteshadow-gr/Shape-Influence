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

/// The UITabBarViewController
internal class TabBarViewController: UITabBarController {
    
    // MARK: - View controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // disable left navigation button
        self.navigationItem.leftBarButtonItems = nil
        // hide back button
        self.navigationItem.hidesBackButton = true
        
        // change tint color, the color of the selected icon in tab bar
        self.tabBar.tintColor = .teal
        
        // change navigation bar title
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Constants.FontNames.openSansBold, size: 21)!]
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    /**
     Logout procedure
     */
    class func logoutUser(from viewController: UIViewController) {
        
        let yesAction = {() -> Void in
            
            // delete keys from keychain
            _ = KeychainHelper.clearKeychainKey(key: "UserToken")
            _ = KeychainHelper.setKeychainValue(key: "logedIn", value: "false")
            
            // reset the stack to avoid allowing back
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                
                let navigation = viewController.navigationController
                _ = viewController.navigationController?.popToRootViewController(animated: false)
                navigation?.pushViewController(loginViewController, animated: false)
                
                UpdateLocations.shared.stopUpdatingLocation()
                UpdateLocations.shared.stopMonitoringAllRegions()
                UpdateLocations.shared.stopMonitoringSignificantLocationChanges()
            }
        }
        
        viewController.createClassicAlertWith(alertMessage: NSLocalizedString("logout_message_label", comment:  "logout message"), alertTitle: NSLocalizedString("logout_label", comment:  "logout"), cancelTitle: NSLocalizedString("no_label", comment:  "no"), proceedTitle: NSLocalizedString("yes_label", comment:  "yes"), proceedCompletion: yesAction, cancelCompletion: {})
    }
}
