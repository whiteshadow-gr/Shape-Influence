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

public struct DataOfferRequiredDataDefinitionDataSetsFieldsObject {
    
    // MARK: - JSON Fields
    
    public struct Fields {
        
        static let requiredDataDefinitionName: String = "name"
        static let requiredDataDefinitionDescription: String = "description"
        static let requiredDataDefinitionFields: String = "fields"
    }
    
    // MARK: - Variables

    public var name: String = ""
    public var fieldDescription: String = ""
    
    public var fields: [DataOfferRequiredDataDefinitionDataSetsFieldsObject] = []
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        name = ""
        fieldDescription = ""
        fields = []
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempName = dictionary[DataOfferRequiredDataDefinitionDataSetsFieldsObject.Fields.requiredDataDefinitionName]?.string {
            
            name = tempName
        }
        
        if let tempDescription = dictionary[DataOfferRequiredDataDefinitionDataSetsFieldsObject.Fields.requiredDataDefinitionDescription]?.string {
            
            fieldDescription = tempDescription
        }
        
        if let tempFields = dictionary[DataOfferRequiredDataDefinitionDataSetsFieldsObject.Fields.requiredDataDefinitionFields]?.array {
            
            if !tempFields.isEmpty {
                
                for field in tempFields {
                    
                    fields.append(DataOfferRequiredDataDefinitionDataSetsFieldsObject(dictionary: field.dictionaryValue))
                }
            }
        }
    }
}
