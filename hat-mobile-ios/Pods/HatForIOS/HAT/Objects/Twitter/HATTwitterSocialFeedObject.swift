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

// MARK: Class

/// A class representing the twitter social feed object
public struct HATTwitterSocialFeedObject: HATSocialFeedObject, Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATTwitterSocialFeedObject, rhs: HATTwitterSocialFeedObject) -> Bool {

        return (lhs.name == rhs.name && lhs.recordIDv1 == rhs.recordIDv1 && lhs.data == rhs.data && lhs.lastUpdated == rhs.lastUpdated)
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
    public static func < (lhs: HATTwitterSocialFeedObject, rhs: HATTwitterSocialFeedObject) -> Bool {

        if lhs.lastUpdated != nil && rhs.lastUpdated != nil {

            return lhs.lastUpdated! < rhs.lastUpdated!
        } else if lhs.lastUpdated != nil && rhs.lastUpdated == nil {

            return false
        } else {

            return true
        }
    }

    // MARK: - Protocol's variables

    /// The last date updated of the record
    public var protocolLastUpdate: Date?

    // MARK: - Class' variables

    /// The name of the record in database
    public var name: String = ""
    /// The id of the record
    public var recordIDv1: String = ""

    /// The actual data of the record
    public var data: HATTwitterDataSocialFeedObject = HATTwitterDataSocialFeedObject()

    /// The last updated field of the record
    public var lastUpdated: Date?

    /// The endPoint of the note, used in v2 API only
    public var endPoint: String = ""

    /// The recordID of the note, used in v2 API only
    public var recordID: String = ""

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        name = ""
        data = HATTwitterDataSocialFeedObject()
        recordIDv1 = ""
        lastUpdated = nil
        endPoint = ""
        recordID = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempName = dictionary["name"]?.stringValue {

            name = tempName
        }
        if let tempData = dictionary["data"]?.dictionaryValue {

            data = HATTwitterDataSocialFeedObject(from: tempData)
        }
        if let tempID = dictionary["id"]?.stringValue {

            recordIDv1 = tempID
        }
        if let tempLastUpdated = dictionary["lastUpdated"]?.stringValue {

            lastUpdated = HATFormatterHelper.formatStringToDate(string: tempLastUpdated)
            protocolLastUpdate = lastUpdated
        }
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(fromV2 dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempEndpoint = dictionary["endpoint"]?.string {

            endPoint = tempEndpoint
        }

        if let tempRecordID = dictionary["recordId"]?.string {

            recordID = tempRecordID
        }

        if let tempData = dictionary["data"]?.dictionaryValue {

            if let tempLastUpdated = tempData["lastUpdated"]?.stringValue {

                lastUpdated = HATFormatterHelper.formatStringToDate(string: tempLastUpdated)
                protocolLastUpdate = lastUpdated
            }

            data = HATTwitterDataSocialFeedObject(from: tempData)
        }
    }
}
