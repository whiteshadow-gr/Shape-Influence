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

/// A class representing the application that this post came from
public struct HATFacebookDataPostsApplicationSocialFeedObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATFacebookDataPostsApplicationSocialFeedObject, rhs: HATFacebookDataPostsApplicationSocialFeedObject) -> Bool {

        return (lhs.applicationID == rhs.applicationID && lhs.namespace == rhs.namespace && lhs.name == rhs.name && lhs.category == rhs.category && lhs.link == rhs.link)
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
    public static func < (lhs: HATFacebookDataPostsApplicationSocialFeedObject, rhs: HATFacebookDataPostsApplicationSocialFeedObject) -> Bool {

        return lhs.name < rhs.name
    }

    // MARK: - Variables

    /// The id of the application
    public var applicationID: String = ""
    /// The namespace of the application
    public var namespace: String = ""
    /// The name of the application
    public var name: String = ""
    /// The category of the application
    public var category: String = ""
    /// The link of the application
    public var link: String = ""

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        applicationID = ""
        namespace = ""
        name = ""
        category = ""
        link = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempID = dictionary["id"]?.stringValue {

            applicationID = tempID
        }
        if let tempNameSpace = dictionary["namespace"]?.stringValue {

            namespace = tempNameSpace
        }
        if let tempName = dictionary["name"]?.string {

            name = tempName
        }
        if let tempCategory = dictionary["category"]?.stringValue {

            category = tempCategory
        }
        if let tempLink = dictionary["link"]?.stringValue {

            link = tempLink
        }
    }
}
