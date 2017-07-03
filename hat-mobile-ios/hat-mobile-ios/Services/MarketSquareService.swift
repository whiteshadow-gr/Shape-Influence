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

import HatForIOS

// MARK: Struct

/// A class about the methods concerning marketsquare
internal struct MarketSquareService: UserCredentialsProtocol {
    
    // MARK: - Methods
    
    /**
     Get the Market Access Token for the iOS data plug
     
     - returns: MarketAccessToken
     */
    static func theMarketAccessToken() -> Constants.MarketAccessTokenAlias {
        
        return Constants.HATDataPlugCredentials.marketsquareAccessToken
    }
    
    /**
     Get the Market Access Token for the iOS data plug
     
     - returns: MarketDataPlugID
     */
    static func theMarketDataPlugID() -> Constants.MarketDataPlugIDAlias {
        
        return Constants.HATDataPlugCredentials.marketsquareDataPlugID
    }
    
    // MARK: - Get app token
    
    /**
     Gets application token for facebook
     
     - parameter successful: An @escaping (String) -> Void method executed on a successful response
     - parameter failed: An @escaping (Void) -> Void) method executed on a failed response
     */
    static func getAppTokenForMarketsquare(successful: @escaping (String, String?) -> Void, failed: @escaping () -> Void) {
        
        HATService.getApplicationTokenFor(
            serviceName: Constants.ApplicationToken.Marketsquare.name,
            userDomain: userDomain,
            token: userToken,
            resource: Constants.ApplicationToken.Marketsquare.source,
            succesfulCallBack: successful,
            failCallBack: {(error) in
            
                failed()
                CrashLoggerHelper.JSONParsingErrorLogWithoutAlert(error: error)
            }
        )
    }
    
}
