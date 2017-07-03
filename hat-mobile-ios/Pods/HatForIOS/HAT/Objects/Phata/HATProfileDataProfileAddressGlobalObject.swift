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

/// A struct representing the profile data Address Global object from the received profile JSON file
public struct HATProfileDataProfileAddressGlobalObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileDataProfileAddressGlobalObject, rhs: HATProfileDataProfileAddressGlobalObject) -> Bool {

        return (lhs.isPrivate == rhs.isPrivate && lhs.city == rhs.city && lhs.country == rhs.country && lhs.county == rhs.county)
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
    public static func < (lhs: HATProfileDataProfileAddressGlobalObject, rhs: HATProfileDataProfileAddressGlobalObject) -> Bool {

        return lhs.city < rhs.city
    }

    // MARK: - Variables

    /// Indicates if the object, HATProfileDataProfileAddressGlobalObject, is private
    public var isPrivate: Bool = true {

        didSet {

            isPrivateTuple = (isPrivate, isPrivateTuple.1)
        }
    }

    /// User's City
    public var city: String = "" {

        didSet {

            cityTuple = (city, cityTuple.1)
        }
    }
    /// User's Country
    public var country: String = "" {

        didSet {

            countryTuple = (country, countryTuple.1)
        }
    }
    /// User's County
    public var county: String = "" {

        didSet {

            countyTuple = (county, countyTuple.1)
        }
    }

    /// A tuple containing the isPrivate and the ID of the value
    var isPrivateTuple: (Bool, Int) = (true, 0)

    /// A tuple containing the value and the ID of the value
    var cityTuple: (String, Int) = ("", 0)

    /// A tuple containing the isPrivate and the ID of the value
    var countryTuple: (String, Int) = ("", 0)

    /// A tuple containing the value and the ID of the value
    var countyTuple: (String, Int) = ("", 0)

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        isPrivate = true
        city = ""
        county = ""
        country = ""

        isPrivateTuple = (true, 0)
        cityTuple = ("", 0)
        countyTuple = ("", 0)
        countryTuple = ("", 0)
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

                            if let boolResult = Bool(stringValue) {

                                isPrivate = boolResult
                                isPrivateTuple = (isPrivate, id)
                            }
                        }
                    }
                }

                if tempName == "city" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringValue = tempValues[0].dictionaryValue["value"]?.stringValue {

                            city = stringValue
                            cityTuple = (city, id)
                        }
                    }
                }

                if tempName == "county" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringValue = tempValues[0].dictionaryValue["value"]?.stringValue {

                            county = stringValue
                            countyTuple = (county, id)
                        }
                    }
                }

                if tempName == "country" {

                    if let tempValues = dict["values"]?.arrayValue {

                        if let stringValue = tempValues[0].dictionaryValue["value"]?.stringValue {

                            country = stringValue
                            countryTuple = (country, id)
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

                if tempName == "city" {

                    city = ""
                    cityTuple = (city, id)
                }

                if tempName == "county" {

                    county = ""
                    countyTuple = (county, id)
                }

                if tempName == "country" {

                    country = ""
                    countryTuple = (country, id)
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
            "city": self.city,
            "county": self.county,
            "country": self.country
        ]
    }
}
