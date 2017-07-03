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
import JWTDecode

// MARK: Extension

extension HATAccountService {
    
    // MARK: - User's settings
    
    /**
     Get the Market Access Token for the iOS data plug
     
     - returns: UserHATDomainAlias
     */
    class func theUserHATDomain() -> Constants.UserHATDomainAlias {
        
        if let hatDomain = KeychainHelper.getKeychainValue(key: Constants.Keychain.hatDomainKey) {
            
            return hatDomain
        }
        
        return ""
    }
    
    /**
     Gets user's token from keychain
     
     - returns: The token as a string
     */
    class func getUsersTokenFromKeychain() -> String {
        
        // check if the token has been saved in the keychain and return it. Else return an empty string
        if let token = KeychainHelper.getKeychainValue(key: "UserToken") {
            
            return token
        }
        
        return ""
    }
    
    // MARK: - Check if token is active
    
    /**
     Checks if token has expired
     
     - parameter token: The token to check if expired
     - parameter expiredCallBack: A function to execute if the token has expired
     - parameter tokenValidCallBack: A function to execute if the token is valid
     - parameter errorCallBack: A function to execute when something has gone wrong
     */
    class func checkIfTokenExpired(token: String, expiredCallBack: () -> Void, tokenValidCallBack: (String?) -> Void, errorCallBack: (String, String, String, @escaping () -> Void) -> Void) {
        
        do {
            
            let jwt = try decode(jwt: token)
            print(token)
            if jwt.expired {
                
                expiredCallBack()
            } else {
                
                tokenValidCallBack(token)
            }
        } catch {
            
            errorCallBack("Checking token expiry date failed, please log out and log in again", "Error", "OK", {})
        }
    }
    
    // MARK: - Verify domain
    
    /**
     Verify the domain if it's what we expect
     
     - parameter domain: The formated doamain
     
     - returns: Bool, true if the domain matches what we expect and false otherwise
     */
    class func verifyDomain(_ domain: String) -> Bool {
        
        if domain == "hubofallthings.net" || domain == "warwickhat.net" || domain == "hubat.net" {
            
            return true
        }
        
        return false
    }

}
