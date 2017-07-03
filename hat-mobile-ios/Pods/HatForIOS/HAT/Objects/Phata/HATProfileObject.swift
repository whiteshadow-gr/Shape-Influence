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

/// A struct representing the profile object from the received profile JSON file
public struct HATProfileObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileObject, rhs: HATProfileObject) -> Bool {

        return (lhs.data == rhs.data)
    }

    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: HATProfileObject, rhs: HATProfileObject) -> Bool {

        if lhs.lastUpdate != nil && rhs.lastUpdate != nil {

            return lhs.lastUpdate! < rhs.lastUpdate!
        }

        return false
    }

    // MARK: - Variables

    /// The id of the record in database
    public var databaseRecordID: Int = 0
    /// The name of the profile record, usually it's the date and time of creation
    public var name: String = ""
    /// The last updated date
    public var lastUpdate: Date?
    /// The last updated date
    public var dateCreated: Date?
    /// The actual data of the record
    public var data: HATProfileDataProfileObject = HATProfileDataProfileObject()

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        databaseRecordID = 0
        name = ""
        lastUpdate = nil
        dateCreated = nil
        data = HATProfileDataProfileObject()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dict: Dictionary<String, JSON>) {

        if let tempId = (dict["id"]?.intValue) {

            databaseRecordID = tempId
        }
        if let tempName = (dict["name"]?.stringValue) {

            name = tempName
        }
        if let tempDateCreated = (dict["dateCreated"]?.stringValue) {

            dateCreated = HATFormatterHelper.formatStringToDate(string: String(tempDateCreated))
        }
        if let tempLastUpdated = (dict["lastUpdated"]?.stringValue) {

            lastUpdate = HATFormatterHelper.formatStringToDate(string: String(tempLastUpdated))
        }
        if let tempData = (dict["tables"]?.arrayValue) {

            let tempData2 = tempData[0].dictionaryValue
            data = HATProfileDataProfileObject(from: tempData2)
        }
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(alternativeDictionary: Dictionary<String, JSON>) {

        if let tempId = (alternativeDictionary["id"]?.intValue) {

            databaseRecordID = tempId
        }
        if let tempName = (alternativeDictionary["name"]?.stringValue) {

            name = tempName
        }
        if let tempDateCreated = (alternativeDictionary["dateCreated"]?.stringValue) {

            dateCreated = HATFormatterHelper.formatStringToDate(string: String(tempDateCreated))
        }
        if let tempLastUpdated = (alternativeDictionary["lastUpdated"]?.stringValue) {

            lastUpdate = HATFormatterHelper.formatStringToDate(string: String(tempLastUpdated))
        }

        data = HATProfileDataProfileObject(alternativeDictionary: alternativeDictionary)
    }

    // MARK: - JSON Mapper

    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {

        return [

            "profile": self.data.toJSON()
        ]
    }
}
