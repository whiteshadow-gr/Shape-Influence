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

/// A struct representing the outer notes JSON format
public struct HATNotesData: Comparable {

    // MARK: - Comparable protocol

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
    public static func < (lhs: HATNotesData, rhs: HATNotesData) -> Bool {

        return lhs.data.updatedTime < rhs.data.updatedTime
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATNotesData, rhs: HATNotesData) -> Bool {

        return lhs.data == lhs.data
    }

    // MARK: - Variables

    /// the note id
    public var noteID: Int = 0

    /// The endPoint of the note, used in v2 API only
    public var endPoint: String = ""

    /// The recordID of the note, used in v2 API only
    public var recordID: String = ""

    /// the name of the note
    public var name: String  = ""

    /// the last updated date of the note
    public var lastUpdated: Date = Date()

    /// the data of the note, such as tables about the author, location, photo etc
    public var data: HATNotesNotablesData = HATNotesNotablesData()

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        noteID = 0
        name = ""
        endPoint = ""
        recordID = ""
        lastUpdated = Date()
        data = HATNotesNotablesData()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {

        if let tempID = dict["id"]?.int {

            noteID = tempID
        }
        if let tempName = dict["name"]?.string {

            name = tempName
        }
        if let tempLastUpdated = dict["lastUpdated"]?.string {

            lastUpdated = HATFormatterHelper.formatStringToDate(string: tempLastUpdated)!
        }
        if let tempData = dict["data"]?["notablesv1"].dictionary {

            data = HATNotesNotablesData.init(dict: tempData)
        }
    }

    /**
     It initialises everything from the received JSON file from the HAT using v2 API
     */
    public init(dictV2: Dictionary<String, JSON>) {

        if let tempEndpoint = dictV2["endpoint"]?.string {

            endPoint = tempEndpoint
        }

        if let tempRecordID = dictV2["recordId"]?.string {

            recordID = tempRecordID
        }

        if let tempData = dictV2["data"]?.dictionary {

            if let tempLastUpdated = tempData["lastUpdated"]?.string {

                lastUpdated = HATFormatterHelper.formatStringToDate(string: tempLastUpdated)!
            }
            if let tempNotablesData = tempData["notablesv1"]?.dictionary {

                data = HATNotesNotablesData.init(dict: tempNotablesData)
            }
        }
    }

    // MARK: - JSON Mapper

    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {

        return [

            "notablesv1": self.data.toJSON(),
            "lastUpdated": Int(HATFormatterHelper.formatDateToEpoch(date: Date())!)!
        ]
    }
}
