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

/// The facebook data plug service class
public class HATFacebookService: NSObject {

    // MARK: - Check facebook plug

    /**
     Fetches the facebook profile image of the user
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON]) -> Void) method executed on a successful response
     */
    public class func fetchProfileFacebookPhoto(authToken: String, userDomain: String, parameters: Dictionary<String, String>, success: @escaping (_ array: [JSON], String?) -> Void) {

        HATAccountService.checkHatTableExists(userDomain: userDomain,
                                              tableName: "profile_picture",
                                              sourceName: "facebook",
                                              authToken: authToken,
                                              successCallback: getPosts(token: authToken, userDomain: userDomain, parameters: parameters, success: success),
                                              errorCallback: { (_: HATTableError) -> Void in return })
    }

    /**
     Fetches the facebook profile image of the user with v2 API's
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON]) -> Void) method executed on a successful response
     */
    public class func fetchProfileFacebookPhotoV2(authToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATFacebookProfileImageObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        func sendObjectBack(jsonArray: [JSON], token: String?) {

            var array: [HATFacebookProfileImageObject] = []

            for object in jsonArray {

                array.append(HATFacebookProfileImageObject(from: object.dictionaryValue))
            }

            successCallback(array, token)
        }

        HATAccountService.getHatTableValuesv2(token: authToken, userDomain: userDomain, source: Facebook.sourceName, scope: "profile_picture", parameters: parameters, successCallback: sendObjectBack, errorCallback: errorCallback)
    }

    // MARK: - Facebook data plug

    /**
     Fetched the user's posts from facebook
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON]) -> Void) method executed on a successful response
     */
    public class func facebookDataPlug(authToken: String, userDomain: String, parameters: Dictionary<String, String>, success: @escaping (_ array: [JSON], String?) -> Void) {

        HATAccountService.checkHatTableExists(userDomain: userDomain,
                                              tableName: Facebook.tableName,
                                              sourceName: Facebook.sourceName,
                                              authToken: authToken,
                                              successCallback: getPosts(token: authToken, userDomain: userDomain, parameters: parameters, success: success),
                                              errorCallback: { (_: HATTableError) -> Void in return })
    }

    /**
     Fetched the user's posts from facebook with v2 API's
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON]) -> Void) method executed on a successful response
     */
    public class func getFacebookData(authToken: String, userDomain: String, parameters: Dictionary<String, String>, successCallback: @escaping (_ array: [HATFacebookSocialFeedObject], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        func sendObjectBack(jsonArray: [JSON], token: String?) {

            var array: [HATFacebookSocialFeedObject] = []

            for object in jsonArray {

                array.append(HATFacebookSocialFeedObject(from: object.dictionaryValue))
            }

            successCallback(array, token)
        }

        HATAccountService.getHatTableValuesv2(token: authToken, userDomain: userDomain, source: Facebook.sourceName, scope: Facebook.tableName, parameters: parameters, successCallback: sendObjectBack, errorCallback: errorCallback)
    }

    /**
     Checks if facebook plug is active
     
     - parameter token: The authorisation token to authenticate with the hat
     - parameter successful: An @escaping (Void) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    public class func isFacebookDataPlugActive(token: String, successful: @escaping (Bool) -> Void, failed: @escaping (DataPlugError) -> Void) {

        // construct the url, set parameters and headers for the request
        let url = Facebook.statusURL
        let parameters: Dictionary<String, String> = [:]
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: {(response: HATNetworkHelper.ResultType) -> Void in

            // act upon response
            switch response {

            case .isSuccess(let isSuccess, _, let result, _):

                if isSuccess && result["canPost"].boolValue == true {

                    successful(true)
                } else {

                    successful(false)
                }

            // inform user that there was an error
            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failed(.generalError(message, statusCode, error))
            }
        })
    }

    // MARK: - Get posts

    /**
     Gets the facebook posts from database
     
     - parameter authToken: The authorisation token to authenticate with the hat
     - parameter parameters: The parameters to use in the request
     - parameter success: An @escaping (_ array: [JSON]) -> Void) method executed on a successful response
     */
    private class func getPosts(token: String, userDomain: String, parameters: Dictionary<String, String>, success: @escaping (_ array: [JSON], String?) -> Void) -> (_ tableID: NSNumber, _ token: String?) -> Void {

        return {(tableID: NSNumber, returnedToken: String?) -> Void in

            HATAccountService.getHatTableValues(token: token, userDomain: userDomain, tableID: tableID, parameters: parameters, successCallback: success, errorCallback: { (_: HATTableError) -> Void in return })
        }
    }

    // MARK: - Get app token

    /**
     Gets application token for facebook
     
     - parameter successful: An @escaping (String) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    public class func getAppTokenForFacebook(token: String, userDomain: String, successful: @escaping (String, String?) -> Void, failed: @escaping (JSONParsingError) -> Void) {

        HATService.getApplicationTokenFor(serviceName: Facebook.serviceName, userDomain: userDomain, token: token, resource: Facebook.dataPlugURL, succesfulCallBack: successful, failCallBack: failed)
    }

    // MARK: - Remove duplicates

    /**
     Removes duplicates from a json file and returns the corresponding objects
     
     - parameter array: The JSON array
     - returns: An array of FacebookSocialFeedObject
     */
    public class func removeDuplicatesFrom(array: [JSON]) -> [HATFacebookSocialFeedObject] {

        // the array to return
        var arrayToReturn: [HATFacebookSocialFeedObject] = []

        // go through each dictionary object in the array
        for dictionary in array {

            // transform it to an FacebookSocialFeedObject
            let object = HATFacebookSocialFeedObject(from: dictionary.dictionaryValue)

            // check if the arrayToReturn it contains that value and if not add it
            let result = arrayToReturn.contains(where: {(post: HATFacebookSocialFeedObject) -> Bool in

                if object.data.posts.postID == post.data.posts.postID {

                    return true
                }

                return false
            })

            if !result {

                arrayToReturn.append(object)
            }
        }

        return arrayToReturn
    }

    /**
     Removes duplicates from an array of FacebookSocialFeedObject and returns the corresponding objects in an array
     
     - parameter array: The FacebookSocialFeedObject array
     - returns: An array of FacebookSocialFeedObject
     */
    public class func removeDuplicatesFrom(array: [HATFacebookSocialFeedObject]) -> [HATFacebookSocialFeedObject] {

        // the array to return
        var arrayToReturn: [HATFacebookSocialFeedObject] = []

        // go through each post object in the array
        for facebookPost in array {

            // check if the arrayToReturn it contains that value and if not add it
            let result = arrayToReturn.contains(where: {(post: HATFacebookSocialFeedObject) -> Bool in

                if facebookPost.data.posts.postID == post.data.posts.postID {

                    return true
                }

                return false
            })

            if !result {

                arrayToReturn.append(facebookPost)
            }
        }

        return arrayToReturn
    }
}
