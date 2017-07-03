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

/// A struct representing the author table received from JSON
public struct HATNotesAuthorData: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATNotesAuthorData, rhs: HATNotesAuthorData) -> Bool {

        return (lhs.nickName == rhs.nickName && lhs.name == rhs.name && lhs.photoURL == rhs.photoURL && lhs.phata == rhs.phata && lhs.authorID == rhs.authorID)
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
    public static func < (lhs: HATNotesAuthorData, rhs: HATNotesAuthorData) -> Bool {

        return lhs.name < rhs.name
    }

    // MARK: - Variables

    /// the nickname of the author
    public var nickName: String = ""
    /// the name of the author
    public var name: String = ""
    /// the photo url of the author
    public var photoURL: String = ""
    /// the phata of the author. Required
    public var phata: String = ""

    /// the id of the author
    public var authorID: Int = 0

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        nickName = ""
        name = ""
        photoURL = ""
        authorID = 0
        phata = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {

        // this field will always have a value no need to use if let
        if let tempPHATA = dict["phata"]?.string {

            phata = tempPHATA
        }

        // check optional fields for value, if found assign it to the correct variable
        if let tempID = dict["id"]?.stringValue {

            // check if string is "" as well
            if tempID != ""{

                if let intTempID = Int(tempID) {

                    authorID = intTempID
                }
            }
        }

        if let tempNickName = dict["nick"]?.string {

            nickName = tempNickName
        }

        if let tempName = dict["name"]?.string {

            name = tempName
        }

        if let tempPhotoURL = dict["photo_url"]?.string {

            photoURL = tempPhotoURL
        }
    }

    // MARK: - JSON Mapper

    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {

        return [

            "phata": self.phata,
            "id": self.authorID,
            "nick": self.nickName,
            "name": self.name,
            "photo_url": self.photoURL
        ]
    }
}
