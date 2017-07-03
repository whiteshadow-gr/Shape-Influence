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

/// A class representing the outer data plug JSON format
public struct HATDataPlugObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATDataPlugObject, rhs: HATDataPlugObject) -> Bool {

        return (lhs.uuid == rhs.uuid && lhs.name == rhs.name && lhs.description == rhs.description && lhs.url == rhs.url && lhs.illustrationUrl == rhs.illustrationUrl && lhs.showCheckMark == rhs.showCheckMark && lhs.owner == rhs.owner && lhs.dataDefinition == rhs.dataDefinition && lhs.rating == rhs.rating && lhs.created == rhs.created && lhs.approved == rhs.approved && lhs.users == rhs.users)
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
    public static func < (lhs: HATDataPlugObject, rhs: HATDataPlugObject) -> Bool {

        if lhs.created != nil && rhs.created != nil {

            return lhs.created! < rhs.created!
        } else if lhs.created != nil && rhs.created == nil {

            return false
        } else {

            return true
        }
    }

    // MARK: - Variables

    /// The unique id of the data plug
    public var uuid: String = ""
    /// The name of the data plug
    public var name: String = ""
    /// The description of the data plug
    public var description: String = ""
    /// The url of the data plug
    public var url: String = ""
    /// The url of the image, asset, of the data plug
    public var illustrationUrl: String = ""
    /// The url of the image, asset, of the data plug
    public var showCheckMark: Bool = false

    /// The owner object of the data plug
    public var owner: HATDataPlugOwnerObject = HATDataPlugOwnerObject()
    /// The data definition object of the data plug
    public var dataDefinition: HATDataPlugDataDefinitionObject = HATDataPlugDataDefinitionObject()
    /// The rating object of the data plug
    public var rating: HATDataPlugRatingObject = HATDataPlugRatingObject()

    /// The created date of the data plug
    public var created: Date?

    /// The status of the data plug, if enabled is approved
    public var approved: Bool = false

    /// The users using the data plug
    public var users: Int = -1

    // MARK: - Initializers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        uuid = ""
        name = ""
        description = ""
        url = ""
        illustrationUrl = ""
        showCheckMark = false

        owner = HATDataPlugOwnerObject()
        dataDefinition = HATDataPlugDataDefinitionObject()
        rating = HATDataPlugRatingObject()

        created = nil

        approved = false

        users = -1
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(dict: Dictionary<String, JSON>) {

        if let tempUuid = (dict["uuid"]?.stringValue) {

            uuid = tempUuid
        }
        if let tempDescription = (dict["description"]?.stringValue) {

            description = tempDescription
        }
        if let tempName = (dict["name"]?.stringValue) {

            name = tempName
        }
        if let tempUrl = (dict["url"]?.stringValue) {

            url = tempUrl
        }
        if let tempIllustrationUrl = (dict["illustrationUrl"]?.stringValue) {

            illustrationUrl = tempIllustrationUrl
        }

        if let tempOwner = (dict["owner"]?.dictionaryValue) {

            owner = HATDataPlugOwnerObject(dict: tempOwner)
        }
        if let tempDefinition = (dict["dataDefinition"]?.dictionaryValue) {

            dataDefinition = HATDataPlugDataDefinitionObject(dict: tempDefinition)
        }
        if let tempRating = (dict["rating"]?.dictionaryValue) {

            rating = HATDataPlugRatingObject(dict: tempRating)
        }

        if let tempApproved = (dict["approved"]?.boolValue) {

            approved = tempApproved
        }

        if let tempCreated = (dict["created"]?.intValue) {

            created = HATFormatterHelper.formatStringToDate(string: String(tempCreated))
        }

        if let tempUsers = (dict["users"]?.intValue) {

            users = tempUsers
        }
    }
}
