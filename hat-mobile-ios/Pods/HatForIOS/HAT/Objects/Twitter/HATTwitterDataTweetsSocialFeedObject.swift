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

/// A class representing the actual data of the tweet
public struct HATTwitterDataTweetsSocialFeedObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATTwitterDataTweetsSocialFeedObject, rhs: HATTwitterDataTweetsSocialFeedObject) -> Bool {

        return (lhs.source == rhs.source && lhs.truncated == rhs.truncated && lhs.retweetCount == rhs.retweetCount
            && lhs.retweeted == rhs.retweeted && lhs.favoriteCount == rhs.favoriteCount && lhs.tweetID == rhs.tweetID && lhs.text == rhs.text && lhs.favorited == rhs.favorited && lhs.lang == rhs.lang)
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
    public static func < (lhs: HATTwitterDataTweetsSocialFeedObject, rhs: HATTwitterDataTweetsSocialFeedObject) -> Bool {

        if lhs.createdAt != nil && rhs.createdAt != nil {

            return lhs.createdAt! < rhs.createdAt!
        } else if lhs.createdAt != nil && rhs.createdAt == nil {

            return false
        } else {

            return true
        }
    }

    // MARK: - Variables

    /// The source of the tweet
    public var source: String = ""
    /// Shows if the tweet is truncated or not
    public var truncated: String = ""
    /// Shows the retweet count
    public var retweetCount: String = ""
    /// Shows if the tweet has been retweeted
    public var retweeted: String = ""
    /// Shows the tweet's favourites count
    public var favoriteCount: String = ""
    /// Shows the tweet's id
    public var tweetID: String = ""
    /// Shows the text of the tweet
    public var text: String = ""
    /// Shows if the tweet is favourited or not
    public var favorited: String = ""
    /// Shows the language of the tweet
    public var lang: String = ""

    /// Shows the date that the tweet has been created
    public var createdAt: Date?

    /// Shows the user's info
    public var user: HATTwitterDataTweetsUsersSocialFeedObject = HATTwitterDataTweetsUsersSocialFeedObject()

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        source = ""
        truncated = ""
        retweetCount = ""
        retweeted = ""
        favoriteCount = ""
        tweetID = ""
        text = ""
        createdAt = nil
        favorited = ""
        lang = ""
        user = HATTwitterDataTweetsUsersSocialFeedObject()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempSource = dictionary["source"]?.stringValue {

            source = tempSource
        }
        if let tempTruncated = dictionary["truncated"]?.stringValue {

            truncated = tempTruncated
        }
        if let tempRetweetCount = dictionary["retweet_count"]?.stringValue {

            retweetCount = tempRetweetCount
        }
        if let tempRetweeted = dictionary["retweeted"]?.stringValue {

            retweeted = tempRetweeted
        }
        if let tempFavouriteCount = dictionary["favorite_count"]?.stringValue {

            favoriteCount = tempFavouriteCount
        }
        if let tempID = dictionary["id"]?.stringValue {

            tweetID = tempID
        }
        if let tempText = dictionary["text"]?.stringValue {

            text = tempText
        }
        if let tempCreatedAt = dictionary["created_at"]?.stringValue {

            createdAt = HATFormatterHelper.formatStringToDate(string: tempCreatedAt)
        }
        if let tempFavorited = dictionary["favorited"]?.stringValue {

            favorited = tempFavorited
        }
        if let tempLang = dictionary["lang"]?.stringValue {

            lang = tempLang
        }
        if let tempUser = dictionary["user"]?.dictionaryValue {

            user = HATTwitterDataTweetsUsersSocialFeedObject(from: tempUser)
        }
    }
}
