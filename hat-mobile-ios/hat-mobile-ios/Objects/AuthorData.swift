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

import SwiftyJSON

// MARK: Struct

/// A struct representing the author table received from JSON
class AuthorData: Equatable {
    
    // MARK: - Comparable protocol
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: AuthorData, rhs: AuthorData) -> Bool {
        
        return (lhs.nickName == rhs.nickName && lhs.name == rhs.name && lhs.photoURL == rhs.photoURL && lhs.phata == rhs.phata && lhs.id == rhs.id)
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func <(lhs: AuthorData, rhs: AuthorData) -> Bool {
        
        return lhs.name < rhs.name
    }
    
    // MARK: - Variables
    
    /// the nickname of the author
    var nickName: String
    /// the name of the author
    var name: String
    /// the photo url of the author
    var photoURL: String
    /// the phata of the author. Required
    var phata: String
    
    /// the id of the author
    var id: Int
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    init() {
        
        nickName = ""
        name = ""
        photoURL = ""
        id = 0
        phata = ""
    }
    
    /**
     It initialises everything from the received JSON file from the HAT
     */
    convenience init(dict: Dictionary<String, JSON>) {
        
        // init optional JSON fields to default values
        self.init()
        
        // this field will always have a value no need to use if let
        if let tempPHATA = dict["phata"]?.string {
            
            phata = tempPHATA
        }

        // check optional fields for value, if found assign it to the correct variable
        if let tempID = dict["id"]?.stringValue {
            
            // check if string is "" as well
            if tempID != ""{
                
                if let intTempID = Int(tempID) {
                    
                    id = intTempID
                }
            }
        }
        
        if let tempNickName = dict["nick"]?.string {
            
            nickName = tempNickName
        }
        
        if let tempName = dict["name"]?.string {
            
            name = tempName
        }
        
        if let tempPhotoURL = dict["photo_url"]?.string {
            
            photoURL = tempPhotoURL
        }
    }
}
