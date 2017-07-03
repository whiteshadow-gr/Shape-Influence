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

import UIKit

// MARK: Protocol

/// This protocol is used to compare the facebook and twitter objects for social feed
public protocol HATSocialFeedObject {

    // MARK: - Variable

    /// The last date updated of the record
    var protocolLastUpdate: Date? { get set }
}
