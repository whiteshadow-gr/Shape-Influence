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

// MARK: Protocol

/// send location data back to listening view controllers
internal protocol SendLocationDataDelegate: class {
    
    // MARK: - Protocol's functions

    /**
     Executed when the app has updated the user's location according to the regions
     
     - parameter latitude: The latitude of the location point
     - parameter longitude: The longitude of the location point
     - parameter accuracy: The accuracy of the location point
     */
    func locationDataReceived(latitude: Double, longitude: Double, accuracy: Double)
}
