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

public struct HATProfileRelationshipAndHouseholdObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileRelationshipAndHouseholdObject, rhs: HATProfileRelationshipAndHouseholdObject) -> Bool {

        return (lhs.relationshipStatus == rhs.relationshipStatus && lhs.typeOfAccomodation == rhs.typeOfAccomodation && lhs.livingSituation == rhs.livingSituation && lhs.livingSituation == rhs.livingSituation && lhs.howManyUsuallyLiveInYourHousehold == rhs.howManyUsuallyLiveInYourHousehold && lhs.householdOwnership == rhs.householdOwnership && lhs.hasChildren == rhs.hasChildren && lhs.additionalDependents == rhs.additionalDependents && lhs.numberOfChildren == rhs.numberOfChildren && lhs.unixTimeStamp == rhs.unixTimeStamp)
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
    public static func < (lhs: HATProfileRelationshipAndHouseholdObject, rhs: HATProfileRelationshipAndHouseholdObject) -> Bool {

        return lhs.unixTimeStamp! < rhs.unixTimeStamp!
    }

    // MARK: - Variables

    public var relationshipStatus: String = ""
    public var typeOfAccomodation: String = ""
    public var livingSituation: String = ""
    public var howManyUsuallyLiveInYourHousehold: String = ""
    public var householdOwnership: String = ""
    public var hasChildren: String = ""
    public var additionalDependents: String = ""
    public var recordID: String = ""

    public var unixTimeStamp: Int?
    public var numberOfChildren: Int = 0

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        relationshipStatus = ""
        typeOfAccomodation = ""
        livingSituation = ""
        howManyUsuallyLiveInYourHousehold = ""
        householdOwnership = ""
        hasChildren = ""
        additionalDependents = ""
        recordID = ""

        unixTimeStamp = nil
        numberOfChildren = 0
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dict: JSON) {

        if let data = (dict["data"].dictionary) {

            relationshipStatus = (data["relationshipStatus"]!.stringValue)
            typeOfAccomodation = (data["typeOfAccomodation"]!.stringValue)
            livingSituation = (data["livingSituation"]!.stringValue)
            howManyUsuallyLiveInYourHousehold = (data["howManyUsuallyLiveInYourHousehold"]!.stringValue)
            householdOwnership = (data["householdOwnership"]!.stringValue)
            hasChildren = (data["hasChildren"]!.stringValue)
            additionalDependents = (data["additionalDependents"]!.stringValue)
            numberOfChildren = (data["numberOfChildren"]!.intValue)

            if let time = (data["unixTimeStamp"]?.stringValue) {

                unixTimeStamp = Int(time)
            }
        }

        recordID = (dict["recordId"].stringValue)
    }

    // MARK: - JSON Mapper

    /**
     Returns the object as Dictionary, JSON
     
     - returns: Dictionary<String, String>
     */
    public func toJSON() -> Dictionary<String, Any> {

        return [

            "relationshipStatus": self.relationshipStatus,
            "typeOfAccomodation": self.typeOfAccomodation,
            "livingSituation": self.livingSituation,
            "howManyUsuallyLiveInYourHousehold": self.howManyUsuallyLiveInYourHousehold,
            "householdOwnership": self.householdOwnership,
            "hasChildren": self.hasChildren,
            "additionalDependents": self.additionalDependents,
            "numberOfChildren": self.numberOfChildren,
            "unixTimeStamp": Int(HATFormatterHelper.formatDateToEpoch(date: Date())!)!
        ]
    }

}
