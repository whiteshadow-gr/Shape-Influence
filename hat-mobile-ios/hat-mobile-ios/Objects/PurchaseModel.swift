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

// MARK: Struct

/// The PurchaseModel object representation
internal struct PurchaseModel {
    
    // MARK: - Variables
    
    /// The stripe token for this purchase
    var token: String = ""
    /// The SKU number for this purchase
    var sku: String = ""
    
    /// User's first name
    var firstName: String = ""
    /// User's last name
    var lastName: String = ""
    /// User's desired password
    var password: String = ""
    /// User's desired password
    var nick: String = ""
    /// User's email
    var email: String = ""
    
    /// User's agreed to terms?
    var termsAgreed: Bool = false
    
    /// User's address
    var address: String = ""
    /// User's country
    var country: String = ""
}
