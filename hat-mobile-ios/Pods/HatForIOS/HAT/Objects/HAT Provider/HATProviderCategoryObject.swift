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

/// A class representing the hat provider category object
public struct HATProviderCategoryObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProviderCategoryObject, rhs: HATProviderCategoryObject) -> Bool {

        return (lhs.categoryId == rhs.categoryId && lhs.title == rhs.title && lhs.description == rhs.description && lhs.illustration == rhs.illustration)
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
    public static func < (lhs: HATProviderCategoryObject, rhs: HATProviderCategoryObject) -> Bool {

        return lhs.title < rhs.title
    }

    /// MARK: - Variables

    /// The hat provider's category id
    public var categoryId: Int = 0

    /// The hat provider's category title
    public var title: String = ""
    /// The hat provider's category description
    public var description: String = ""
    /// The hat provider's category illustration url
    public var illustration: String = ""

    /// MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        categoryId = 0

        title = ""
        description = ""
        illustration = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempCategoryId = dictionary["categoryId"]?.intValue {

            categoryId = tempCategoryId
        }

        if let tempTitle = dictionary["title"]?.stringValue {

            title = tempTitle
        }
        if let tempDescription = dictionary["description"]?.stringValue {

            description = tempDescription
        }
        if let tempIllustration = dictionary["illustration"]?.stringValue {

            illustration = tempIllustration
        }
    }
}
