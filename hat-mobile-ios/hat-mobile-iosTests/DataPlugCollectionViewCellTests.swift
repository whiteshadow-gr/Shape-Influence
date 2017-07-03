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

@testable import Pods_hat_mobile_ios
@testable import SwiftyJSON
import XCTest

internal class DataPlugCollectionViewCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var note = NotesData()
        
        note.id = 1
        note.lastUpdated = Date()
        note.name = "test"
        
        note.data.authorData.id = 1
        note.data.authorData.name = "Marios"
        note.data.authorData.nickName = "whiteshadow"
        note.data.authorData.phata = "mariostsekis.hubofallthings.net"
        note.data.authorData.photoURL = ""
        
        note.data.createdTime = Date()
        
        note.data.kind = "note"
        
        note.data.locationData.accuracy = 5
        note.data.locationData.altitude = 100
        note.data.locationData.altitudeAccuracy = 50
        note.data.locationData.heading = ""
        note.data.locationData.latitude = -10
        note.data.locationData.longitude = 10
        note.data.locationData.shared = false
        note.data.locationData.speed = 5
        
        note.data.message = "Test message"
        
        note.data.photoData.caption = ""
        note.data.photoData.link = ""
        note.data.photoData.shared = false
        note.data.photoData.source = ""
        
        note.data.publicUntil = Date()
        
        note.data.shared = false
        
        _ = UITableViewCell()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
