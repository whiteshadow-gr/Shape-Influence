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

import Alamofire
import SwiftyJSON

// MARK: Class

public class HATProfileService: NSObject {

    // MARK: - Get profile nationality

    /**
     Gets the nationality of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func getNationalityFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATNationalityObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        func profileEntries(json: [JSON], renewedToken: String?) {

            // if we have values return them
            if !json.isEmpty {

                let array = HATNationalityObject(from: json.last!)
                successCallback(array)
            } else {

                failCallback(.noValuesFound)
            }
        }

        HATAccountService.getHatTableValuesv2(token: userToken, userDomain: userDomain, source: "rumpel", scope: "nationality", parameters: ["starttime": "0"], successCallback: profileEntries, errorCallback: failCallback)
    }

    // MARK: - Post profile nationality

    /**
     Posts user's nationality to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter nationality: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func postNationalityToHAT(userDomain: String, userToken: String, nationality: HATNationalityObject, successCallback: @escaping (HATNationalityObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        let json = nationality.toJSON()

        HATAccountService.createTableValuev2(
            token: userToken,
            userDomain: userDomain,
            source: "rumpel",
            dataPath: "nationality",
            parameters: json,
            successCallback: { (json, _) in

                successCallback(HATNationalityObject(from: json))
            },
            errorCallback: failCallback)
    }

    // MARK: - Get profile relationship and household

    /**
     Gets the profile relationship and household of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func getRelationshipAndHouseholdFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATProfileRelationshipAndHouseholdObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        func profileEntries(json: [JSON], renewedToken: String?) {

            // if we have values return them
            if !json.isEmpty {

                let array = HATProfileRelationshipAndHouseholdObject(from: json.last!)
                successCallback(array)
            } else {

                failCallback(.noValuesFound)
            }
        }

        HATAccountService.getHatTableValuesv2(token: userToken, userDomain: userDomain, source: "rumpel", scope: "relationshipAndHousehold", parameters: ["starttime": "0"], successCallback: profileEntries, errorCallback: failCallback)
    }

    // MARK: - Post profile relationship and household

    /**
     Posts user's profile relationship and household to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter relationshipAndHouseholdObject: The user's relationship and household data
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func postRelationshipAndHouseholdToHAT(userDomain: String, userToken: String, relationshipAndHouseholdObject: HATProfileRelationshipAndHouseholdObject, successCallback: @escaping (HATProfileRelationshipAndHouseholdObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        let json = relationshipAndHouseholdObject.toJSON()

        HATAccountService.createTableValuev2(
            token: userToken,
            userDomain: userDomain,
            source: "rumpel",
            dataPath: "relationshipAndHousehold",
            parameters: json,
            successCallback: {  (json, _) in

                successCallback(HATProfileRelationshipAndHouseholdObject(from: json))
            },
            errorCallback: failCallback
        )
    }

    // MARK: - Get profile education

    /**
     Gets the profile education of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func getEducationFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATProfileEducationObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        func profileEntries(json: [JSON], renewedToken: String?) {

            // if we have values return them
            if !json.isEmpty {

                let array = HATProfileEducationObject(from: json.last!)
                successCallback(array)
            } else {

                failCallback(.noValuesFound)
            }
        }

        HATAccountService.getHatTableValuesv2(token: userToken, userDomain: userDomain, source: "rumpel", scope: "education", parameters: ["starttime": "0"], successCallback: profileEntries, errorCallback: failCallback)
    }

    // MARK: - Post profile education

    /**
     Posts user's profile education to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter education: The user's education
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func postEducationToHAT(userDomain: String, userToken: String, education: HATProfileEducationObject, successCallback: @escaping (HATProfileEducationObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        let json = education.toJSON()

        HATAccountService.createTableValuev2(
            token: userToken,
            userDomain: userDomain,
            source: "rumpel",
            dataPath: "education",
            parameters: json,
            successCallback: { (json, _) in

                successCallback(HATProfileEducationObject(from: json))
            },
            errorCallback: failCallback
        )
    }

    // MARK: - Get Profile Image

    /**
     Gets the profile education of the user from the hat, if it's there already
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func getProfileImageFromHAT(userDomain: String, userToken: String, successCallback: @escaping (FileUploadObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        func profileEntries(json: [JSON], renewedToken: String?) {

            // if we have values return them
            if !json.isEmpty {

                let array = FileUploadObject(from: (json.last?.dictionaryValue)!)
                successCallback(array)
            } else {

                failCallback(.noValuesFound)
            }
        }

        HATAccountService.getHatTableValuesv2(token: userToken, userDomain: userDomain, source: "rumpel", scope: "profileImage", parameters: ["starttime": "0"], successCallback: profileEntries, errorCallback: failCallback)
    }

    // MARK: - Post profile Image

    /**
     Posts user's profile education to the hat
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter education: The user's education
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func postProfileImageToHAT(userDomain: String, userToken: String, image: FileUploadObject, successCallback: @escaping (FileUploadObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        let json = image.toJSON()

        HATAccountService.createTableValuev2(
            token: userToken,
            userDomain: userDomain,
            source: "rumpel",
            dataPath: "profileImage",
            parameters: json,
            successCallback: { (json, _) in

                successCallback(FileUploadObject(from: json.dictionaryValue))
            },
            errorCallback: failCallback
        )
    }

}
