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

/// A class responsible for the profile relationship and household, in dataStore ViewController
internal class DataStoreRelationshipAndHouseholdTableViewController: UITableViewController, UserCredentialsProtocol {
    
    // MARK: - Variables

    /// The sections of the table view
    private let sections: [[String]] = [["Relationship Status"], ["Type of Accomodation"], ["Living Situation"], ["How many usually live in your household?"], ["Household ownership"], ["Do you have children?"], ["How many children do you have?"], ["Do you have any additional dependents?"]]
    /// The headers of the table view
    private let headers: [String] = ["Relationship Status", "Type of Accomodation", "Living Situation", "How many usually live in your household?", "Household ownership", "Do you have children?", "How many children do you have?", "Do you have any additional dependents?"]
    
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    /// The relationship and household object used to save all the values downloaded from the server and also used to produce the JSON to update to the server
    private var relationshipAndHousehold: HATProfileRelationshipAndHouseholdObject = HATProfileRelationshipAndHouseholdObject()
    
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
                cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreRelationshipCell, for: indexPath) as? PhataTableViewCell
                cell = self.setUpCell(cell: cell!, indexPath: indexPath, relationshipAndHousehold: self.relationshipAndHousehold) as? PhataTableViewCell
            }
            
            if index == 0 {
                
                self.relationshipAndHousehold.relationshipStatus = cell!.getTextFromTextField()
            } else if index == 1 {
                
                self.relationshipAndHousehold.typeOfAccomodation = cell!.getTextFromTextField()
            } else if index == 2 {
                
                self.relationshipAndHousehold.livingSituation = cell!.getTextFromTextField()
            } else if index == 3 {
                
                self.relationshipAndHousehold.howManyUsuallyLiveInYourHousehold = cell!.getTextFromTextField()
            } else if index == 4 {
                
                self.relationshipAndHousehold.householdOwnership = cell!.getTextFromTextField()
            } else if index == 5 {
                
                self.relationshipAndHousehold.hasChildren = cell!.getTextFromTextField()
            } else if index == 6 {
                
                self.relationshipAndHousehold.numberOfChildren = Int(cell!.getTextFromTextField())!
            } else if index == 7 {
                
                self.relationshipAndHousehold.additionalDependents = cell!.getTextFromTextField()
            }
        }
        
        func gotApplicationToken(appToken: String, newUserToken: String?) {
            
            HATProfileService.postRelationshipAndHouseholdToHAT(
                userDomain: userDomain,
                userToken: appToken,
                relationshipAndHouseholdObject: self.relationshipAndHousehold,
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
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        HATProfileService.getRelationshipAndHouseholdFromHAT(userDomain: userDomain, userToken: userToken, successCallback: updateTableWithValuesFrom, failCallback: errorFetching)
    }
    
    // MARK: - Completion handlers
    
    /**
     Updates the table with the new value returned from HAT
     
     - parameter nationalityObject: The nationality object returned from HAT
     */
    func updateTableWithValuesFrom(relationshipAndHouseholdObject: HATProfileRelationshipAndHouseholdObject) {
        
        self.relationshipAndHousehold = relationshipAndHouseholdObject
        self.tableView.reloadData()
    }
    
    /**
     Logs the error if it's not noValuesFund
     
     - parameter error: The error returned from HAT
     */
    func errorFetching(error: HATTableError) {
        
        switch error {
        case .noValuesFound:
            
            self.relationshipAndHousehold = HATProfileRelationshipAndHouseholdObject()
        default:
            
            _ = CrashLoggerHelper.hatTableErrorLog(error: error)
        }
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreRelationshipCell, for: indexPath) as? PhataTableViewCell {
            
            return setUpCell(cell: cell, indexPath: indexPath, relationshipAndHousehold: self.relationshipAndHousehold)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.dataStoreRelationshipCell, for: indexPath)
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
    func setUpCell(cell: PhataTableViewCell, indexPath: IndexPath, relationshipAndHousehold: HATProfileRelationshipAndHouseholdObject) -> UITableViewCell {
        
        cell.accessoryType = .none
        
        if indexPath.section == 0 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.relationshipStatus)
        } else if indexPath.section == 1 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.typeOfAccomodation)
        } else if indexPath.section == 2 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.livingSituation)
        } else if indexPath.section == 3 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.howManyUsuallyLiveInYourHousehold)
        } else if indexPath.section == 4 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.householdOwnership)
        } else if indexPath.section == 5 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.hasChildren)
        } else if indexPath.section == 6 {
            
            cell.setTextToTextField(text: String(describing: relationshipAndHousehold.numberOfChildren))
        } else if indexPath.section == 7 {
            
            cell.setTextToTextField(text: relationshipAndHousehold.additionalDependents)
        }
        
        return cell
    }

}
