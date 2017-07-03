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

import CoreLocation

// MARK: Class

/// A class responsible for handling the gps tracking
internal class UpdateLocations: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Variables
    
    /// The delegate variable of the protocol for gps tracking
    weak var locationDelegate: UpdateLocationsDelegate?
    
    /// A singleton to always have access to
    static let shared: UpdateLocations = UpdateLocations()
    
    /// An optional function to execute after the delegate has executed
    var completion: ((CLLocation) -> Void)?
    
    // The region currently monitoring
    private var region: CLCircularRegion?
    
    /// The LocationManager responsible for the settings used for gps tracking
    var locationManager: CLLocationManager? = CLLocationManager()

    // MARK: - Initialiser
    
    override init() {
        
        super.init()
        
        self.initLocationManager()
        
        self.resumeLocationServices()
    }
    
    /**
     Inits locationManager to default values
     */
    func initLocationManager() {
        
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = MapsHelper.getUserPreferencesAccuracy()
        self.locationManager?.distanceFilter = MapsHelper.getUserPreferencesDistance()
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.disallowDeferredLocationUpdates()
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.activityType = .otherNavigation
        self.locationManager?.delegate = self
    }
    
    /**
     Sets up the location object properties and delegate
     
     - parameter locationObject: A location object that confronts to UpdateLocations protocol
     - parameter delegate: A viewController that confronts to UpdateLocations protocol
     */
    func setUpLocationObject(_ locationObject: UpdateLocations, delegate: UpdateLocations) {
        
        locationObject.initLocationManager()
        locationObject.locationManager?.delegate = delegate
    }
    
    // MARK: - Location Manager Delegate Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // add locations gather to database
        MapsHelper.addLocationsToDatabase(locationManager: manager, locations: locations)
        
        // stop monitoring for regions
        self.stopMonitoringAllRegions()
        
        // create a new region
        self.region = CLCircularRegion(center: locations[locations.count - 1].coordinate, radius: 150, identifier: "UpdateCircle")
        self.region!.notifyOnExit = true
        
        // call delegate method
        self.locationDelegate?.updateLocations(locations: locations)
        
        // stop using gps and start monitoring for the new region
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.startMonitoring(for: region!)
        
        // if a completion was specified execute it
        self.completion?(locations.last!)
        self.completion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // create a new region everytime the user exits the region
        if region is CLCircularRegion {
            
            self.locationManager?.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        let message = "Monitoring failed for region with identifier: \(region!.identifier)"
        _ = CrashLoggerHelper.customErrorLog(message: message, error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let message = "Location Manager failed with the following error: \(error)"
        _ = CrashLoggerHelper.customErrorLog(message: message, error: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        if error != nil {
            
            let message = "error: \(error!.localizedDescription), status code: \(String(describing: manager.monitoredRegions))"
            _ = CrashLoggerHelper.customErrorLog(message: message, error: error!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.resumeLocationServices()
    }
    
    // MARK: - Wrappers to enable disable tracking
    
    /**
     Start updating location
     */
    public func startUpdatingLocation() {
        
        /*
         If not authorised, we can ignore.
         Once user i    s logged in and has accepted the authorization, this will always be true
         */
        if let manager: CLLocationManager = locationManager {
            
            if let result = KeychainHelper.getKeychainValue(key: Constants.Keychain.trackDeviceKey) {
                
                if result == "true" {
                    
                    manager.requestLocation()
                }
            } else {
                
                _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.trackDeviceKey, value: Constants.Keychain.Values.setTrue)
                self.stopMonitoringAllRegions()
                self.locationManager?.stopUpdatingLocation()
                self.locationManager = nil
                self.locationManager?.stopMonitoringSignificantLocationChanges()
            }
        }
    }
    
    /**
     Stop updating location
     */
    public func stopUpdatingLocation() {
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    /**
     Stop monitoring ALL regions
     */
    public func stopMonitoringAllRegions() {
        
        if let regions = self.locationManager?.monitoredRegions {
            
            for region in regions {
                
                self.locationManager?.stopMonitoring(for: region)
            }
        }
    
        self.region = nil
    }
    
    /**
     Start monitoring for significant, >500m, location changes
     */
    public func startMonitoringSignificantLocationChanges() {
        
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    /**
     Stop monitoring for significant, >500m, location changes
     */
    public func stopMonitoringSignificantLocationChanges() {
        
        self.locationManager?.stopMonitoringSignificantLocationChanges()
    }
    
    /**
     Request user's location
     */
    public func requestLocation() {
        
        self.locationManager?.requestLocation()
    }
    
    /**
     Resume location services as they were previously, if user had locations disabled then disabled it.
     */
    public func resumeLocationServices() {
        
        let result = KeychainHelper.getKeychainValue(key: Constants.Keychain.trackDeviceKey)
        
        if result == "true" {
            
            if !CLLocationManager.locationServicesEnabled() {
                
                self.locationManager?.requestAlwaysAuthorization()
            }
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startMonitoringSignificantLocationChanges()
            self.locationManager?.requestLocation()
        } else if result == "false" {
            
            self.stopMonitoringAllRegions()
            self.locationManager?.stopUpdatingLocation()
            self.locationManager?.stopMonitoringSignificantLocationChanges()
            self.locationManager = nil
        } else {
            
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.trackDeviceKey, value: Constants.Keychain.Values.setTrue)
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startMonitoringSignificantLocationChanges()
            self.locationManager?.requestLocation()
        }
    }
    
    /**
     Requests authorisation from user
     */
    public func requestAuthorisation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            self.locationManager?.requestAlwaysAuthorization()
        }
    }
    
    /**
     Checks if app is authorised to collect location data
     */
    public class func checkAuthorisation() -> (Bool, CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined:
                
               return (true, .notDetermined)
            case .restricted:
                
                return (true, .restricted)
            case .denied:
                
                return (true, .denied)
            case .authorizedAlways, .authorizedWhenInUse:
                
                return (true, .authorizedAlways)
            }
        }
        
        return (false, .denied)
    }
}
