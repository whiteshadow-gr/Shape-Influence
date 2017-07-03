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

/// A struct representing the profile data Primary Email object from the received profile JSON file
public struct HATProfileDataProfilePrimaryEmailObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileDataProfilePrimaryEmailObject, rhs: HATProfileDataProfilePrimaryEmailObject) -> Bool {

        return (lhs.isPrivate == rhs.isPrivate && lhs.value == rhs.value)
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
    public static func < (lhs: HATProfileDataProfilePrimaryEmailObject, rhs: HATProfileDataProfilePrimaryEmailObject) -> Bool {

        return lhs.value < rhs.value
    }

    // MARK: - Variables

    /// Indicates if the object, HATProfileDataProfilePrimaryEmailObject, is private
    public var isPrivate: Bool = true {

        didSet {

            isPrivateTuple = (isPrivate, isPrivateTuple.1)
        }
    }

    /// User's primary email address
    public var value: String = "" {

        didSet {

            valueTuple = (value, valueTuple.1)
        }
    }

    /// A tuple containing the isPrivate and the ID of the value
    var isPrivateTuple: (Bool, Int) = (true, 0)

    /// A tuple containing the value and the ID of the value
    var valueTuple: (String, Int) = ("", 0)

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        isPrivate = true
        value = ""

        isPrivateTuple = (true, 0)
        valueTuple = ("", 0)
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from array: [JSON]) {

        for json in array {

            let dict = json.dictionaryValue

            if let tempName = (dict["name"]?.stringValue), let id = dict["id"]?.intValue {

                if tempName == "private" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringValue = tempValues[0].dictionaryValue["value"]?.stringValue {

                            if let boolResult = Bool(stringValue) {

                                isPrivate = boolResult
                                isPrivateTuple = (isPrivate, id)
                            }
                        }
                    }
                }

                if tempName == "value" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringValue = tempValues[0].dictionaryValue["value"]?.stringValue {

                            value = stringValue
                            valueTuple = (value, id)
                        }
                    }
                }
            }
        }
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(alternativeArray: [JSON]) {

        for json in alternativeArray {

            let dict = json.dictionaryValue

            if let tempName = (dict["name"]?.stringValue), let id = dict["id"]?.intValue {

                if tempName == "private" {

                    isPrivate = true
                    isPrivateTuple = (isPrivate, id)
                }

                if tempName == "value" {

                    value = ""
                    valueTuple = (value, id)
                }
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

            "private": String(describing: self.isPrivate),
            "value": self.value
        ]
    }

}
