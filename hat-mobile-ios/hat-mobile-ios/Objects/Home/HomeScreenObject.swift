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

/// A class representing the tiles in the home screen
internal class HomeScreenObject: NSObject {
    
    // MARK: - Variables

    /// The image for the tile
    var serviceImage: UIImage = UIImage()
    
    /// The service name of the tile
    var serviceName: String = ""
    /// The description of the tile
    var serviceDescription: String = ""
    
    // MARK: - Initialisers
    
    /**
     The default initialiser. Initialises everything to default values.
     */
    override init() {
        
        serviceName = ""
        serviceDescription = ""
        serviceImage = UIImage()
    }
    
    /**
     It initialises everything from the passed values
     */
    convenience init(name: String, description: String, image: UIImage) {
        
        self.init()
        
        serviceName = name
        serviceDescription = description
        serviceImage = image
    }
    
    // MARK: - Return the 4 tiles we need for the home screen
    
    /**
     Returns the 4 tiles we need for the Home Screen
     
     - returns: An array of 4 HomeScreenObject for display in home screen
     */
    class func setUpTilesForHomeScreen() -> [HomeScreenObject] {
        
        let notables = HomeScreenObject(name: "Notes", description: "Take notes, write lists or create life logs", image: UIImage(named: Constants.ImageNames.notesImage)!)
        let locations = HomeScreenObject(name: "Locations", description: "Track your movements over the day or week", image: UIImage(named: Constants.ImageNames.gpsOutlinedImage)!)
        let socialData = HomeScreenObject(name: "Social Data", description: "Social media posts stored in your HAT", image: UIImage(named: Constants.ImageNames.socialFeedImage)!)
        let chat = HomeScreenObject(name: "Photo Viewer", description: "Show the images you have uploaded in your HAT", image: UIImage(named: Constants.ImageNames.photoViewerImage)!)
        
        return [notables, locations, socialData, chat]
    }
}
