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

public struct DataOfferRequiredDataDefinitionObject {
    
    // MARK: - JSON Fields
    
    public struct Fields {
        
        static let requiredDataDefinitionSource: String = "source"
        static let requiredDataDefinitionDataSets: String = "datasets"
    }
    
    // MARK: - Variables
    
    public var source: String = ""
    
    public var dataSets: [DataOfferRequiredDataDefinitionDataSetsObject] = []
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {
        
        source = ""
        dataSets = []
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dictionary: Dictionary<String, JSON>) {
        
        if let tempSource = dictionary[DataOfferRequiredDataDefinitionObject.Fields.requiredDataDefinitionSource]?.string {
            
            source = tempSource
        }
        
        if let tempDataSets = dictionary[DataOfferRequiredDataDefinitionObject.Fields.requiredDataDefinitionDataSets]?.array {
            
            if !tempDataSets.isEmpty {
                
                for dataSet in tempDataSets {
                    
                    dataSets.append(DataOfferRequiredDataDefinitionDataSetsObject(dictionary: dataSet.dictionaryValue))
                }
            }
        }
    }
}
