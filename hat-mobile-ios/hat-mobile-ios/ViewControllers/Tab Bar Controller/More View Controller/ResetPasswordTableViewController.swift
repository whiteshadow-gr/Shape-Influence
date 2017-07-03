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

/// A class responsible for the reset password UITableViewController of the PHATA section
internal class ResetPasswordTableViewController: UITableViewController, UserCredentialsProtocol {
    
    // MARK: - Variables

    /// The sections of the table view
    private let sections: [[String]] = [[""], ["", ""]]
    /// The headers of the table view
    private let headers: [String] = ["Existing Password", "New Password"]
    /// The password strength score
    private var score: Int = 0
    /// The loading view pop up
    private var loadingView: UIView = UIView()
    /// A dark view covering the collection view cell
    private var darkView: UIView = UIView()
    
    // MARK: - IBActions
    
    /**
     Sends the profile data to hat
     
     - parameter sender: The object that calls this function
     */
    @IBAction func saveButtonAction(_ sender: Any) {
        
        var oldPassword: String = ""
        var newPassword1: String = ""
        var newPassword2: String = ""
        
        self.darkView = UIView(frame: self.tableView.frame)
        self.darkView.backgroundColor = .black
        self.darkView.alpha = 0.4
        
        self.view.addSubview(self.darkView)
        
        self.loadingView = UIView.createLoadingView(with: CGRect(x: (self.view?.frame.midX)! - 70, y: (self.view?.frame.midY)! - 15, width: 140, height: 30), color: .teal, cornerRadius: 15, in: self.view, with: "Changing password...", textColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 12)!)

        for index in self.headers.indices {
            
            // old password
            if index == 0 {
                
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? ResetPasswordTableViewCell {
                    
                    oldPassword = cell.getPassword()
                }
            // new password
            } else if index == 1 {
                
                let cell1 = self.tableView.cellForRow(at: IndexPath(row: 0, section: index)) as? ResetPasswordTableViewCell
                let cell2 = self.tableView.cellForRow(at: IndexPath(row: 1, section: index)) as? ResetPasswordTableViewCell

                if cell1 != nil && cell2 != nil {
                    
                    newPassword1 = cell1!.getPassword()
                    newPassword2 = cell2!.getPassword()
                }
            }
        }
        
        if newPassword1 == newPassword2 {
            
            if score > 2 {
                
                HATAccountService.changePassword(userDomain: userDomain, userToken: userToken, oldPassword: oldPassword, newPassword: newPassword1, successCallback: passwordChangedResult, failCallback: passwordErrorResult)
            } else {
                
                self.loadingView.removeFromSuperview()
                self.darkView.removeFromSuperview()
                self.createClassicOKAlertWith(alertMessage: "The new password seems to be too weak", alertTitle: "Password too weak", okTitle: "OK", proceedCompletion: {})
            }
        } else {
            
            self.loadingView.removeFromSuperview()
            self.darkView.removeFromSuperview()
            
            self.createClassicOKAlertWith(alertMessage: "The new passwords are not the same, you have made a typo in one of them", alertTitle: "Passwords do not match", okTitle: "OK", proceedCompletion: {})
        }
    }
    
    // MARK: - Update profile callbacks
    
    func passwordChangedResult(message: String, renewedToken: String?) {
        
        self.createClassicOKAlertWith(alertMessage: message, alertTitle: "Password change requested", okTitle: "OK", proceedCompletion: {
        
            if message == "Password changed" {
                
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            self.loadingView.removeFromSuperview()
            self.darkView.removeFromSuperview()
        })
    }
    
    func passwordErrorResult(error: HATError) {
        
        self.loadingView.removeFromSuperview()
        self.darkView.removeFromSuperview()
        
        _ = CrashLoggerHelper.hatErrorLog(error: error)
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.resetPasswordCell, for: indexPath) as? ResetPasswordTableViewCell {
            
            return cell.setUpCell(cell: cell, indexPath: indexPath)
        }
        
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.resetPasswordCell, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.headers[section]
    }

}
