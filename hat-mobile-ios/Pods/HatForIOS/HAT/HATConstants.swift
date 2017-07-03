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

import Foundation

/**
 The strings needed for communicating with twitter data plug
 
 - statusURL: No token detected
 - dataPlugURL: No issuer of the token detected. Includes a description(String)
 - tableName: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - sourceName: Cannot decode token. Includes a description(String)
 - serviceName: Cannot split token. Includes a description(String)
 */
public enum Twitter {

    static let statusURL: String = "https://twitter-plug.hubofallthings.com/api/status"
    static let dataPlugURL: String = "https://twitter-plug.hubofallthings.com"
    static let tableName: String = "tweets"
    static let sourceName: String = "twitter"
    static let serviceName: String = "Twitter"
}

/**
 The strings needed for communicating with facebook data plug
 
 - statusURL: No token detected
 - dataPlugURL: No issuer of the token detected. Includes a description(String)
 - tableName: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - sourceName: Cannot decode token. Includes a description(String)
 - serviceName: Cannot split token. Includes a description(String)
 */
public enum Facebook {

    static let statusURL: String = "https://social-plug.hubofallthings.com/api/user/token/status"
    static let dataPlugURL: String = "https://social-plug.hubofallthings.com"
    static let tableName: String = "posts"
    static let sourceName: String = "facebook"
    static let serviceName: String = "Facebook"
}

/**
 The strings needed for communicating with notables service
 
 - tableName: No token detected
 - sourceName: No issuer of the token detected. Includes a description(String)
 */
public enum Notables {

    static let tableName: String = "notablesv1"
    static let sourceName: String = "rumpel"
}

/**
The request headers
 
 - xAuthToken: No token detected
 */
public enum RequestHeaders {

    static let xAuthToken: String = "X-Auth-Token"
}

/**
 The content type
 
 - JSON: No token detected
 - Text: No issuer of the token detected. Includes a description(String)
 */
public enum ContentType {

    static let JSON: String = "application/json"
    static let Text: String = "text/plain"
}

/**
 The authentication used for sending locations to HAT
 
 - URLScheme: No token detected
 - ServiceName: No issuer of the token detected. Includes a description(String)
 - LocalAuthHost: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - NotificationHandlerName: Cannot decode token. Includes a description(String)
 - TokenParamName: Cannot split token. Includes a description(String)
 */
public enum Auth {

    /// The name of the declared in the bundle identifier
    static let URLScheme: String = "rumpellocationtrackerapp"
    /// The name of the service, RumpelLite
    static let ServiceName: String = "RumpelLite"
    /// The name of the local authentication host, can be anything
    static let LocalAuthHost: String = "rumpellocationtrackerapphost"
    /// The notification handler name, can be anything
    static let NotificationHandlerName: String = "rumpellocationtrackerappnotificationhandler"
    /// The token name, QS parameter
    static let TokenParamName: String = "token"
}

/**
 The authentication data used by location service
 
 - HAT_Username: No token detected
 - HAT_Password: No issuer of the token detected. Includes a description(String)
 - Market_DataPlugID: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - Market_AccessToken: Cannot decode token. Includes a description(String)
 */
public enum HATDataPlugCredentials {

    /// hat username used for location data plug
    static let locationDataPlugUsername: String = "location"
    /// hat password used for location data plug
    static let locationDataPlugPassword: String = "MYl06ati0n"
    /// market data plug id used for location data plug
    static let dataPlugID: String = "c532e122-db4a-44b8-9eaf-18989f214262"
    /// market access token used for location data plug
    static let locationDataPlugToken: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxLVZTUDcrb0RleldPejBTOFd6MHhWM0J2eVNOYzViNnRcLzRKXC85TVlIWTQrVDdsSHdUSDRXMVVEWGFSVnVQeTFPZmtNajNSNDBjeTVERFRhQjZBNE44c3FGSTJmMUE1NzZUYjhiYmhhUT0iLCJpc3MiOiJoYXQtbWFya2V0IiwiZXhwIjoxNTI2OTc4OTkyLCJpYXQiOjE0OTYyMjA1OTIsImp0aSI6ImY0NTQ4NzI5MGRlZTA3NDI5YmQxMGViMWZmNzJkZjZmODdiYzhhZDE0ZThjOGE3NmMyZGJlMjVhNDlmODNkOTNiMDJhMzg3NGI4NTI0NDhlODU0Y2ZmZmE0ZWQyZGY1MTYyZTBiYzRhNDk2NGRhYTlhOTc1M2EyMjA1ZjIzMzc5NWY3N2JiODhlYzQwNjQxZjM4MTk4NTgwYWY0YmExZmJkMDg5ZTlhNmU3NjJjN2NhODlkMDdhOTg3MmY1OTczNjdjYWQyYzA0NTdjZDhlODlmM2FlMWQ2MmRmODY3NTcwNTc3NTdiZDJjYzgzNTgyOTU4ZmZlMDVhNjI2NzBmNGMifQ.TvFs6Zp0E24ChFqn3rBP-cpqxZbvkhph91UILGJvM6U"
}
