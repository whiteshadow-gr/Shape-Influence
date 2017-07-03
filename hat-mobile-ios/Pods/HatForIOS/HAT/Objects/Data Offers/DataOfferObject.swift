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

public struct DataOfferObject {
    
    // MARK: - JSON Fields
    
    public struct Fields {
        
        static let dataOfferID: String = "id"
        static let createdDate: String = "created"
        static let offerTitle: String = "title"
        static let shortDescription: String = "shortDescription"
        static let longDescription: String = "longDescription"
        static let imageURL: String = "illustrationUrl"
        static let offerStarts: String = "starts"
        static let offerExpires: String = "expires"
        static let offerDuration: String = "collectFor"
        static let minimumUsers: String = "requiredMinUser"
        static let maximumUsers: String = "requiredMaxUser"
        static let usersClaimedOffer: String = "totalUserClaims"
        static let requiredDataDefinitions: String = "requiredDataDefinition"
        static let reward: String = "reward"
        static let owner: String = "owner"
        static let claim: String = "claim"
        static let pii: String = "pii"
    }
    
    // MARK: - Variables
    
    public var dataOfferID: String = ""
    public var title: String = ""
    public var shortDescription: String = ""
    public var longDescription: String = ""
    public var illustrationURL: String = ""
    
    public var created: Int = -1
    public var offerStarts: Int = -1
    public var offerExpires: Int = -1
    public var collectsDataFor: Int = -1
    public var requiredMinUsers: Int = -1
    public var requiredMaxUsers: Int = -1
    public var usersClaimedOffer: Int = -1
    
    public var requiredDataDefinition: [DataOfferRequiredDataDefinitionObject] = []
    
    public var reward: DataOfferRewarsObject = DataOfferRewarsObject()
    
    public var owner: DataOfferOwnerObject = DataOfferOwnerObject()
    
    public var claim: DataOfferClaimObject = DataOfferClaimObject()
    
    public var image: UIImage?
    
    public var isPΙIRequested: Bool = false
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        dataOfferID  = ""
        title = ""
        shortDescription = ""
        longDescription = ""
        illustrationURL = ""
        
        created = -1
        offerStarts = -1
        offerExpires = -1
        collectsDataFor = -1
        requiredMinUsers = -1
        requiredMaxUsers = -1
        usersClaimedOffer = -1
        
        requiredDataDefinition = []
        
        reward = DataOfferRewarsObject()
        
        owner = DataOfferOwnerObject()
        
        claim = DataOfferClaimObject()
        
        image = nil

        isPΙIRequested = false
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempID = dictionary[DataOfferObject.Fields.dataOfferID]?.string {
            
            dataOfferID = tempID
        }
        
        if let tempCreated = dictionary[DataOfferObject.Fields.createdDate]?.int {
            
            created = tempCreated
        }
        
        if let tempTitle = dictionary[DataOfferObject.Fields.offerTitle]?.string {
            
            title = tempTitle
        }
        
        if let tempShortDescription = dictionary[DataOfferObject.Fields.shortDescription]?.string {
            
            shortDescription = tempShortDescription
        }
        
        if let tempLongDescription = dictionary[DataOfferObject.Fields.longDescription]?.string {
            
            longDescription = tempLongDescription
        }
        
        if let tempIllustrationUrl = dictionary[DataOfferObject.Fields.imageURL]?.string {
            
            illustrationURL = tempIllustrationUrl
        }
        
        if let tempOfferStarts = dictionary[DataOfferObject.Fields.offerStarts]?.int {
            
            offerStarts = tempOfferStarts
        }
        
        if let tempOfferExpires = dictionary[DataOfferObject.Fields.offerExpires]?.int {
            
            offerExpires = tempOfferExpires
        }
        
        if let tempCollectOfferFor = dictionary[DataOfferObject.Fields.offerDuration]?.int {
            
            collectsDataFor = tempCollectOfferFor
        }
        
        if let tempRequiresMinUsers = dictionary[DataOfferObject.Fields.minimumUsers]?.int {
            
            requiredMinUsers = tempRequiresMinUsers
        }
        
        if let tempRequiresMaxUsers = dictionary[DataOfferObject.Fields.maximumUsers]?.int {
            
            requiredMaxUsers = tempRequiresMaxUsers
        }
        
        if let tempUserClaims = dictionary[DataOfferObject.Fields.usersClaimedOffer]?.int {
            
            usersClaimedOffer = tempUserClaims
        }
        
        if let tempPII = dictionary[DataOfferObject.Fields.pii]?.bool {
            
            isPΙIRequested = tempPII
        }
        
        if let tempRequiredDataDefinition = dictionary[DataOfferObject.Fields.requiredDataDefinitions]?.array {
            
            if !tempRequiredDataDefinition.isEmpty {
                
                for dataDefination in tempRequiredDataDefinition {
                    
                    requiredDataDefinition.append(DataOfferRequiredDataDefinitionObject(dictionary: dataDefination.dictionaryValue))
                }
            }
        }
        
        if let tempReward = dictionary[DataOfferObject.Fields.reward]?.dictionary {
            
            reward = DataOfferRewarsObject(dictionary: tempReward)
        }
        
        if let tempOwner = dictionary[DataOfferObject.Fields.owner]?.dictionary {
            
            owner = DataOfferOwnerObject(dictionary: tempOwner)
        }
        
        if let tempClaim = dictionary[DataOfferObject.Fields.claim]?.dictionary {
            
            claim = DataOfferClaimObject(dictionary: tempClaim)
        }
    }

}
