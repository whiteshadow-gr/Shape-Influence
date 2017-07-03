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

import zxcvbn_ios

// MARK: Class

/// The class responsible for the reset password table view cell
internal class ResetPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - Variables
    
    private var score: Int = 0
    
    // MARK: - IBOutlets

    /// The textField that the user writes the old or new password
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - UITableViewCell methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Get Password
    
    /**
     Returns the password value of the UITextField
     
     - returns: A string with the password value of the UITextField
     */
    func getPassword() -> String {
        
        let password = self.textField.text
        if password != nil {
            
            return password!
        }
        return ""
    }
    
    // MARK: - Set up cell
    
    /**
     Updates and formats the cell accordingly
     
     - parameter cell: The ResetPasswordTableViewCell to update and format
     - parameter indexPath: The indexPath of the cell
     
     - returns: A UITableViewCell cell already updated and formatted accordingly
     */
    func setUpCell(cell: ResetPasswordTableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            cell.textField.delegate = nil
        } else if indexPath.section == 1 {
            
            cell.textField.delegate = self
        }
        
        return cell
    }
    
    // MARK: - Text field methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.score = ZXCVBNHelper.showPasswordMeterOn(textField: textField)
        
        return true
    }
}
