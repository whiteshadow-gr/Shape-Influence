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

// MARK: Struct

/// A stuct to init a time interval in the future
internal struct FutureTimeInterval {
    
    // MARK: - Variable
    
    /// the interval in the future
    var interval: TimeInterval
    
    // MARK: - Initialiser
    
    /**
     Custom initializer of FutureTimeInterval
     
     - parameter days: The days to add
     - parameter timeType: The time type
     */
    init(days: TimeInterval, timeType: TimeType) {
        
        var timeBase: Double = 24
        // depending on the time type do the math
        switch timeType {
            
        case .future:
            
            timeBase = abs(timeBase)
        case .past:
            
            timeBase = -abs(timeBase)
        }
        // save time interval
        self.interval = (timeBase * 3600 * days)
    }
}

// MARK: - Enums

/**
 Used for time interval creation
 
 - future: Time interval in the future
 - past: Time interval in the past
 */
internal enum TimeType {
    
    /// Time interval in the future
    case future
    /// Time interval in the past
    case past
}

/**
 Used for time interval creation on map view depending on the user's selection
 
 - none: No time period selected
 - yesterday: Time period selected, yesterday
 - today: Time period selected, today
 - lastWeek: Time period selected, last week
 */
internal enum TimePeriodSelected {
    
    /// No time period selected
    case none
    /// Time period selected, yesterday
    case yesterday
    /// Time period selected, today
    case today
    /// Time period selected, last week
    case lastWeek
}
