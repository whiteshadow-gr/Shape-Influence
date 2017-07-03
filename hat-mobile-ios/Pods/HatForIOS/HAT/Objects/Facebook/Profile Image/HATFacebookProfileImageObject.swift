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

import SwiftyJSON

// MARK: Struct

public struct HATFacebookProfileImageObject {

    // MARK: - Variables

    var isSilhouette: Bool = false
    var url: String = ""
    var imageHeight: Int = 0
    var imageWidth: Int = 0
    var lastUpdated: Int?
    var recordID: String?
    var endPoint: String = "profile_picture"

    // MARK: - Initialisers

    /**
     The default initialiser. Initialises everything to default values.
     */
    public init() {

        isSilhouette = false
        url = ""
        imageWidth = 0
        imageHeight = 0
        lastUpdated = nil
        recordID = nil
        endPoint = "profile_picture"
    }

    /**
     It initialises everything from the received JSON file from the HAT
     */
    public init(from dictionary: Dictionary<String, JSON>) {

        self.init()

        if let tempRecordID = dictionary["recordId"]?.stringValue {

            recordID = tempRecordID
        }

        if let tempEndPoint = dictionary["endpoint"]?.stringValue {

            endPoint = tempEndPoint
        }

        if let data = dictionary["data"]?.dictionaryValue {

            // In new v2 API last updated will be inside data
            if let tempLastUpdated = data["lastUpdated"]?.stringValue {

                if let date = HATFormatterHelper.formatStringToDate(string: tempLastUpdated) {

                    lastUpdated = Int(HATFormatterHelper.formatDateToEpoch(date: date)!)
                }
            }
            if let tempSilhouette = dictionary["is_silhouette"]?.boolValue {

                isSilhouette = tempSilhouette
            }
            if let tempHeight = dictionary["height"]?.string {

                imageHeight = Int(tempHeight)!
            }
            if let tempWidth = dictionary["width"]?.stringValue {

                imageWidth = Int(tempWidth)!
            }
            if let tempLink = dictionary["url"]?.stringValue {

                url = tempLink
            }
        }
    }
}
