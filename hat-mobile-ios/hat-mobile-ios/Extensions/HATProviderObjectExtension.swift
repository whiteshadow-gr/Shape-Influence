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

// MARK: Extension

extension HATProviderObject {

    // MARK: - Quick setup for get a hat info
    
    /**
     Sets up the string to display on the get a hat info view controller
     
     - parameter hatProvider: A hatProvider object to take the data from
     
     - returns: A NSAttributedString based on the hatProvider object
     */
    static func setupLabelForInfoViewController(hatProvider: HATProviderObject) -> NSAttributedString {
        
        if hatProvider.price > 0 && hatProvider.kind.kind != "External" {
            
            let partOne = "Sign Me Up".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 15)!)
            let partTwo = "".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 15)!)
            
            return partOne.combineWith(attributedText: partTwo)
        } else if hatProvider.kind.kind == "External" {
            
            let buttonName = ("Learn more about " + hatProvider.name).createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 15)!)
            let partTwo = "".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 15)!)
            
            return buttonName.combineWith(attributedText: partTwo)
        } else {
            
            let partOne = "Sign Me Up Free".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 15)!)
            let partTwo = "".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSansBold, size: 15)!)
            
            return partOne.combineWith(attributedText: partTwo)
        }
    }
}
