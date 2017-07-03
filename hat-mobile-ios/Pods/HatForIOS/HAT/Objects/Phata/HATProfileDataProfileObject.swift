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

/// A struct representing the profile object from the received profile JSON file
public struct HATProfileDataProfileObject: Comparable {

    // MARK: - Comparable protocol

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: HATProfileDataProfileObject, rhs: HATProfileDataProfileObject) -> Bool {

        return (lhs.isPrivate == rhs.isPrivate && lhs.website == rhs.website && lhs.nick == rhs.nick && lhs.primaryEmail == rhs.primaryEmail && lhs.youtube == rhs.youtube && lhs.addressGlobal == rhs.addressGlobal && lhs.linkedIn == rhs.linkedIn && lhs.birth == rhs.birth && lhs.homePhone == rhs.homePhone && lhs.google == rhs.google && lhs.age == rhs.age && lhs.personal == rhs.personal && lhs.blog == rhs.blog && lhs.facebook == rhs.facebook && lhs.addressDetails == rhs.addressDetails && lhs.emergencyContact == rhs.emergencyContact && lhs.alternativeEmail == rhs.alternativeEmail && lhs.facebookProfilePhoto == rhs.facebookProfilePhoto && lhs.twitter == rhs.twitter && lhs.about == rhs.about && lhs.mobile == rhs.mobile && lhs.gender == rhs.gender)
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
    public static func < (lhs: HATProfileDataProfileObject, rhs: HATProfileDataProfileObject) -> Bool {

        return lhs.age < rhs.age
    }

    // MARK: - Variables

    /// Indicates if the object, HATProfileDataProfileObject, is private
    public var isPrivate: Bool = true {

        didSet {

            isPrivateTuple = (isPrivate, isPrivateTuple.1)
        }
    }

    /// A tuple containing the isPrivate and the ID of the value
    var isPrivateTuple: (Bool, Int) = (true, 0)

    /// The website object of user's profile
    public var website: HATProfileDataProfileWebsiteObject = HATProfileDataProfileWebsiteObject()
    /// The nickname object of user's profile
    public var nick: HATProfileDataProfileNickObject = HATProfileDataProfileNickObject()
    /// The primary email address object of user's profile
    public var primaryEmail: HATProfileDataProfilePrimaryEmailObject = HATProfileDataProfilePrimaryEmailObject()
    /// The youtube object of user's profile
    public var youtube: HATProfileDataProfileYoutubeObject = HATProfileDataProfileYoutubeObject()
    /// The global addres object of user's profile
    public var addressGlobal: HATProfileDataProfileAddressGlobalObject = HATProfileDataProfileAddressGlobalObject()
    /// The linkedIn object of user's profile
    public var linkedIn: HATProfileDataProfileLinkedInObject = HATProfileDataProfileLinkedInObject()
    /// The birth date object of user's profile
    public var birth: HATProfileDataProfileBirthObject = HATProfileDataProfileBirthObject()
    /// The home phone number object of user's profile
    public var homePhone: HATProfileDataProfileHomePhoneObject = HATProfileDataProfileHomePhoneObject()
    /// The google object of user's profile
    public var google: HATProfileDataProfileGoogleObject = HATProfileDataProfileGoogleObject()
    /// The age object of user's profile
    public var age: HATProfileDataProfileAgeObject = HATProfileDataProfileAgeObject()
    /// The persoal info object of user's profile
    public var personal: HATProfileDataProfilePersonalObject = HATProfileDataProfilePersonalObject()
    /// The blog object of user's profile
    public var blog: HATProfileDataProfileBlogObject = HATProfileDataProfileBlogObject()
    /// The facebook object of user's profile
    public var facebook: HATProfileDataProfileFacebookObject = HATProfileDataProfileFacebookObject()
    /// The address details object of user's profile
    public var addressDetails: HATProfileDataProfileAddressDetailObject = HATProfileDataProfileAddressDetailObject()
    /// The emergency contact object of user's profile
    public var emergencyContact: HATProfileDataProfileEmergencyContactObject = HATProfileDataProfileEmergencyContactObject()
    /// The alternative email address object of user's profile
    public var alternativeEmail: HATProfileDataProfileAlternativeEmailObject = HATProfileDataProfileAlternativeEmailObject()
    /// The facebook profile photo object of user's profile
    public var facebookProfilePhoto: HATProfileDataProfileFacebookProfilePhotoObject = HATProfileDataProfileFacebookProfilePhotoObject()
    /// The twitter object of user's profile
    public var twitter: HATProfileDataProfileTwitterObject = HATProfileDataProfileTwitterObject()
    /// The about object of user's profile
    public var about: HATProfileDataProfileAboutObject = HATProfileDataProfileAboutObject()
    /// The mobile phone number object of user's profile
    public var mobile: HATProfileDataProfileMobileObject = HATProfileDataProfileMobileObject()
    /// The gender object of user's profile
    public var gender: HATProfileDataProfileGenderObject = HATProfileDataProfileGenderObject()

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        isPrivate = true
        isPrivateTuple = (true, 0)

        website = HATProfileDataProfileWebsiteObject()
        nick = HATProfileDataProfileNickObject()
        primaryEmail = HATProfileDataProfilePrimaryEmailObject()
        youtube = HATProfileDataProfileYoutubeObject()
        addressGlobal = HATProfileDataProfileAddressGlobalObject()
        linkedIn = HATProfileDataProfileLinkedInObject()
        birth = HATProfileDataProfileBirthObject()
        homePhone = HATProfileDataProfileHomePhoneObject()
        google = HATProfileDataProfileGoogleObject()
        age = HATProfileDataProfileAgeObject()
        personal = HATProfileDataProfilePersonalObject()
        blog = HATProfileDataProfileBlogObject()
        facebook = HATProfileDataProfileFacebookObject()
        addressDetails = HATProfileDataProfileAddressDetailObject()
        emergencyContact = HATProfileDataProfileEmergencyContactObject()
        alternativeEmail = HATProfileDataProfileAlternativeEmailObject()
        facebookProfilePhoto = HATProfileDataProfileFacebookProfilePhotoObject()
        twitter = HATProfileDataProfileTwitterObject()
        about = HATProfileDataProfileAboutObject()
        mobile = HATProfileDataProfileMobileObject()
        gender = HATProfileDataProfileGenderObject()
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dict: Dictionary<String, JSON>) {

        if let tempFieldsDictionary = (dict["fields"]?.arrayValue[0].dictionaryValue) {

            if let tempPrivateValue = tempFieldsDictionary["values"]?[0]["value"].stringValue {

                isPrivate = Bool(tempPrivateValue)!
                isPrivateTuple = (isPrivate, (tempFieldsDictionary["id"]?.intValue)!)
            }
        }

        if let tempSubTables = (dict["subTables"]?.arrayValue) {

            for subtable in tempSubTables {

                let tempName = (subtable["name"].stringValue)

                if tempName == "website" {

                    website = HATProfileDataProfileWebsiteObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "nick" {

                    nick = HATProfileDataProfileNickObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "primary_email" {

                    primaryEmail = HATProfileDataProfilePrimaryEmailObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "youtube" {

                    youtube = HATProfileDataProfileYoutubeObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "address_global" {

                    addressGlobal = HATProfileDataProfileAddressGlobalObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "linkedin" {

                    linkedIn = HATProfileDataProfileLinkedInObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "birth" {

                    birth = HATProfileDataProfileBirthObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "home_phone" {

                    homePhone = HATProfileDataProfileHomePhoneObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "google" {

                    google = HATProfileDataProfileGoogleObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "age" {

                    age = HATProfileDataProfileAgeObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "personal" {

                    personal = HATProfileDataProfilePersonalObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "blog" {

                    blog = HATProfileDataProfileBlogObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "facebook" {

                    facebook = HATProfileDataProfileFacebookObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "address_details" {

                    addressDetails = HATProfileDataProfileAddressDetailObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "emergency_contact" {

                    emergencyContact = HATProfileDataProfileEmergencyContactObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "alternative_email" {

                    alternativeEmail = HATProfileDataProfileAlternativeEmailObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "fb_profile_photo" {

                    facebookProfilePhoto = HATProfileDataProfileFacebookProfilePhotoObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "twitter" {

                    twitter = HATProfileDataProfileTwitterObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "about" {

                    about = HATProfileDataProfileAboutObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "mobile" {

                    mobile = HATProfileDataProfileMobileObject(from: (subtable["fields"].arrayValue))
                }

                if tempName == "gender" {

                    gender = HATProfileDataProfileGenderObject(from: (subtable["fields"].arrayValue))
                }
            }
        }
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(alternativeDictionary: Dictionary<String, JSON>) {

        if let tempFieldsDictionary = (alternativeDictionary["fields"]?.arrayValue[0].dictionaryValue) {

            isPrivate = true
            isPrivateTuple = (isPrivate, (tempFieldsDictionary["id"]?.intValue)!)
        }

        if let tempSubTables = (alternativeDictionary["subTables"]?.arrayValue) {

            for subtable in tempSubTables {

                let tempName = (subtable["name"].stringValue)

                if tempName == "website" {

                    website = HATProfileDataProfileWebsiteObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "nick" {

                    nick = HATProfileDataProfileNickObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "primary_email" {

                    primaryEmail = HATProfileDataProfilePrimaryEmailObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "youtube" {

                    youtube = HATProfileDataProfileYoutubeObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "address_global" {

                    addressGlobal = HATProfileDataProfileAddressGlobalObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "linkedin" {

                    linkedIn = HATProfileDataProfileLinkedInObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "birth" {

                    birth = HATProfileDataProfileBirthObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "home_phone" {

                    homePhone = HATProfileDataProfileHomePhoneObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "google" {

                    google = HATProfileDataProfileGoogleObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "age" {

                    age = HATProfileDataProfileAgeObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "personal" {

                    personal = HATProfileDataProfilePersonalObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "blog" {

                    blog = HATProfileDataProfileBlogObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "facebook" {

                    facebook = HATProfileDataProfileFacebookObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "address_details" {

                    addressDetails = HATProfileDataProfileAddressDetailObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "emergency_contact" {

                    emergencyContact = HATProfileDataProfileEmergencyContactObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "alternative_email" {

                    alternativeEmail = HATProfileDataProfileAlternativeEmailObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "fb_profile_photo" {

                    facebookProfilePhoto = HATProfileDataProfileFacebookProfilePhotoObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "twitter" {

                    twitter = HATProfileDataProfileTwitterObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "about" {

                    about = HATProfileDataProfileAboutObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "mobile" {

                    mobile = HATProfileDataProfileMobileObject(alternativeArray: (subtable["fields"].arrayValue))
                }

                if tempName == "gender" {

                    gender = HATProfileDataProfileGenderObject(alternativeArray: (subtable["fields"].arrayValue))
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

            "website": self.website.toJSON(),
            "nick": self.nick.toJSON(),
            "primary_email": self.primaryEmail.toJSON(),
            "private": String(describing: self.isPrivate),
            "youtube": self.youtube.toJSON(),
            "address_global": self.addressGlobal.toJSON(),
            "linkedin": self.linkedIn.toJSON(),
            "birth": self.birth.toJSON(),
            "home_phone": self.homePhone.toJSON(),
            "google": self.google.toJSON(),
            "age": self.age.toJSON(),
            "personal": self.personal.toJSON(),
            "blog": self.blog.toJSON(),
            "facebook": self.facebook.toJSON(),
            "address_details": self.addressDetails.toJSON(),
            "emergency_contact": self.emergencyContact.toJSON(),
            "alternative_email": self.alternativeEmail.toJSON(),
            "fb_profile_photo": self.facebookProfilePhoto.toJSON(),
            "twitter": self.twitter.toJSON(),
            "about": self.about.toJSON(),
            "mobile": self.mobile.toJSON(),
            "gender": self.gender.toJSON()
        ]
    }

}
