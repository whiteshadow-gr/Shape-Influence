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

import Crashlytics
import HatForIOS

// MARK: Struct

internal struct CrashLoggerHelper {
    
    // MARK: - Log to crashlytics
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func authenticationErrorLog(error: AuthenicationError) -> UIAlertController {
        
        switch error {
        case .cannotSplitToken(let description):
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["Cannot split token. Error: ": "\(description)"])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Token error!", alertTitle: "Cannot split token", okTitle: "OK", proceedCompletion: {})
        case .cannotDecodeToken(let description):
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["Cannot decode token. Error: ": "\(description)"])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Token error!", alertTitle: "Cannot decode token", okTitle: "OK", proceedCompletion: {})
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
            
            let msg: String = NetworkHelper.exceptionFriendlyMessage(statusCode, defaultMessage: error.localizedDescription)
            return UIAlertController.createOKAlert(alertMessage: msg, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        case .noIssuerDetectedError(let description):
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["No issuer detected in the token. Error: ": "\(description)"])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Token error!", alertTitle: "Cannot detect issuer", okTitle: "OK", proceedCompletion: {})
        case .noTokenDetectedError:
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["No token detected": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: NSLocalizedString("auth_error_no_token_in_callback", comment: "auth"), alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        case .tokenValidationFailed(let description):
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["Token validation failed. Error: ": "\(description)"])
            
            return UIAlertController.createOKAlert(alertMessage: NSLocalizedString("auth_error_invalid_token", comment: "auth"), alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        }
    }
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func dataPlugErrorLog(error: DataPlugError) -> UIAlertController? {
        
        switch error {
        case .noValueFound:
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["No value found in the response": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Response error!", alertTitle: "No value found in the response", okTitle: "OK", proceedCompletion: {})
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
            
            // no token in url callback redirect
            let msg: String = NetworkHelper.exceptionFriendlyMessage(statusCode, defaultMessage: error.localizedDescription)
            return UIAlertController.createOKAlert(alertMessage: msg, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        case .offerClaimed:
            
            return nil
        }
    }
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func JSONParsingErrorLog(error: JSONParsingError) -> UIAlertController {
        
        let crashlytics = Crashlytics.sharedInstance()
        switch error {
        case .expectedFieldNotFound:
            
            crashlytics.recordError(error, withAdditionalUserInfo: ["No value found in the response ": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Response error!", alertTitle: "No value found in the response", okTitle: "OK", proceedCompletion: {})
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                crashlytics.recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                crashlytics.recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                crashlytics.recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
            
            // no token in url callback redirect
            let msg: String = NetworkHelper.exceptionFriendlyMessage(statusCode, defaultMessage: error.localizedDescription)
            return UIAlertController.createOKAlert(alertMessage: msg, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        }
    }
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    static func JSONParsingErrorLogWithoutAlert(error: JSONParsingError) {
        
        let crashlytics = Crashlytics.sharedInstance()
        switch error {
        case .expectedFieldNotFound:
            
            crashlytics.recordError(error, withAdditionalUserInfo: ["No value found in the response ": ""])
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                crashlytics.recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                crashlytics.recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                crashlytics.recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
        }
    }
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func hatTableErrorLog(error: HATTableError) -> UIAlertController {
        
        switch error {
        case .noTableIDFound:
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["No table ID found ": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "No table ID found!", alertTitle: "Table ID not found in the server", okTitle: "OK", proceedCompletion: {})
        case .noValuesFound:
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["No value found ": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "No value found!", alertTitle: "Value not found in the server", okTitle: "OK", proceedCompletion: {})
        case .tableDoesNotExist:
            
            Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["Table does not exist ": ""])
            
            // no token in url callback redirect
            return UIAlertController.createOKAlert(alertMessage: "Requested table does not exist!", alertTitle: "Requested table does not exist in the server", okTitle: "OK", proceedCompletion: {})
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
            
            // no token in url callback redirect
            let msg: String = NetworkHelper.exceptionFriendlyMessage(statusCode, defaultMessage: error.localizedDescription)
            return  UIAlertController.createOKAlert(alertMessage: msg, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        }
    }
    
    /**
     Logs the error to crashlytics
     
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func hatErrorLog(error: HATError) -> UIAlertController {
        
        switch error {
        case .generalError(let description, let statusCode, let errorReturned):
            
            if statusCode != nil && errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if statusCode != nil {
                
                Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["General error. Error: ": "\(error)", "status code: ": "\(statusCode!)", "description: ": "\(description)"])
            } else if errorReturned != nil {
                
                Crashlytics.sharedInstance().recordError(errorReturned!, withAdditionalUserInfo: ["General error. Error: ": "\(errorReturned!)", "description: ": "\(description)"])
            }
            
            // no token in url callback redirect
            let msg: String = NetworkHelper.exceptionFriendlyMessage(statusCode, defaultMessage: error.localizedDescription)
            return UIAlertController.createOKAlert(alertMessage: msg, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
        }
    }
    
    /**
     Logs a custom message on crashlytics
     
     - parameter message: The custom message to add to crashlytics
     - parameter error: The error returned from the server
     
     - returns: A ready to present UIAlertController with alert type and one OK button
     */
    @discardableResult
    static func customErrorLog(message: String, error: Error) -> UIAlertController {
        
        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: [message: ""])
        
        return UIAlertController.createOKAlert(alertMessage: message, alertTitle: NSLocalizedString("error_label", comment: "error"), okTitle: "OK", proceedCompletion: {})
    }

}
