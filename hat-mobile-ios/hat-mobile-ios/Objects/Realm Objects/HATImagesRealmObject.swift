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
internal class HATImagesRealmObject: Object {
    
    // MARK: - Variables
    
    /// The image to save to Realm
    dynamic var imagePath: String = ""
    
    /// The image ID
    dynamic var imageID: String = ""
}
