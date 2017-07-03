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

public class HATPhataService: NSObject {

    // MARK: - Get Phata

    /**
     Searches for profile table and fetches the entries
     
     - parameter userDomain: The user's HAT domain
     - parameter userToken: The user's token
     - parameter successCallback: A function to call on success
     - parameter failCallback: A fuction to call on fail
     */
    public class func getProfileFromHAT(userDomain: String, userToken: String, successCallback: @escaping (HATProfileObject) -> Void, failCallback: @escaping (HATTableError) -> Void) {

        func tableFound (tableID: NSNumber, newToken: String?) {

            func profileEntries(json: [JSON], renewedToken: String?) {

                // if we have values return them
                if !json.isEmpty {

                    let array = HATProfileObject(from: json[0].dictionaryValue)
                    successCallback(array)
                    // in case no values have found then that means that the users hasn't entered anything yet so we have to get the structure from the ccheckHatTableExistsForUploading method in order to have the id's
                } else {

                    HATAccountService.checkHatTableExistsForUploading(
                        userDomain: userDomain,
                        tableName: "profile",
                        sourceName: "rumpel",
                        authToken: userToken,
                        successCallback: { (dict) in

                            if let unwrappedDictionary = dict.0 as? Dictionary<String, JSON> {
                                
                                let array = HATProfileObject(alternativeDictionary: unwrappedDictionary)
                                successCallback(array)
                            }
                        },
                        errorCallback: {(_) in

                            failCallback(HATTableError.noValuesFound)
                        }
                    )
                }
            }

            HATAccountService.getHatTableValuesWithOutPretty(token: userToken, userDomain: userDomain, tableID: tableID, parameters: ["starttime": "0"], successCallback: profileEntries, errorCallback: failCallback)
        }

        HATAccountService.checkHatTableExists(userDomain: userDomain, tableName: "profile", sourceName: "rumpel", authToken: userToken, successCallback: tableFound, errorCallback: failCallback)
    }

    // MARK: - Post Profile

    /**
     Posts the profile record to the hat
     
     - parameter userDomain: The user's Domain
     - parameter userToken: The user's token
     - parameter hatProfile: The profile to be used to update the JSON send to the hat
     - parameter successCallBack: A Function to execute on success
     - parameter errorCallback: A Function to execute on error
     */
    public class func postProfile(userDomain: String, userToken: String, hatProfile: HATProfileObject, successCallBack: @escaping () -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        func posting(resultJSON: Dictionary<String, Any>, token: String?) {

            // create the headers
            let headers = ["Accept": ContentType.JSON,
                           "Content-Type": ContentType.JSON,
                           "X-Auth-Token": userToken]

            // create JSON file for posting with default values
            let hatDataStructure = HATJSONHelper.createJSONForPosting(hatTableStructure: resultJSON)
            // update JSON file with the values needed
            let hatData = HATJSONHelper.updateProfileJSONFile(file: hatDataStructure, profileFile: hatProfile)

            // make async request
            HATNetworkHelper.asynchronousRequest("https://" + userDomain + "/data/record/values", method: HTTPMethod.post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: hatData, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                // handle result
                switch response {

                case .isSuccess(let isSuccess, _, _, _):

                    if isSuccess {

                        // reload table
                        successCallBack()

                        HATAccountService.triggerHatUpdate(userDomain: userDomain, completion: { () })
                    }

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                }
            })
        }

        func errorCall(error: HATTableError) {

        }

        HATAccountService.checkHatTableExistsForUploading(userDomain: userDomain, tableName: "profile", sourceName: "rumpel", authToken: userToken, successCallback: posting, errorCallback: errorCall)
    }

}
