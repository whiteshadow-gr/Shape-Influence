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

// MARK: Class

/// The location data plug service class
public class HATLocationService: NSObject {

    // MARK: - Create location plug URL

    /**
     Register with HAT url
     
     - parameter userHATDomain: The user's hat domain
     - returns: HATRegistrationURLAlias, can return empty string
     */
    public class func locationDataPlugURL(_ userHATDomain: String, dataPlugID: String) -> String {

        if let escapedUserHATDomain: String = userHATDomain.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {

            let url: String = "https://dex.hubofallthings.com/api/dataplugs/" +
                dataPlugID + "/" + "connect?hat=" + escapedUserHATDomain

            return url
        }

        return ""
    }

    // MARK: - Enable locations

    /**
     Registers app to write on HAT
     
     - parameter userDomain: The user's domain
     - parameter HATDomainFromToken: The HAT domain from token
     - parameter viewController: The UIViewController that calls this method
     */
   public class func enableLocationDataPlug(_ userDomain: String, _ HATDomainFromToken: String, success: @escaping (Bool) -> Void, failed: @escaping (JSONParsingError) -> Void) {

        // parameters..
        let parameters: Dictionary<String, String> = [:]

        // auth header
        let headers: [String : String] = ["Accept": ContentType.JSON,
                                          "Content-Type": ContentType.JSON,
                                          RequestHeaders.xAuthToken: HATDataPlugCredentials.locationDataPlugToken]
        // construct url
        let url = HATLocationService.locationDataPlugURL(userDomain, dataPlugID: HATDataPlugCredentials.dataPlugID)

        // make asynchronous call
        HATNetworkHelper.asynchronousRequest(url, method: HTTPMethod.get, encoding: Alamofire.URLEncoding.default, contentType: "application/json", parameters: parameters, headers: headers) { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess {

                    // belt and braces.. check we have a message in the returned JSON
                    if result["message"].exists() {

                        // save the hatdomain from the token to the device Keychain
                        success(true)
                    // No message field in JSON file
                    } else {

                        failed(.expectedFieldNotFound)
                    }
                // general error
                } else {

                    failed(.generalError(isSuccess.description, statusCode, nil))
                }

            case .error(let error, let statusCode):

                //show error
                let message = NSLocalizedString("Server responded with error", comment: "")
                failed(.generalError(message, statusCode, error))
                break
            }
        }
    }
}
