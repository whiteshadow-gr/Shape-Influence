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

/// A class about the methods concerning the user's HAT account
public class HATAccountService: NSObject {

    // MARK: - Get hat values from a table

    /**
     Gets values from a particular table in use with v1 API
     
     - parameter token: The token in String format
     - parameter userDomain: The user's domain in String format
     - parameter tableID: The table id as NSNumber
     - parameter parameters: The parameters to pass to the request, e.g. startime, endtime, limit
     - parameter successCallback: A callback called when successful of type @escaping ([JSON]) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public class func getHatTableValues(token: String, userDomain: String, tableID: NSNumber, parameters: Dictionary<String, String>, successCallback: @escaping ([JSON], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/data/table/" + tableID.stringValue + "/values?pretty=true"

        // create parameters and headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                case .isSuccess(let isSuccess, _, let result, let token):

                    if isSuccess {

                        if let array = result.array {
                            
                            successCallback(array, token)
                        } else {
                            
                            errorCallback(.noValuesFound)
                        }
                    }
                }
        })
    }

    /**
     Gets values from a particular table in use with v2 API
     
     - parameter token: The token in String format
     - parameter userDomain: The user's domain in String format
     - parameter dataPath: The table id as NSNumber
     - parameter parameters: The parameters to pass to the request, e.g. startime, endtime, limit
     - parameter successCallback: A callback called when successful of type @escaping ([JSON]) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public class func getHatTableValuesv2(token: String, userDomain: String, source: String, scope: String, parameters: Dictionary<String, String>, successCallback: @escaping ([JSON], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/api/v2/data/" + source + "/" + scope

        // create parameters and headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                case .isSuccess(let isSuccess, _, let result, let token):

                    if isSuccess {

                        if let array = result.array {
                            
                            successCallback(array, token)
                        } else {
                            
                            errorCallback(.noValuesFound)
                        }
                    }
                }
        })
    }

    /**
     Gets values from a particular table in use with v2 API
     
     - parameter token: The token in String format
     - parameter userDomain: The user's domain in String format
     - parameter dataPath: The table id as NSNumber
     - parameter parameters: The parameters to pass to the request, e.g. startime, endtime, limit
     - parameter successCallback: A callback called when successful of type @escaping ([JSON]) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public class func createTableValuev2(token: String, userDomain: String, source: String, dataPath: String, parameters: Dictionary<String, Any>, successCallback: @escaping (JSON, String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/api/v2/data/" + source + "/" + dataPath

        // create parameters and headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                case .isSuccess(let isSuccess, let statusCode, let result, let token):

                    if isSuccess {

                        successCallback(result, token)
                    }

                    if statusCode == 404 {

                        errorCallback(.tableDoesNotExist)
                    }
                }
        })
    }

    /**
     Gets values from a particular table
    
    - parameter token: The token in String format
    - parameter tableID: The table id as NSNumber
    - parameter parameters: The parameters to pass to the request, e.g. startime, endtime, limit
    - parameter successCallback: A callback called when successful of type @escaping ([JSON]) -> Void
    - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
    */
    public class func getHatTableValuesWithOutPretty(token: String, userDomain: String, tableID: NSNumber, parameters: Dictionary<String, String>, successCallback: @escaping ([JSON], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/data/table/" + tableID.stringValue + "/values"

        // create parameters and headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    errorCallback(.generalError(message, statusCode, error))
                case .isSuccess(let isSuccess, _, let result, let token):

                    if isSuccess {

                        if let array = result.array {
                            
                            successCallback(array, token)
                        } else {
                            
                            errorCallback(.noValuesFound)
                        }
                    }
                }
        })
    }

    /**
     Checks if a table exists
     
     - parameter tableName: The table we are looking as String
     - parameter sourceName: The source name as String
     - parameter authToken: The user's token as String
     - parameter successCallback: A callback called when successful of type @escaping (NSNumber) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public class func checkHatTableExists(userDomain: String, tableName: String, sourceName: String, authToken: String, successCallback: @escaping (NSNumber, String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // create the url
        let tableURL = "https://" + userDomain + "/data/table?name=" + tableName + "&source=" + sourceName

        // create headers
        let header = [RequestHeaders.xAuthToken: authToken]

        // make async request
        HATNetworkHelper.asynchronousRequest(
            tableURL,
            method: HTTPMethod.get,
            encoding: Alamofire.URLEncoding.default,
            contentType: ContentType.JSON,
            parameters: [:],
            headers: header,
            completion: {(response: HATNetworkHelper.ResultType) -> Void in

                let message = NSLocalizedString("Server responded with error", comment: "")

                switch response {

                case .error(let error, let statusCode):

                    if statusCode == 404 {

                        errorCallback(.tableDoesNotExist)
                    } else {

                        errorCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, let statusCode, let result, let token):

                    if isSuccess {

                        let tableID = result["fields"][0]["tableId"].number

                        //table found
                        if statusCode == 200 {

                            // get notes
                            if tableID != nil {

                                successCallback(tableID!, token)
                            } else {

                                errorCallback(.noTableIDFound)
                            }
                        //table not found
                        } else if statusCode == 404 {

                            errorCallback(.tableDoesNotExist)
                        } else {

                            errorCallback(.generalError(message, statusCode, nil))
                        }
                    }
                }
        })
    }

    // MARK: - Create table in hat

    /**
     Creates the notables table on the hat
     
     - parameter token: The token returned from the hat
     */
    public class func createHatTable(userDomain: String, token: String, notablesTableStructure: Dictionary<String, Any>, failed: @escaping (HATTableError) -> Void) -> (_ callback: Void) -> Void {

        return { (_ callback: Void) -> Void in

            // create headers and parameters
            let headers = ["Accept": ContentType.JSON,
                           "Content-Type": ContentType.JSON,
                           "X-Auth-Token": token]
            let url = "https://" + userDomain + "/data/table"

            // make async request
            HATNetworkHelper.asynchronousRequest(url, method: HTTPMethod.post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: notablesTableStructure, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                // handle result
                switch response {

                case .isSuccess(let isSuccess, let statusCode, _, _):

                    if isSuccess {

                        callback
                        // if user is creating notables table send a notif back that the table has been created
                        NotificationCenter.default.post(name: NSNotification.Name("refreshTable"), object: nil)
                    } else {

                        let message = NSLocalizedString("The request was not succesful", comment: "")
                        failed(.generalError(message, statusCode, nil))
                    }

                case .error(let error, let statusCode):

                    let message = NSLocalizedString("Server responded with error", comment: "")
                    failed(.generalError(message, statusCode, error))
                }
            })
        }
    }

    // MARK: - Delete from hat

    /**
     Deletes a record from hat
     
     - parameter token: The user's token
     - parameter recordId: The record id to delete
     - parameter success: A callback called when successful of type @escaping (String) -> Void
     */
    public class func deleteHatRecord(userDomain: String, token: String, recordId: Int, success: @escaping (String) -> Void, failed: @ escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/data/record/" + String(recordId)

        // create  headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .delete, encoding: Alamofire.URLEncoding.default, contentType: ContentType.Text, parameters: [:], headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            // handle result
            switch response {

            case .isSuccess(let isSuccess, let statusCode, _, _):

                if isSuccess {

                    success(token)
                    HATAccountService.triggerHatUpdate(userDomain: userDomain, completion: { () -> Void in return })
                } else {

                    let message = NSLocalizedString("The request was unsuccesful", comment: "")
                    failed(.generalError(message, statusCode, nil))
                }

            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failed(.generalError(message, statusCode, error))
            }
        })
    }
    /**
     Deletes a record from hat using V2 API
     
     - parameter token: The user's token
     - parameter recordId: The record id to delete
     - parameter success: A callback called when successful of type @escaping (String) -> Void
     */
    public class func deleteHatRecordV2(userDomain: String, token: String, recordId: [Int], success: @escaping (String) -> Void, failed: @ escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/api/v2/data/"

        // create parameters and headers
        let parameters: NSMutableDictionary = [:]

        for record in recordId {

            parameters.addEntries(from: ["records": record])
        }
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .delete, encoding: Alamofire.URLEncoding.default, contentType: ContentType.Text, parameters: parameters.dictionaryWithValues(forKeys: ["records"]), headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            // handle result
            switch response {

            case .isSuccess(let isSuccess, let statusCode, _, _):

                if isSuccess {

                    success(token)
                    HATAccountService.triggerHatUpdate(userDomain: userDomain, completion: { () -> Void in return })
                } else {

                    let message = NSLocalizedString("The request was unsuccesful", comment: "")
                    failed(.generalError(message, statusCode, nil))
                }

            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failed(.generalError(message, statusCode, error))
            }
        })
    }

    // MARK: - Edit record

    /**
     Edits a record from hat using v2 API's
     
     - parameter token: The user's token
     - parameter recordId: The record id to delete
     - parameter success: A callback called when successful of type @escaping (String) -> Void
     */
    public class func editHatRecordV2(userDomain: String, token: String, parameters: Dictionary<String, Any>, successCallback: @escaping ([JSON], String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // form the url
        let url = "https://" + userDomain + "/api/v2/data/"

        // create parameters and headers
        let headers = [RequestHeaders.xAuthToken: token]

        // make the request
        HATNetworkHelper.asynchronousRequest(url, method: .put, encoding: Alamofire.URLEncoding.default, contentType: ContentType.Text, parameters: parameters, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

            // handle result
            switch response {

            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                errorCallback(.generalError(message, statusCode, error))
            case .isSuccess(let isSuccess, _, let result, let token):

                if isSuccess {

                    if let array = result.array {
                        
                        successCallback(array, token)
                    } else {
                        
                        errorCallback(.noValuesFound)
                    }
                }
            }
        })
    }

    // MARK: - Trigger an update

    /**
     Triggers an update to hat servers
     */
    public class func triggerHatUpdate(userDomain: String, completion: @escaping () -> Void) {

        // define the url to connect to
        let url = "https://notables.hubofallthings.com/api/bulletin/tickle"

        // make the request
        Alamofire.request(url, method: .get, parameters: ["phata": userDomain], encoding: Alamofire.URLEncoding.default, headers: nil).responseString { _ in

            completion()
        }
    }

    /**
     Checks if a table exists
     
     - parameter tableName: The table we are looking as String
     - parameter sourceName: The source name as String
     - parameter authToken: The user's token as String
     - parameter successCallback: A callback called when successful of type @escaping (NSNumber) -> Void
     - parameter errorCallback: A callback called when failed of type @escaping (Void) -> Void)
     */
    public class func checkHatTableExistsForUploading(userDomain: String, tableName: String, sourceName: String, authToken: String, successCallback: @escaping (Dictionary<String, Any>, String?) -> Void, errorCallback: @escaping (HATTableError) -> Void) {

        // create the url
        let tableURL = "https://" + userDomain + "/data/table?name=" + tableName + "&source=" + sourceName

        // create headers
        let header = [RequestHeaders.xAuthToken: authToken]

        // make async request
        HATNetworkHelper.asynchronousRequest(
            tableURL,
            method: HTTPMethod.get,
            encoding: Alamofire.URLEncoding.default,
            contentType: ContentType.JSON,
            parameters: [:],
            headers: header,
            completion: {(response: HATNetworkHelper.ResultType) -> Void in

                switch response {

                case .error(let error, let statusCode):

                    if statusCode == 404 {

                        errorCallback(.tableDoesNotExist)
                    } else {

                        let message = NSLocalizedString("Server responded with error", comment: "")
                        errorCallback(.generalError(message, statusCode, error))
                    }
                case .isSuccess(let isSuccess, let statusCode, let result, let token):

                    if isSuccess {

                        //table found
                        if statusCode == 200 {

                            successCallback(result.dictionaryValue, token)
                        //table not found
                        } else if statusCode == 404 {

                            errorCallback(.tableDoesNotExist)
                        } else {

                            let message = NSLocalizedString("Status code does not match expecations", comment: "")
                            errorCallback(.generalError(message, statusCode, nil))
                        }
                    } else {

                        let message = NSLocalizedString("Respond is not succesful", comment: "")
                        errorCallback(.generalError(message, statusCode, nil))
                    }
                }
        })
    }

    /**
     Constructs URL to get the public key
     
     - parameter userHATDomain: The user's HAT domain
     
     - returns: HATRegistrationURLAlias
     */
    public class func theUserHATDomainPublicKeyURL(_ userHATDomain: String) -> String? {

        if let escapedUserHATDomain: String = userHATDomain.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {

            return "https://" + escapedUserHATDomain + "/" + "publickey"
        }

        return nil
    }

    // MARK: - Change Password

    /**
     Changes the user's password
     
     - parameter userDomain: The user's domain
     - parameter userToken: The user's authentication token
     - parameter oldPassword: The old password the user entered
     - parameter newPassword: The new password to change to
     - parameter successCallback: A function of type (String, String?) to call on success
     - parameter failCallback: A fuction of type (HATError) to call on fail
     */
    public class func changePassword(userDomain: String, userToken: String, oldPassword: String, newPassword: String, successCallback: @escaping (String, String?) -> Void, failCallback: @escaping (HATError) -> Void) {

        let url = "https://" + userDomain + "/control/v2/auth/password"

        let parameters: Dictionary = ["password": oldPassword, "newPassword": newPassword]
        let headers = [RequestHeaders.xAuthToken: userToken]

        HATNetworkHelper.asynchronousRequest(url, method: .post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: parameters, headers: headers, completion: {(response: HATNetworkHelper.ResultType) -> Void in

            switch response {

            case .error(let error, let statusCode):

                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallback(.generalError(message, statusCode, error))
            case .isSuccess(let isSuccess, _, let result, let token):

                if isSuccess, let message = result.dictionaryValue["message"]?.stringValue {

                    successCallback(message, token)
                }
            }
        })
    }
}
