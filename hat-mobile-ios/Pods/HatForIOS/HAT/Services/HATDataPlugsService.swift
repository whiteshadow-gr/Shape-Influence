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

/// The data plugs service class
public class HATDataPlugsService: NSObject {

    // MARK: - Get available data plugs

    /**
     Gets the available data plugs for the user to enable
     
     - parameter succesfulCallBack: A function of type ([HATDataPlugObject]) -> Void, executed on a successful result
     - parameter failCallBack: A function of type (Void) -> Void, executed on an unsuccessful result
     */
    public class func getAvailableDataPlugs(succesfulCallBack: @escaping ([HATDataPlugObject], String?) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {

        let url: String = "https://marketsquare.hubofallthings.com/api/dataplugs"

        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: [:], headers: [:], completion: { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            // in case of error call the failCallBack
            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallBack(.generalError(message, statusCode, error))
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):

                if isSuccess {

                    var returnValue: [HATDataPlugObject] = []

                    for item in result.arrayValue {

                        returnValue.append(HATDataPlugObject(dict: item.dictionaryValue))
                    }

                    succesfulCallBack(returnValue, token)
                } else {

                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }

    // MARK: - Claiming offers

    /**
     Check if offer is claimed
     
     - parameter offerID: The offerID as a String
     - parameter appToken: The application token as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public class func checkIfOfferIsClaimed(offerID: String, appToken: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {

        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers = ["X-Auth-Token": appToken]

        // contruct the url
        let url = "https://dex.hubofallthings.com/api/offer/" + offerID + "/userClaim"

        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            // in case of error call the failCallBack
            case .error(let error, let statusCode):

                if statusCode != 404 {

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                } else {

                    let message = NSLocalizedString("Expected response, 404", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess {

                    if statusCode == 200 {

                        if !result["confirmed"].boolValue {

                            succesfulCallBack(result["dataDebitId"].stringValue)
                        } else {

                            failCallBack(.noValueFound)
                        }
                    } else {

                        let message = NSLocalizedString("Server responded with different code than 200", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                } else {

                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }

    /**
     Claim offer with this ID
     
     - parameter offerID: The offerID as a String
     - parameter appToken: The application token as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public class func claimOfferWithOfferID(_ offerID: String, appToken: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {

        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers = ["X-Auth-Token": appToken]

        // contruct the url
        let url = "https://dex.hubofallthings.com/api/offer/" + offerID + "/claim"

        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            // in case of error call the failCallBack
            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallBack(.generalError(message, statusCode, error))
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess {

                    if statusCode == 200 {

                        succesfulCallBack(result["dataDebitId"].stringValue)
                    } else if statusCode == 400 {

                        failCallBack(.offerClaimed)
                    } else {
                        let message = NSLocalizedString("Server responded with different code than 200", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                } else {

                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }

    // MARK: - Data debits

    /**
     Approve data debit
     
     - parameter dataDebitID: The data debit ID as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public class func approveDataDebit(_ dataDebitID: String, userToken: String, userDomain: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {

        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers = ["X-Auth-Token": userToken]

        // contruct the url
        let url = "https://" + userDomain + "/dataDebit/" + dataDebitID + "/enable"

        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .put, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            // in case of error call the failCallBack
            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallBack(.generalError(message, statusCode, error))
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, _, _):

                if isSuccess {

                    if statusCode == 400 {

                        failCallBack(.offerClaimed)
                    }
                    succesfulCallBack("enabled")
                } else {

                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }

    /**
     Check data debit with this ID
     
     - parameter dataDebitID: The data debit ID as a String
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public class func checkDataDebit(_ dataDebitID: String, userToken: String, userDomain: String, succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {

        // setup parameters and headers
        let parameters: Dictionary<String, String> = [:]
        let headers = ["X-Auth-Token": userToken]

        // contruct the url
        let url = "https://" + userDomain + "/dataDebit/" + dataDebitID

        // make async request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            // in case of error call the failCallBack
            case .error( let error, let statusCode):

                if statusCode != 404 {

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                } else {

                    let message = NSLocalizedString("Expected response, 404", comment: "")
                    failCallBack(.generalError(message, statusCode, error))
                }
            // in case of success call succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, _):

                if isSuccess {

                    if result["enabled"].boolValue {

                        succesfulCallBack("enabled")
                    } else {

                        failCallBack(.noValueFound)
                    }
                } else {

                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }

    // MARK: - Social plug

    /**
     Check social plug
     
     - parameter succesfulCallBack: A function to call if everything is ok
     - parameter failCallBack: A function to call if fail
     */
    public class func checkSocialPlugAvailability(succesfulCallBack: @escaping (String) -> Void, failCallBack: @escaping (DataPlugError) -> Void) -> (_ appToken: String) -> Void {

        return { (appToken: String) in

            // setup parameters and headers
            let parameters: Dictionary<String, String> = [:]
            let headers = ["X-Auth-Token": appToken]

            // contruct the url
            let url = "https://social-plug.hubofallthings.com/api/user/token/status"

            // make async request
            HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                // in case of error call the failCallBack
                case .error(let error, let statusCode):

                    if statusCode == 404 {

                        let message = NSLocalizedString("Expected response, 404", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    } else {

                        let message = NSLocalizedString("Server responded with error", comment: "")
                        failCallBack(.generalError(message, statusCode, error))
                    }
                // in case of success call succesfulCallBack
                case .isSuccess(let isSuccess, let statusCode, let result, _):

                    if isSuccess {

                        succesfulCallBack(String(result["canPost"].boolValue))
                    } else {

                        let message = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                }
            })
        }
    }

}
