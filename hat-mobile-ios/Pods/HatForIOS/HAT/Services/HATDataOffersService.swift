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
import UIKit

// MARK: Class

public class HATDataOffersService: NSObject {

    // MARK: - Get available data offers
    
    /**
     Gets the available data plugs for the user to enable
     
     - parameter succesfulCallBack: A function of type ([HATDataPlugObject]) -> Void, executed on a successful result
     - parameter failCallBack: A function of type (Void) -> Void, executed on an unsuccessful result
     */
    public class func getAvailableDataOffers(applicationToken: String, succesfulCallBack: @escaping ([DataOfferObject], String?) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        let url: String = "http://databuyer.hubat.net/api/v1/offersWithClaims"
        let headers: Dictionary<String, String> = ["X-Auth-Token": applicationToken]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: [:], headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode):
                
                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallBack(.generalError(message, statusCode, error))
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {
                    
                    var returnValue: [DataOfferObject] = []
                    
                    for item in result.arrayValue {
                        
                        returnValue.append(DataOfferObject(dictionary: item.dictionaryValue))
                    }
                    
                    succesfulCallBack(returnValue, token)
                } else {
                    
                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
    
    // MARK: - Claim offer
    
    /**
     Gets the available data plugs for the user to enable
     
     - parameter succesfulCallBack: A function of type ([HATDataPlugObject]) -> Void, executed on a successful result
     - parameter failCallBack: A function of type (Void) -> Void, executed on an unsuccessful result
     */
    public class func claimOffer(applicationToken: String, offerID: String, succesfulCallBack: @escaping (String, String?) -> Void, failCallBack: @escaping (DataPlugError) -> Void) {
        
        let url: String = "http://databuyer.hubat.net/api/v1/offer/" + offerID + "/claim"
        let headers: Dictionary<String, String> = ["X-Auth-Token": applicationToken]
        
        HATNetworkHelper.asynchronousRequest(url, method: .get, encoding: Alamofire.URLEncoding.default, contentType: ContentType.JSON, parameters: [:], headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in
            
            switch response {
                
            // in case of error call the failCallBack
            case .error(let error, let statusCode):
                
                let message = NSLocalizedString("Server responded with error", comment: "")
                failCallBack(.generalError(message, statusCode, error))
            // in case of success call the succesfulCallBack
            case .isSuccess(let isSuccess, let statusCode, let result, let token):
                
                if isSuccess {

                    let dictionaryResponse = result.dictionaryValue
                    
                    if let claimed = dictionaryResponse["status"]?.stringValue {
                        
                        succesfulCallBack(claimed, token)
                    } else {
                        
                        let message = NSLocalizedString("Server response was unexpected", comment: "")
                        failCallBack(.generalError(message, statusCode, nil))
                    }
                } else {
                    
                    let message = NSLocalizedString("Server response was unexpected", comment: "")
                    failCallBack(.generalError(message, statusCode, nil))
                }
            }
        })
    }
}
