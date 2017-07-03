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

/// A class representing the privacy settings of the post
public struct HATFacebookDataPostsPrivacySocialFeedObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATFacebookDataPostsPrivacySocialFeedObject, rhs: HATFacebookDataPostsPrivacySocialFeedObject) -> Bool {

        return (lhs.friends == rhs.friends && lhs.value == rhs.value && lhs.deny == rhs.deny && lhs.description == rhs.description && lhs.allow == rhs.allow)
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
    public static func < (lhs: HATFacebookDataPostsPrivacySocialFeedObject, rhs: HATFacebookDataPostsPrivacySocialFeedObject) -> Bool {

        return lhs.description < rhs.description
    }

    // MARK: - Variables

    /// Is it friends only?
    public var friends: String = ""
    /// The value
    public var value: String = ""
    /// deny access?
    public var deny: String = ""
    /// The desctiption of the setting
    public var description: String = ""
    /// Allow?
    public var allow: String = ""

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        friends = ""
        value = ""
        deny = ""
        description = ""
        allow = ""
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempFriends = dictionary["friends"]?.stringValue {

            friends = tempFriends
        }
        if let tempValue = dictionary["value"]?.stringValue {

            value = tempValue
        }
        if let tempDeny = dictionary["deny"]?.string {

            deny = tempDeny
        }
        if let tempDescription = dictionary["description"]?.stringValue {

            description = tempDescription
        }
        if let tempAllow = dictionary["allow"]?.stringValue {

            allow = tempAllow
        }
    }
}
