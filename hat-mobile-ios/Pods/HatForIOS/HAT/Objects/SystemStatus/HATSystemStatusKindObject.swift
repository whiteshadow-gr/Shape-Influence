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

/// A class representing the system status kind object
public struct HATSystemStatusKindObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATSystemStatusKindObject, rhs: HATSystemStatusKindObject) -> Bool {

        return (lhs.metric == rhs.metric && lhs.kind == rhs.kind && lhs.units == rhs.units)
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
    public static func < (lhs: HATSystemStatusKindObject, rhs: HATSystemStatusKindObject) -> Bool {

        return lhs.metric < rhs.metric && lhs.kind == rhs.kind
    }

    // MARK: - Variables

    /// The value of the object
    public var metric: String = ""
    /// The kind of the value of the object
    public var kind: String = ""
    /// The unit type of the value of the object
    public var units: String?

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        metric = ""
        kind = ""
        units = nil
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempMetric = dictionary["metric"]?.stringValue {

            metric = tempMetric
        }
        if let tempKind = dictionary["kind"]?.stringValue {

            kind = tempKind
        }
        if let tempUnits = dictionary["units"]?.stringValue {

            units = tempUnits
        }
    }
}
