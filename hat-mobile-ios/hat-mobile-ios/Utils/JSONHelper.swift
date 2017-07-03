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

import SwiftyJSON

// MARK: Struct

/// A struct for working with JSON files. Either creating or updating an existing JSON file
internal struct JSONHelper {
    
    // MARK: - Create JSON for purchasing
    
    /**
     Creates the json file to purchase a HAT
     
     - parameter purchaseModel: The purchase model with all the necessary values
     
     - returns: A Dictionary with the values from the Purchase model with type of <String, Any>
     */
    static func createPurchaseJSONFrom(purchaseModel: PurchaseModel) -> Dictionary <String, Any> {
        
        // hat table dictionary
        let hat: Dictionary =  [
            
            "address": purchaseModel.address,
            "termsAgreed": purchaseModel.termsAgreed,
            "country": purchaseModel.country
        ] as [String : Any]
        
        // user table dictionary
        let user: Dictionary =  [
            
            "firstName": purchaseModel.firstName,
            "lastName": purchaseModel.lastName,
            "password": purchaseModel.password,
            "termsAgreed": purchaseModel.termsAgreed,
            "nick": purchaseModel.nick,
            "email": purchaseModel.email
        ] as [String : Any]
        
        // items table dictionary
        let items: Dictionary = [
        
            "sku": purchaseModel.sku,
            "quantity": 1
        ] as [String : Any]
        
        var purchase: Dictionary<String, Any> = [:]
        if purchaseModel.token != "" {
            
            // purchase table dictionary
            purchase = [
                
                "stripePaymentToken": purchaseModel.token,
                "items": [items]
                ]
        } else {
            
            // purchase table dictionary
            purchase = [
                
                "items": [items]
                ]
        }
        
        // the final JSON file to be returned
        let json: Dictionary = [
        
            "purchase": purchase,
            "user": user,
            "hat": hat,
            "password": purchaseModel.password
        ] as [String : Any]
        
        return json
    }
}
