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

import KeychainSwift

// MARK: Struct

/// A struct for working with the keychain
internal struct KeychainHelper {

    // MARK: - Keychain methods
    
    /**
     Set a value in the keychain
     
     - parameter String: the key
     - parameter String: the value
     
     - returns: The result of the saving into keychain
     */
    static func setKeychainValue(key: String, value: String?) -> Bool {
        
        if value != nil {
            
            return KeychainSwift().set(value!, forKey: key, withAccess: .accessibleWhenUnlocked)
        }
        
        return false
    }
    
    /**
     Get a value from keychain
     
     - parameter String: the key
     
     - returns: String
     */
    static func getKeychainValue(key: String) -> String? {
        
        return KeychainSwift().get(key)
    }
    
    /**
     Clear a value from keychain
     
     - parameter String: the key
     
     - returns: String
     */
    static func clearKeychainKey(key: String) -> Bool {
        
        return KeychainSwift().delete(key)
    }
}
