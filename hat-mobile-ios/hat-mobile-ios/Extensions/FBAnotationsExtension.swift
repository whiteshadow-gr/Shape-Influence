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

import FBAnnotationClusteringSwift
import HatForIOS
import MapKit
import RealmSwift

// MARK: Extension

extension FBClusteringManager {
    
    // MARK: - Get locations and cluster them

    /**
     Fetches and adds the annotations to the map view/
     Takes a predicate, e.g. day, yesterday, week
     Fetch the DataPoints in a background thread and update the UI once complete
     
     - parameter predicate: The predicate to filter the data points with
     - parameter mapView: The mapView to show the cluster points to
     */
    func fetchAndClusterPoints(_ predicate: NSPredicate, mapView: MKMapView) {
        
        DispatchQueue.global().async { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                var annottationArray: [FBAnnotation] = []
                
                //Get the results. Results list is optional
                if let results: Results <DataPoint> = RealmHelper.getResults(predicate) {
                    
                    for dataPoint: DataPoint in results {
                        
                        // add pin into results array
                        let pin = FBAnnotation()
                        pin.coordinate = CLLocationCoordinate2D(latitude: dataPoint.lat, longitude: dataPoint.lng)
                        annottationArray.append(pin)
                    }
                    
                    weakSelf.addPointsToMap(annottationArray: annottationArray, mapView: mapView)
                }
            }
        }
    }
    
    // MARK: - Add point to map
    
    /**
     Adds the pins to the map
     
     - parameter annottationArray: The anottations, pins, to add to the map
     - parameter mapView: The mapView to show the cluster points to
     */
    func addPointsToMap(annottationArray: [FBAnnotation], mapView: MKMapView) {
        
        // we must set annotations to replace old ones
        self.removeAll()
        self.add(annotations: annottationArray)
        
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                if !annottationArray.isEmpty {
                    
                    weakSelf.fitMapViewToAnnotaionList(annottationArray, mapView: mapView)
                }
            }
        })
    }
    
    // MARK: - Create annotations for the locations
    
    /**
     Converts the LocationsObjects to pins to add in the map later
     
     - parameter objects: The LocationsObjects to convert to FBAnnotation, pins
     
     - returns: An array of FBAnnotation, pins
     */
    func createAnnotationsFrom(objects: [HATLocationsObject]) -> [FBAnnotation] {
        
        var arrayToReturn: [FBAnnotation] = []
        
        for item in objects {
            
            let pin = FBAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: Double(item.data.locations.latitude)!, longitude: Double(item.data.locations.longitude)!)
            arrayToReturn.append(pin)
        }
        
        return arrayToReturn
    }
    
    // MARK: - Reposition map to fit the new points
    
    /**
     Updates map view with the annotations provided
     
     - parameter annotations: The annotations to add on the map in an array of FBAnnotation
     - parameter mapView: The mapView to show the cluster points to
     */
    func fitMapViewToAnnotaionList(_ annotations: [FBAnnotation], mapView: MKMapView) {
        
        // calculate map padding and zoom
        let mapEdgePadding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var zoomRect: MKMapRect = MKMapRectNull
        
        // create a point for each annotation
        for index in 0..<annotations.count {
            
            let annotation = annotations[index]
            let aPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect: MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
            
            if MKMapRectIsNull(zoomRect) {
                
                zoomRect = rect
            } else {
                
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        
        // focus map on the added points
        mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
    }
}
