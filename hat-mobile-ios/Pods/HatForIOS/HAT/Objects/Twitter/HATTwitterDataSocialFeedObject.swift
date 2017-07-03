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

/// A class representing the data of the tweet
public struct HATTwitterDataSocialFeedObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATTwitterDataSocialFeedObject, rhs: HATTwitterDataSocialFeedObject) -> Bool {

        return (lhs.tweets == rhs.tweets)
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
    public static func < (lhs: HATTwitterDataSocialFeedObject, rhs: HATTwitterDataSocialFeedObject) -> Bool {

        return lhs.tweets < rhs.tweets
    }

    // MARK: - Variables

    /// The tweet data
    public var tweets: HATTwitterDataTweetsSocialFeedObject = HATTwitterDataTweetsSocialFeedObject()

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        tweets = HATTwitterDataTweetsSocialFeedObject()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempTweets = dictionary["tweets"]?.dictionaryValue {

            tweets = HATTwitterDataTweetsSocialFeedObject(from: tempTweets)
        }
    }
}
