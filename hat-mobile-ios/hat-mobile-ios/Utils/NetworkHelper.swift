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
import HatForIOS
import SwiftyJSON

// MARK: Class

/// All network related methods
internal class NetworkHelper {
    
    // MARK: - Friendly exception message
    
    /**
     Gets the friendly message for an exception
     
     - parameter errorCode: The error code occured
     - parameter defaultMessage: The default message to show if the errorCode does not match
     
     - returns: A message as a String
     */
    class func exceptionFriendlyMessage(_ errorCode: Int?, defaultMessage: String) -> String {
        
        if let errorCodeCheck: Int = errorCode {
            
            switch errorCodeCheck {
                
            case 401:
                
                return NSLocalizedString("exception_401", comment: "")
            case 400:
                
                return NSLocalizedString("exception_400", comment: "")
            case 500:
                
                return NSLocalizedString("exception_500", comment: "")
            case 504:
                
                return NSLocalizedString("exception_504", comment: "")
            default:
                
                return defaultMessage
            }
        } else {
            
            return defaultMessage
        }
    }
    
    // MARK: - Construct request headers
    
    /**
     Construct the headers for the Requests
     
     - parameter xAuthToken: The xAuthToken String
     
     - returns: [String: String]
     */
    class func constructRequestHeaders(_ xAuthToken: String) -> [String: String] {
        
        return [Constants.Headers.accept: Constants.ContentType.json,
                Constants.Headers.contentType: Constants.ContentType.json,
                Constants.Headers.authToken: xAuthToken]
    }
    
    // MARK: - Async Request
    
    /**
     Makes ansychronous data request
     used to POST data TO HAT
     Closure for caller to handle
     
     - parameter url: The URL to connect to
     - parameter method: The method to use in connecting with the URL
     - parameter encoding: The encoding to use in the request
     - parameter contentType: The content type of the request
     - parameter parameters: The parameters in the request
     - parameter headers: The headers in the request
     - parameter userHATAccessToken: The HAT access token
     - parameter completion: The completion handler to execute upon completing the request
     */
    class func asynchronousRequestData(
        
        _ url: String,
        method: HTTPMethod,
        encoding: ParameterEncoding,
        contentType: String,
        parameters: [AnyObject],
        headers: Dictionary<String, String>,
        userHATAccessToken: String,
        completion: @escaping (_ r: HATNetworkHelper.ResultType) -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        Alamofire.request(urlRequest).responseJSON { response in
            
            switch response.result {
            case .success:
                
                let headers = response.response?.allHeaderFields
                let tokenHeader = headers?[Constants.Headers.authToken] as? String
                if tokenHeader != nil {
                    
                    let result = AuthenticationHelper.decodeToken(token: tokenHeader!, networkResponse: "")
                    if result.message == "refreshToken" && result.scope == "owner" {
                        
                        _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: tokenHeader!)
                    }
                }
                
                // check if we have a value and return it
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: true, statusCode: response.response!.statusCode, result: json, token: tokenHeader))
                // else return isSuccess: false and nil for value
                } else {
                    
                    completion(HATNetworkHelper.ResultType.isSuccess(isSuccess: false, statusCode: response.response?.statusCode, result: "", token: tokenHeader))
                }
            // return the error
            case .failure(let error):
                
                completion(HATNetworkHelper.ResultType.error(error: error, statusCode: response.response?.statusCode))
            }
          
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Stop Background Newtwork Tasks
    
    /**
     Stops all background networks tasks
     */
    class func stopBackgroundNetworkTasks() {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    /**
     Pauses all background networks tasks
     */
    class func pauseBackgroundNetworkTasks(completion: @escaping () -> Void) {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.suspend() }
            uploadData.forEach { $0.suspend() }
            downloadData.forEach { $0.suspend() }
            
            completion()
        }
    }
    
    /**
     Resumes all background networks tasks
     */
    class func resumeBackgroundNetworkTasks() {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.resume() }
            uploadData.forEach { $0.resume() }
            downloadData.forEach { $0.resume() }
        }
    }
}
