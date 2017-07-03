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

// MARK: Class

/// A class responsible for the profile name, in dataStore ViewController
internal class DataSourceNameTableViewController: UITableViewController, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// The sections of the table view
    private let sections: [[String]] = [["First Name"], ["Middle Name"], ["Last Name"], ["Preffered Name"], ["Title"]]
    /// The headers of the table view
    private let headers: [String] = ["First Name", "Middle Name", "Last Name", "Preffered Name", "Title"]
    
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    /// The profile, used in PHATA table
    var profile: HATProfileObject?
    
    // MARK: - IBAction
    
    /**
     Saves the profile to hat
     
     - parameter sender: The object that called this function
     */
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.darkView = UIView(frame: self.tableView.frame)
        self.darkView.backgroundColor = .black
        self.darkView.alpha = 0.4
        
        self.view.addSubview(self.darkView)
        
        self.loadingView = UIView.createLoadingView(with: CGRect(x: (self.view?.frame.midX)! - 70, y: (self.view?.frame.midY)! - 15, width: 140, height: 30), color: .teal, cornerRadius: 15, in: self.view, with: "Updating profile...", textColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 12)!)
        
        for index in self.headers.indices {
            
            var cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? PhataTableViewCell
            
            if cell == nil {
                
                let indexPath = IndexPath(row: 0, section: index)
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.nameCell, for: indexPath) as? PhataTableViewCell
                cell = self.setUpCell(cell: cell!, indexPath: indexPath) as? PhataTableViewCell
            }
            
            // first name
            if index == 0 {
                
                profile?.data.personal.firstName = cell!.getTextFromTextField()
            // Middle name
            } else if index == 1 {
                
                profile?.data.personal.middleName = cell!.getTextFromTextField()
            // Last name
            } else if index == 2 {
                
                profile?.data.personal.lastName = cell!.getTextFromTextField()
            // Preffered name
            } else if index == 3 {
                
                profile?.data.personal.prefferedName = cell!.getTextFromTextField()
            // Title
            } else if index == 4 {
                
                profile?.data.personal.title = cell!.getTextFromTextField()
            }
        }
        
        func tableExists(dict: Dictionary<String, Any>, renewedUserToken: String?) {
            
            HATPhataService.postProfile(
                userDomain: userDomain,
                userToken: userToken,
                hatProfile: self.profile!,
                successCallBack: {
                
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    _ = self.navigationController?.popViewController(animated: true)
                },
                errorCallback: { error in
                
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                }
            )
        }
        
        HATAccountService.checkHatTableExistsForUploading(
            userDomain: userDomain,
            tableName: Constants.HATTableName.Profile.name,
            sourceName: Constants.HATTableName.Profile.source,
            authToken: userToken,
            successCallback: tableExists,
            errorCallback: {_ in
            
                self.loadingView.removeFromSuperview()
                self.darkView.removeFromSuperview()
            }
        )
    }
    
    // MARK: - View Controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreNameCell, for: indexPath) as? PhataTableViewCell {
            
            return setUpCell(cell: cell, indexPath: indexPath)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreNameCell, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section < self.headers.count {
            
            return self.headers[section]
        }
        
        return nil
    }
    
    // MARK: - Update cell
    
    /**
     Sets up the cell accordingly
     
     - parameter cell: The cell to set up
     - parameter indexPath: The index path of the cell
     
     - returns: The set up cell
     */
    func setUpCell(cell: PhataTableViewCell, indexPath: IndexPath) -> UITableViewCell {
                
        cell.accessoryType = .none
        
        if indexPath.section == 0 && self.profile != nil {
            
            cell.setTextToTextField(text: self.profile!.data.personal.firstName)
        } else if indexPath.section == 1 && self.profile != nil {
            
            cell.setTextToTextField(text: self.profile!.data.personal.middleName)
        } else if indexPath.section == 2 && self.profile != nil {
            
            cell.setTextToTextField(text: self.profile!.data.personal.lastName)
        } else if indexPath.section == 3 && self.profile != nil {
            
            cell.setTextToTextField(text: self.profile!.data.personal.prefferedName)
        } else if indexPath.section == 4 && self.profile != nil {
            
            cell.setTagInTextField(tag: 15)
            cell.dataSourceForPickerView = ["", "Mr.", "Mrs.", "Miss", "Dr."]
            cell.setTextToTextField(text: self.profile!.data.personal.title)
        }
        
        return cell
    }

}
