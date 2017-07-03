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

/// A struct representing the profile data Personal object from the received profile JSON file
public struct HATProfileDataProfilePersonalObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileDataProfilePersonalObject, rhs: HATProfileDataProfilePersonalObject) -> Bool {

        return (lhs.isPrivate == rhs.isPrivate && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.middleName == rhs.middleName && lhs.prefferedName == rhs.prefferedName && lhs.title == rhs.title)
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
    public static func < (lhs: HATProfileDataProfilePersonalObject, rhs: HATProfileDataProfilePersonalObject) -> Bool {

        return lhs.lastName < rhs.lastName
    }

    // MARK: - Variables

    /// Indicates if the object, HATProfileDataProfilePersonalObject, is private
    public var isPrivate: Bool = true {

        didSet {

            isPrivateTuple = (isPrivate, isPrivateTuple.1)
        }
    }

    /// User's first name
    public var firstName: String = "" {

        didSet {

            firstNameTuple = (firstName, firstNameTuple.1)
        }
    }
    /// User's last name
    public var lastName: String = "" {

        didSet {

            lastNameTuple = (lastName, lastNameTuple.1)
        }
    }
    /// User's middle name
    public var middleName: String = "" {

        didSet {

            middleNameTuple = (middleName, middleNameTuple.1)
        }
    }
    /// User's preffered name
    public var prefferedName: String = "" {

        didSet {

            prefferedNameTuple = (prefferedName, prefferedNameTuple.1)
        }
    }
    /// User's title
    public var title: String = "" {

        didSet {

            titleTuple = (title, titleTuple.1)
        }
    }

    /// A tuple containing the isPrivate and the ID of the value
    var isPrivateTuple: (Bool, Int) = (true, 0)

    /// A tuple containing the firstName and the ID of the value
    var firstNameTuple: (String, Int) = ("", 0)

    /// A tuple containing the lastName and the ID of the value
    var lastNameTuple: (String, Int) = ("", 0)

    /// A tuple containing the middleName and the ID of the value
    var middleNameTuple: (String, Int) = ("", 0)

    /// A tuple containing the prefferedName and the ID of the value
    var prefferedNameTuple: (String, Int) = ("", 0)

    /// A tuple containing the title and the ID of the value
    var titleTuple: (String, Int) = ("", 0)

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        isPrivate = true
        firstName = ""
        lastName = ""
        middleName = ""
        prefferedName = ""
        title = ""

        isPrivateTuple = (true, 0)
        firstNameTuple = ("", 0)
        lastNameTuple = ("", 0)
        middleNameTuple = ("", 0)
        prefferedNameTuple = ("", 0)
        titleTuple = ("", 0)
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

                            if let result = Bool(stringValue) {

                                isPrivate = result
                                isPrivateTuple = (isPrivate, id)
                            }
                        }
                    }
                }

                if tempName == "first_name" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringResult = tempValues[0].dictionaryValue["value"]?.stringValue {

                            firstName = stringResult
                            firstNameTuple = (firstName, id)
                        }
                    }
                }

                if tempName == "last_name" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringResult = tempValues[0].dictionaryValue["value"]?.stringValue {

                            lastName = stringResult
                            lastNameTuple = (lastName, id)
                        }
                    }
                }

                if tempName == "preferred_name" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringResult = tempValues[0].dictionaryValue["value"]?.stringValue {

                            prefferedName = stringResult
                            prefferedNameTuple = (prefferedName, id)
                        }
                    }
                }

                if tempName == "middle_name" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringResult = tempValues[0].dictionaryValue["value"]?.stringValue {

                            middleName = stringResult
                            middleNameTuple = (middleName, id)
                        }
                    }
                }

                if tempName == "title" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringResult = tempValues[0].dictionaryValue["value"]?.stringValue {

                            title = stringResult
                            titleTuple = (title, id)
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

                if tempName == "first_name" {

                    firstName = ""
                    firstNameTuple = (firstName, id)
                }

                if tempName == "last_name" {

                    lastName = ""
                    lastNameTuple = (lastName, id)
                }

                if tempName == "preferred_name" {

                    prefferedName = ""
                    prefferedNameTuple = (prefferedName, id)
                }

                if tempName == "middle_name" {

                    middleName = ""
                    middleNameTuple = (middleName, id)
                }

                if tempName == "title" {

                    title = ""
                    titleTuple = (title, id)
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
            "first_name": self.firstName,
            "last_name": self.lastName,
            "preferred_name": self.prefferedName,
            "middle_name": self.middleName,
            "title": self.title
        ]
    }

}
