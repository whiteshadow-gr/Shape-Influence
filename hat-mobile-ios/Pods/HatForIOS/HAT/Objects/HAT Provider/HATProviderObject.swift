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

/// A class representing the hat provider object
public struct HATProviderObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProviderObject, rhs: HATProviderObject) -> Bool {

        return (lhs.sku == rhs.sku && lhs.name == rhs.name && lhs.description == rhs.description && lhs.details == rhs.details && lhs.illustration == rhs.illustration && lhs.price == rhs.price && lhs.available == rhs.available && lhs.purchased == rhs.purchased && lhs.ordering == rhs.ordering && lhs.features == rhs.features && lhs.hatProviderImage == rhs.hatProviderImage && lhs.category == rhs.category && lhs.kind == rhs.kind && lhs.paymentType == rhs.paymentType)
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
    public static func < (lhs: HATProviderObject, rhs: HATProviderObject) -> Bool {

        return lhs.ordering < rhs.ordering
    }

    // MARK: - Variables

    /// The hat provider's sku number
    public var sku: String = ""
    /// The hat provider's name
    public var name: String = ""
    /// The hat provider's description
    public var description: String = ""
    /// The hat provider's details
    public var details: String = ""
    /// The hat provider's illustration url
    public var illustration: String = ""

    /// The hat provider's price
    public var price: Int = 0
    /// The hat provider's available hats
    public var available: Int = 0
    /// The hat provider's purchased hats
    public var purchased: Int = 0
    /// The hat provider's ordering
    public var ordering: Int = 0

    /// The hat provider's hat features
    public var features: [String] = []

    /// The hat provider's image
    public var hatProviderImage: UIImage?

    /// The hat provider's category object
    public var category: HATProviderCategoryObject = HATProviderCategoryObject()
    /// The hat provider's kind object
    public var kind: HATProviderKindObject = HATProviderKindObject()
    /// The hat provider's payment type
    public var paymentType: HATProviderPaymentObject = HATProviderPaymentObject()

    // MARK: Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        sku = ""
        name = ""
        description = ""
        details = ""
        illustration = ""

        price = 0
        available = 0
        purchased = 0
        ordering = 0

        features = []

        hatProviderImage = nil

        category = HATProviderCategoryObject()
        kind = HATProviderKindObject()
        paymentType = HATProviderPaymentObject()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempSKU = dictionary["sku"]?.stringValue {

            sku = tempSKU
        }
        if let tempName = dictionary["name"]?.stringValue {

            name = tempName
        }
        if let tempDescription = dictionary["description"]?.stringValue {

            description = tempDescription
        }
        if let tempDetails = dictionary["details"]?.stringValue {

            details = tempDetails
        }
        if let tempIllustration = dictionary["illustration"]?.stringValue {

            illustration = tempIllustration
        }

        if let tempPrice = dictionary["price"]?.intValue {

            price = tempPrice
        }
        if let tempAvailable = dictionary["available"]?.intValue {

            available = tempAvailable
        }
        if let tempPurchased = dictionary["purchased"]?.intValue {

            purchased = tempPurchased
        }
        if let tempOrdering = dictionary["ordering"]?.intValue {

            ordering = tempOrdering
        }

        if let tempFeatures = dictionary["features"]?.arrayValue {

            for item in tempFeatures {

               features.append(item.stringValue)
            }
        }

        if let tempKind = dictionary["kind"]?.dictionaryValue {

            kind = HATProviderKindObject(from: tempKind)
        }
        if let tempPaymentType = dictionary["paymentType"]?.dictionaryValue {

            paymentType = HATProviderPaymentObject(from: tempPaymentType)
        }
        if let tempCategory = dictionary["category"]?.dictionaryValue {

            category = HATProviderCategoryObject(from: tempCategory)
        }
    }
}
