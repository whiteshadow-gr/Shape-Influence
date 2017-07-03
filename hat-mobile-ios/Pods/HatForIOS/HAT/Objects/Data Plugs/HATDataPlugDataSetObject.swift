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

/// A class representing the data plug dataset from data plug JSON file
public struct HATDataPlugDataSetObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATDataPlugDataSetObject, rhs: HATDataPlugDataSetObject) -> Bool {

        return (lhs.name == rhs.name && lhs.description == rhs.description && lhs.fields == rhs.fields)
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
    public static func < (lhs: HATDataPlugDataSetObject, rhs: HATDataPlugDataSetObject) -> Bool {

        return lhs.name < rhs.name
    }
    // MARK: - Variables

    /// The name of the dataset
    public var name: String = ""
    /// The description of the dataset
    public var description: String = ""

    /// The fields of the dataset
    public var fields: [HATDataPlugDataSetObject] = []

    // MARK: - Initialiazers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        name = ""
        description = ""
        fields = []
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {

        if let tempName = (dict["name"]?.stringValue) {

            name = tempName
        }
        if let tempDescription = (dict["description"]?.stringValue) {

            description = tempDescription
        }
        if let tempFields = (dict["fields"]?.dictionaryValue) {

            fields = [HATDataPlugDataSetObject(dict: tempFields)]
        }
    }
}
