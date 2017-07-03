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

public struct DataOfferRewarsObject {
    
    // MARK: - JSON Fields
    
    public struct Fields {
        
        static let rewardType: String = "rewardType"
        static let rewardVendor: String = "vendor"
        static let vendorURL: String = "vendorUrl"
        static let rewardValue: String = "value"
    }
    
    // MARK: - Variables
    
    public var rewardType: String = ""
    public var vendor: String = ""
    public var vendorURL: String = ""
    public var value: String = ""
    
    // MARK: - Initialiser
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        rewardType = ""
        vendor = ""
        vendorURL = ""
        value = ""
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempRewardType = dictionary[DataOfferRewarsObject.Fields.rewardType]?.string {
            
            rewardType = tempRewardType
        }
        
        if let tempVendor = dictionary[DataOfferRewarsObject.Fields.rewardVendor]?.string {
            
            vendor = tempVendor
        }
        
        if let tempVendorUrl = dictionary[DataOfferRewarsObject.Fields.vendorURL]?.string {
            
            vendorURL = tempVendorUrl
        }
        
        if let tempValue = dictionary[DataOfferRewarsObject.Fields.rewardValue]?.string {
            
            value = tempValue
        }
    }
}
