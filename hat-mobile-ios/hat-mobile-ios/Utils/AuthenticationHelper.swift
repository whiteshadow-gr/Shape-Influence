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

import JWTDecode
import SwiftyRSA

// MARK: Class

/// The authenticationHelper is responsible for decoding the token
internal class AuthenticationHelper: NSObject {
    
    // MARK: - Struct
    
    /// The AuthenticationResponse is a custom respond object dedicated to return the data we need to validate the token
    struct AuthenticationResponse {
        
        // MARK: - Struct's variables
        
        /// The type of the error
        var errorType: String?
        /// The custom message error
        var message: String?
        /// The scope of the token
        var scope: String?
        /// The user's domain extracted from the token
        var domain: String?
        /// The token
        var token: String?
    }
    
    // MARK: - Decode token

    /**
     Decodes the token and validates if everything is ok
     
     - parameter token: The token to validate
     - parameter networkResponse: The response of the network request. If "" then it's a refresh token situation
     
     - returns: An AuthenticationResponse object
     */
    class func decodeToken(token: String, networkResponse: String) -> AuthenticationResponse {
        
        // decode the token and get the iss out
        do {
            
            let jwt = try decode(jwt: token)
            
            // get token scope
            let tokenScope = jwt.body["accessScope"] as? String
            
            // guard for the issuer check, “iss” (Issuer)
            guard let HATDomainFromToken = jwt.issuer else {
                
                return AuthenticationResponse(errorType: NSLocalizedString("error_label", comment: "error"), message: NSLocalizedString("auth_error_general", comment: "auth"), scope: nil, domain: nil, token: nil)
            }
            
            /*
             The token will consist of header.payload.signature
             To verify the token we use header.payload hashed with signature in base64 format
             The public PEM string is used to verify also
             */
            let tokenAttr: [String] = token.components(separatedBy: ".")
            
            // guard for the attr length. Should be 3 [header, payload, signature]
            guard tokenAttr.count == 3 else {
                
                return AuthenticationResponse(errorType: NSLocalizedString("error_label", comment: "error"), message: NSLocalizedString("auth_error_general", comment: "auth"), scope: nil, domain: nil, token: nil)
            }
            
            // And then to access the individual parts of token
            let header: String = tokenAttr[0]
            let payload: String = tokenAttr[1]
            let signature: String = tokenAttr[2]
            
            // decode signature from baseUrl64 to base64
            let decodedSig = signature.fromBase64URLToBase64(stringToConvert: signature)
            
            // data to be verified header.payload
            let headerAndPayload = header + "." + payload
            
            do {
                
                let signature = try Signature(base64Encoded: decodedSig)
                let privateKey = try PublicKey(pemEncoded: networkResponse)
                let clear = try ClearMessage(string: headerAndPayload, using: .utf8)
                let isSuccessful = try clear.verify(with: privateKey, signature: signature, digestType: .sha256)
                
                if isSuccessful && tokenScope != nil {
                    
                    return AuthenticationResponse(errorType: nil, message: "success", scope: tokenScope!, domain: HATDomainFromToken, token: jwt.string)
                }
                // if networkResponse == "" it's a refresh token situation
            } catch {
                
                return AuthenticationResponse(errorType: nil, message: "refreshToken", scope: tokenScope!, domain: HATDomainFromToken, token: jwt.string)
            }
            
            return AuthenticationResponse(errorType: nil, message: nil, scope: nil, domain: nil, token: nil)
        } catch {
            
            return AuthenticationResponse(errorType: nil, message: "Could not decode token", scope: nil, domain: nil, token: nil)
        }
    }
}
