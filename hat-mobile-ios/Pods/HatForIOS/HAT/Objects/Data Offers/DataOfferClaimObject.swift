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

public struct DataOfferClaimObject {
    
    // MARK: - Fields
    
    public struct Fields {
        
        static let claimStatus: String = "status"
        static let claimConfirmed: String = "confirmed"
        static let claimDateStamp: String = "dateCreated"
    }

    // MARK: - Variables
    
    public var claimStatus: String = ""
    public var claimConfirmed: String = ""
    public var claimDateStamp: Int = -1
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        claimStatus = ""
        claimConfirmed = ""
        claimDateStamp = -1
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempStatus = dictionary[DataOfferClaimObject.Fields.claimStatus]?.string {
            
            claimStatus = tempStatus
        }
        
        if let tempConfirmed = dictionary[DataOfferClaimObject.Fields.claimConfirmed]?.string {
            
            claimConfirmed = tempConfirmed
        }
        
        if let tempDateStamp = dictionary[DataOfferClaimObject.Fields.claimDateStamp]?.int {
            
            claimDateStamp = tempDateStamp
        }
    }
}
