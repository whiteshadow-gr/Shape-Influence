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

/// A struct representing the notables table received from JSON
public struct HATNotesNotablesData: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATNotesNotablesData, rhs: HATNotesNotablesData) -> Bool {

        return (lhs.authorData == rhs.authorData && lhs.photoData == rhs.photoData && lhs.locationData == rhs.locationData
            && lhs.createdTime == rhs.createdTime && lhs.publicUntil == rhs.publicUntil && lhs.updatedTime == rhs.updatedTime && lhs.shared == rhs.shared && lhs.sharedOn == rhs.sharedOn && lhs.message == rhs.message && lhs.kind == rhs.kind)
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
    public static func < (lhs: HATNotesNotablesData, rhs: HATNotesNotablesData) -> Bool {

        return lhs.updatedTime < rhs.updatedTime
    }

    // MARK: - Variables

    /// the author data
    public var authorData: HATNotesAuthorData = HATNotesAuthorData()

    /// the photo data
    public var photoData: HATNotesPhotoData = HATNotesPhotoData()

    /// the location data
    public var locationData: HATNotesLocationData = HATNotesLocationData()

    /// creation date
    public var createdTime: Date = Date()
    /// the date until this note will be public (don't know if it's optional or not)
    public var publicUntil: Date?
    /// the updated time of the note
    public var updatedTime: Date = Date()

    /// if true this note is shared to facebook etc.
    public var shared: Bool = false

    /// If shared, where is it shared? Coma seperated string (don't know if it's optional or not)
    public var sharedOn: String = ""
    /// the actual message of the note
    public var message: String = ""
    /// the kind of the note. 3 types available note, blog or list
    public var kind: String = ""

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        authorData = HATNotesAuthorData.init()
        createdTime = Date()
        shared = false
        sharedOn = ""
        photoData = HATNotesPhotoData.init()
        locationData = HATNotesLocationData.init()
        message = ""
        publicUntil = nil
        updatedTime = Date()
        kind = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {

        if let tempAuthorData = dict["authorv1"]?.dictionary {

            authorData = HATNotesAuthorData.init(dict: tempAuthorData)
        }

        if let tempPhotoData = dict["photov1"]?.dictionary {

            photoData = HATNotesPhotoData.init(dict: tempPhotoData)
        }

        if let tempLocationData = dict["locationv1"]?.dictionary {

            locationData = HATNotesLocationData.init(dict: tempLocationData)
        }

        if let tempSharedOn = dict["shared_on"]?.string {

            sharedOn = tempSharedOn
        }

        if let tempPublicUntil = dict["public_until"]?.string {

            publicUntil = HATFormatterHelper.formatStringToDate(string: tempPublicUntil)
        }

        if let tempCreatedTime = dict["created_time"]?.string {

            if let returnedDate = HATFormatterHelper.formatStringToDate(string: tempCreatedTime) {

                createdTime = returnedDate
            }
        }

        if let tempUpdatedTime = dict["updated_time"]?.string {

            if let returnedDate = HATFormatterHelper.formatStringToDate(string: tempUpdatedTime) {

                updatedTime = returnedDate
            }
        }

        if let tempDict = dict["shared"]?.string {

            if tempDict == "" {

                shared = false
            } else {

                if let boolShared = Bool(tempDict) {

                    shared = boolShared
                }
            }
        }

        if let tempMessage = dict["message"]?.string {

            message = tempMessage
        }

        if let tempKind = dict["kind"]?.string {

            kind = tempKind
        }
    }

    // MARK: - JSON Mapper

    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {

        var tempPublicUntil = 0
        if self.publicUntil == nil {

            tempPublicUntil = Int(HATFormatterHelper.formatDateToEpoch(date: Date())!)!
        } else {

            tempPublicUntil = Int(HATFormatterHelper.formatDateToEpoch(date: self.publicUntil!)!)!
        }

        return [

            "authorv1": self.authorData.toJSON(),
            "photov1": self.photoData.toJSON(),
            "locationv1": self.locationData.toJSON(),
            "shared_on": self.sharedOn,
            "public_until": tempPublicUntil,
            "created_time": Int(HATFormatterHelper.formatDateToEpoch(date: self.createdTime)!)!,
            "updated_time": Int(HATFormatterHelper.formatDateToEpoch(date: self.updatedTime)!)!,
            "shared": String(describing: self.shared),
            "message": self.message,
            "kind": self.kind
        ]
    }
}
