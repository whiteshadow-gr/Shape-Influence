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

/// A class responsible for the profile nationality, in dataStore ViewController
internal class DataStoreNationalityTableViewController: UITableViewController, UserCredentialsProtocol {
    
    // MARK: - Variables

    /// The sections of the table view
    private let sections: [[String]] = [["Nationality"], ["Passport Held"], ["Passport Number"], ["Place of Birth"], ["Language"]]
    /// The headers of the table view
    private let headers: [String] = ["Nationality", "Passport Held", "Passport Number", "Place of Birth", "Language"]
    
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    /// The nationality object used to save all the values downloaded from the server and also used to produce the JSON to update to the server
    private var nationality: HATNationalityObject = HATNationalityObject()
    
    // MARK: - IBAction
    
    /**
     Saves the nationality to hat
     
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
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreNationalityCell, for: indexPath) as? PhataTableViewCell
                cell = self.setUpCell(cell: cell!, indexPath: indexPath, nationality: self.nationality) as? PhataTableViewCell
            }
            
            if index == 0 {
                
                self.nationality.nationality = cell!.getTextFromTextField()
            } else if index == 1 {
                
                self.nationality.passportHeld = cell!.getTextFromTextField()
            } else if index == 2 {
                
                self.nationality.passportNumber = cell!.getTextFromTextField()
            } else if index == 3 {
                
                self.nationality.placeOfBirth = cell!.getTextFromTextField()
            } else if index == 4 {
                
                self.nationality.language = cell!.getTextFromTextField()
            }
        }
        
        func gotApplicationToken(appToken: String, newUserToken: String?) {
            
            HATProfileService.postNationalityToHAT(
                userDomain: userDomain,
                userToken: appToken,
                nationality: self.nationality,
                successCallback: {_ in
                    
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    _ = self.navigationController?.popViewController(animated: true)
                },
                failCallback: {error in
                    
                    self.loadingView.removeFromSuperview()
                    self.darkView.removeFromSuperview()
                    
                    self.createClassicOKAlertWith(alertMessage: "There was an error posting profile", alertTitle: "Error", okTitle: "OK", proceedCompletion: {})
                    _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                }
            )
        }
        
        func gotErrorWhenGettingApplicationToken(error: JSONParsingError) {
            
            CrashLoggerHelper.JSONParsingErrorLog(error: error)
        }
        
        HATService.getApplicationTokenFor(
            serviceName: "Rumpel",
            userDomain: self.userDomain,
            token: self.userToken,
            resource: "https://rumpel.hubofallthings.com",
            succesfulCallBack: gotApplicationToken,
            failCallBack: gotErrorWhenGettingApplicationToken)
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false

        HATProfileService.getNationalityFromHAT(userDomain: userDomain, userToken: userToken, successCallback: updateTableWithValuesFrom, failCallback: errorFetching)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Completion handlers
    
    /**
     Updates the table with the new value returned from HAT
     
     - parameter nationalityObject: The nationality object returned from HAT
     */
    func updateTableWithValuesFrom(nationalityObject: HATNationalityObject) {
        
        self.nationality = nationalityObject
        self.tableView.reloadData()
    }
    
    /**
     Logs the error if it's not noValuesFund
     
     - parameter error: The error returned from HAT
     */
    func errorFetching(error: HATTableError) {
        
        switch error {
        case .noValuesFound:
            
            self.nationality = HATNationalityObject()
        default:
            
            _ = CrashLoggerHelper.hatTableErrorLog(error: error)
        }
    }
    
    // MARK: - Table view methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreNationalityCell, for: indexPath) as? PhataTableViewCell {
            
            return setUpCell(cell: cell, indexPath: indexPath, nationality: self.nationality)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreNationalityCell, for: indexPath)
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
     - parameter nationality: The nationality object used to set up the cell
     
     - returns: The set up cell
     */
    func setUpCell(cell: PhataTableViewCell, indexPath: IndexPath, nationality: HATNationalityObject) -> UITableViewCell {
        
        cell.accessoryType = .none
        
        if indexPath.section == 0 {
            
            cell.setTextToTextField(text: nationality.nationality)
        } else if indexPath.section == 1 {
            
            cell.setTextToTextField(text: nationality.passportHeld)
        } else if indexPath.section == 2 {
            
            cell.setTextToTextField(text: nationality.passportNumber)
        } else if indexPath.section == 3 {
            
            cell.setTextToTextField(text: nationality.placeOfBirth)
        } else if indexPath.section == 4 {
            
            cell.setTextToTextField(text: nationality.language)
        }

        return cell
    }

}
