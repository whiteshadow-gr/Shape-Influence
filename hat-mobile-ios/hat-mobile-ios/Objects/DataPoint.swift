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

import RealmSwift

// MARK: Class

/// The DataPoint object representation
internal class DataPoint: Object {
    
    // MARK: - Variables
    
    /// The latitude of the point
    dynamic var lat: Double = 0
    /// The longitude of the point
    dynamic var lng: Double = 0
    /// The accuracy of the point
    dynamic var accuracy: Double = 0
    
    /// The adhttps://www.facebook.com/rsrc.php/v3/y4/r/-PAXP-deijE.gifded point date of the point
    dynamic var dateAdded: Date = Date()
    /// The last sync date of the point
    dynamic var lastSynced: Date? = nil // optional..can be nil
}
