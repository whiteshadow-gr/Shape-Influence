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

/// Extends UITAbleView. Manage the rendering of DataPoints
internal class DataPointsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    /// the data points from Realm
    private var dataResults: Results<DataPoint>!
    /// the cell identifier
    private let basicCellIdentifier: String = "DataPointTableViewCell"
    
    // MARK: - View Controller delegate methods

    /**
     Initialisation code when first constructed.
     */
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let predicate = NSPredicate(format: "dateAdded >= %@", startOfToday as CVarArg)
        dataResults = RealmHelper.getResults(predicate)?.sorted(byKeyPath: "dateAdded", ascending: false)
        reloadData()
    }
    
    // MARK: - UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: basicCellIdentifier) as? DataPointTableViewCell {
            
            return cell.setUpCell(dataPoint: dataResults[indexPath.row], lastSynced: dataResults[indexPath.row].lastSynced)
        }
        
        return DataPointTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: basicCellIdentifier)
    }
}
