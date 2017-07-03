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

// MARK: Extension

extension UITableView {
    
    // MARK: - Add background tap recogniser

    /**
     Adds background tap recogniser on UITableView
     */
    func addBackgroundTapRecogniser() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Hide keyboard
    
    /**
     Hides keyboard
     */
    @objc
    private func hideKeyboard() {
        
        self.endEditing(true)
    }
}
