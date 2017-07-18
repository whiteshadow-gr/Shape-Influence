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

// MARK: Class

/// The data points table view cell class
internal class DataPointTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    /// An IBOutlet for handling the latitude label of the cell
    @IBOutlet private weak var labelLatitude: UILabel!
    /// An IBOutlet for handling the date label of the cell
    @IBOutlet private weak var labelDateAdded: UILabel!
    /// An IBOutlet for handling the sync label of the cell
    @IBOutlet private weak var labelSyncDate: UILabel!
    
    // MARK: - Set up cell
    
    /**
     Sets up the cell according to the DataPoint object passed in as parameter
     
     - parameter dataPoint: The object to use in order to get the data needed to show to the cell
     - parameter lastSynced: The last sync date, optional
     
     - returns: Returns an already set up cell
     */
    func setUpCell(dataPoint: DataPoint, lastSynced: Date?) -> UITableViewCell {
        
        self.labelLatitude.text = String(dataPoint.lat) + ", " + String(dataPoint.lng) + ", " + String(dataPoint.accuracy)
        self.labelDateAdded.text = "Added " + FormatterHelper.getDateString(dataPoint.dateAdded)
        
        // last sync date
        if lastSynced != nil {
            
            self.labelSyncDate.text = "Synced " + FormatterHelper.getDateString(lastSynced!)
            self.labelSyncDate.textColor = .shapeInfluencePink
        } else {
            
            self.labelSyncDate.text = NSLocalizedString("not_synced_label", comment:  "")
            self.labelSyncDate.textColor = .red
        }
        
        return self
    }
}
