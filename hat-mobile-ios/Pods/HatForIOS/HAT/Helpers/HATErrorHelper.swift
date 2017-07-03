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
 The possible authentication errors produced when loging in
 
 - noTokenDetectedError: No token detected
 - noIssuerDetectedError: No issuer of the token detected. Includes a description(String)
 - generalError: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - cannotDecodeToken: Cannot decode token. Includes a description(String)
 - cannotSplitToken: Cannot split token. Includes a description(String)
 - tokenValidationFailed: Token cannot be validated. Includes a description(String)
 */
public enum AuthenicationError: Error {

    case noTokenDetectedError
    case noIssuerDetectedError(String)
    case generalError(String, Int?, Error?)
    case cannotDecodeToken(String)
    case cannotSplitToken([String])
    case tokenValidationFailed(String)
}

/**
 The possible JSON parsing errors produced when handling JSON files
 
 - expectedFieldNotFound: Field requested not found. Includes a description(String)
 - generalError: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 */
public enum JSONParsingError: Error {

    case expectedFieldNotFound
    case generalError(String, Int?, Error?)
}

/**
 The possible HAT table errors produced when accessing tables
 
 - noValuesFound: The table didn't return any values
 - tableDoesNotExist: Table does not exist
 - noTableIDFound: Couldn't find the table ID
 - generalError: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 */
public enum HATTableError: Error {

    case noValuesFound
    case tableDoesNotExist
    case noTableIDFound
    case generalError(String, Int?, Error?)
}

/**
 The possible HAT errors produced when accessing tables
 
 - noValuesFound: The table didn't return any values
 - tableDoesNotExist: Table does not exist
 - noTableIDFound: Couldn't find the table ID
 - generalError: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 */
public enum HATError: Error {

    case generalError(String, Int?, Error?)
}

/**
 The possible data plug errors produced when communicating with data plugs
 
 - generalError: General error. Includes a description(String), the statusCode(Int?) and the error(Error?)
 - noValueFound: No value found in the response
 */
public enum DataPlugError: Error {

    case generalError(String, Int?, Error?)
    case offerClaimed
    case noValueFound
}
