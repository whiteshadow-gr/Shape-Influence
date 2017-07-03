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

/// A class responsible for the profile info UITableViewController of the PHATA section
internal class ProfileInfoTableViewController: UITableViewController, UserCredentialsProtocol {
    
    // MARK: - Variables

    /// The sections of the table view
    private let sections: [[String]] = [["Age"], ["Gender"], ["Birth"], ["Nickname"]]
    /// The headers of the table view
    private let headers: [String] = ["Age", "Gender", "Birth", "Nickname"]
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    /// User's profile passed on from previous view controller
    var profile: HATProfileObject?
    
    // MARK: - IBAction
    
    /**
     Sends the profile data to hat
     
     - parameter sender: The object that calls this function
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
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.profileInfoCell, for: indexPath) as? PhataTableViewCell
                cell = self.setUpCell(cell: cell!, indexPath: indexPath) as? PhataTableViewCell
            }
            
            // age
            if index == 0 {
                
                profile?.data.age.group = cell!.getTextFromTextField()
                profile?.data.age.isPrivate = !cell!.getSwitchValue()
                if (profile?.data.isPrivate)! && cell!.getSwitchValue() {
                    
                    profile?.data.isPrivate = false
                }
            // gender
            } else if index == 1 {
                
                profile?.data.gender.type = cell!.getTextFromTextField()
                profile?.data.gender.isPrivate = !cell!.getSwitchValue()
                if (profile?.data.isPrivate)! && cell!.getSwitchValue() {
                    
                    profile?.data.isPrivate = false
                }
            // birth
            } else if index == 2 {
                
                profile?.data.birth.date = cell!.getTextFromTextField()
                profile?.data.birth.isPrivate = !cell!.getSwitchValue()
                if (profile?.data.isPrivate)! && cell!.getSwitchValue() {
                    
                    profile?.data.isPrivate = false
                }
            // nickname
            } else if index == 3 {
                
                profile?.data.nick.name = cell!.getTextFromTextField()
                profile?.data.nick.isPrivate = !cell!.getSwitchValue()
                if (profile?.data.isPrivate)! && cell!.getSwitchValue() {
                    
                    profile?.data.isPrivate = false
                }
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
                errorCallback: {error in
                    
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    self.createClassicOKAlertWith(alertMessage: "There was an error posting profile", alertTitle: "Error", okTitle: "OK", proceedCompletion: {})
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
            errorCallback: {error in
            
                self.loadingView.removeFromSuperview()
                self.darkView.removeFromSuperview()
                
                self.createClassicOKAlertWith(alertMessage: "There was an error checking if it's possible to post the data", alertTitle: "Error", okTitle: "OK", proceedCompletion: {})
                
                _ = CrashLoggerHelper.hatTableErrorLog(error: error)
            }
        )
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.profile == nil {
            
            self.profile = HATProfileObject()
        }
        
        self.tableView.addBackgroundTapRecogniser()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.profileInfoCell, for: indexPath) as? PhataTableViewCell {
            
            return self.setUpCell(cell: cell, indexPath: indexPath)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.profileInfoCell, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.headers[section]
    }
    
    // MARK: - Set up cell
    
    /**
     Updates and formats the cell accordingly
     
     - parameter cell: The PhataTableViewCell to update and format
     - parameter indexPath: The indexPath of the cell
     
     - returns: A UITableViewCell cell already updated and formatted accordingly
     */
    private func setUpCell(cell: PhataTableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        if self.profile != nil {
            
            if indexPath.section == 0 {
                
                var array: [String] = []
                for i in 13...100 {
                    
                    array.append(String(describing: i))
                }
                cell.dataSourceForPickerView = array
                cell.setTextToTextField(text: self.profile!.data.age.group)
                cell.setSwitchValue(isOn: !self.profile!.data.age.isPrivate)
                cell.setKeyboardType(.numberPad)
                cell.tag = 10
            } else if indexPath.section == 1 {
                
                let array: [String] = ["", "Male", "Female", "Other"]
                cell.dataSourceForPickerView = array
                cell.setTextToTextField(text: self.profile!.data.gender.type)
                cell.setSwitchValue(isOn: !self.profile!.data.gender.isPrivate)
                cell.setKeyboardType(.default)
                cell.tag = 11
            } else if indexPath.section == 2 {
                
                if self.profile?.data.birth.date != nil {
                    
                    cell.setTextToTextField(text: self.profile!.data.birth.date)
                }
                cell.setSwitchValue(isOn: !self.profile!.data.birth.isPrivate)
                cell.setKeyboardType(.default)
                cell.tag = 12
            } else if indexPath.section == 3 {
                
                cell.setTextToTextField(text: self.profile!.data.nick.name)
                cell.setSwitchValue(isOn: !self.profile!.data.nick.isPrivate)
                cell.setKeyboardType(.default)
            }
        }
        
        return cell
    }

}
