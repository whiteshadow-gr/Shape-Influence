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

import MessageUI

// MARK: Class

internal class MailHelper: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Send email
    
    /**
     Sends email to the defined address
     
     - parameter at: The address to send the email to
     - parameter ofViewController: The view controller that will show the mail view controller
     */
    func sendEmail(atAddress: String, onBehalf ofViewController: UIViewController) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailVC = MFMailComposeViewController()
            mailVC.setToRecipients([atAddress])
            mailVC.mailComposeDelegate = self

            // present view controller
            ofViewController.present(mailVC, animated: true, completion: nil)
        } else {
            
            ofViewController.createClassicOKAlertWith(alertMessage: "This device has not been configured to send emails", alertTitle: "Email services disabled", okTitle: "OK", proceedCompletion: {})
        }
    }
    
    // MARK: - Mail View controller
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}
