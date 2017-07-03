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

import MapKit

// MARK: Class

/// A class responsible for taging a note with a location
internal class CheckInMapViewController: UIViewController, UpdateLocationsDelegate, UISearchBarDelegate, MKMapViewDelegate {
    
    // MARK: - Variables
    
    /// The location helper
    private let locationHelper: UpdateLocations = UpdateLocations()

    /// The results searchController, for searching for places nearby
    private var resultSearchController: UISearchController?
    
    /// A bool to determine if the map is focused on the user's location
    private var isFocusedToUsersPosition: Bool = false
    
    /// A Double variable containing the latitude of the point to return
    private var latitude: Double?
    /// A Double variable containing the longitude of the point to return
    private var longitude: Double?
    /// A Double variable containing the accuracy of the point to return
    private var accuracy: Double?
    
    /// A delegate to pass the location data back when the user has tapped the done button
    weak var noteOptionsDelegate: ShareOptionsViewController?
    
    // MARK: - IBOutlets

    /// An IBOutler for the searchBar
    @IBOutlet private weak var searchBar: UISearchBar!
    /// An IBOutler for the mapview
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - IBActions
    
    /**
     Called when the done button has been tapped
     
     - parameter sender: The object that called this method
     */
    @IBAction func doneButtonAction(_ sender: Any) {
        
        if self.latitude != nil && self.longitude != nil && self.accuracy != nil {
            
            noteOptionsDelegate?.locationDataReceived(latitude: self.latitude!, longitude: self.longitude!, accuracy: self.accuracy!)
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Called when the location button is tapped, focuses on the user's current location
     
     - parameter sender: The object that called this method
     */
    @IBAction func focusOnUsersLocation(_ sender: Any) {
        
        self.mapView.setCenter((self.locationHelper.locationManager?.location?.coordinate)!, animated: true)
    }
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set up map view
        self.mapView.showsUserLocation = true
        
        // set up location helper
        self.locationHelper.locationDelegate = self
        self.locationHelper.setUpLocationObject(self.locationHelper, delegate: UpdateLocations.shared)
        self.locationHelper.requestLocation()
        
        // set up search
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        self.searchBar = resultSearchController?.searchBar
        self.searchBar.delegate = self

        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // if we have coordinates zoom at user. It is possible to not have coordinates in the case the user has the location tracking enabled
        if let coordinates = self.locationHelper.locationManager?.location?.coordinate {
            
            self.zoomToCoordinates(coordinates)
        }
        
        let result = UpdateLocations.checkAuthorisation()
        
        if result.0 {
            
            if result.1 == .denied {
                
                self.createClassicOKAlertWith(
                    alertMessage: "You seem to have denied access to your location so you cannot use this feature. You can go to settings and change the persimission for Rumpel Lite",
                    alertTitle: "Permissions denied",
                    okTitle: "OK",
                    proceedCompletion: {})
            } else if result.1 == .notDetermined {
                
                self.locationHelper.requestAuthorisation()
            }
        } else {
            
            self.createClassicOKAlertWith(
                alertMessage: "Location service is disabled. You have to enable location service in order to use this feature", alertTitle: "Location service is disabled",
                okTitle: "OK",
                proceedCompletion: {})
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // resume locations to previous state, enabled or disabled
        UpdateLocations.shared.resumeLocationServices()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // resign first responder and dismiss it
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // if any annotation are on map delete hem
        if !self.mapView.annotations.isEmpty {
            
            for annotation in self.mapView.annotations {
                
                self.mapView.removeAnnotation(annotation)
            }
        }
        
        // set up a local search request based on current region and the text the user entered on the search bar
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearchRequest.region = self.mapView.region
        
        // init the search request
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, _) -> Void in
            
            // if no response show an alert
            if localSearchResponse == nil {
                
                self.createClassicOKAlertWith(alertMessage: "Place Not Found", alertTitle: "", okTitle: "OK", proceedCompletion: {})
                return
            }
            
            // for each item add annotation
            for mapItem in (localSearchResponse?.mapItems)! {
                
                // set up the pin annotation
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = mapItem.placemark.title
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
                
                // show the annotation on map
                let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = pointAnnotation.coordinate
                self.mapView.addAnnotation(pinAnnotationView.annotation!)
            }
        }
    }
    
    // MARK: - Protocol's function
    
    /**
     Decodes the locations received and saves them
     
     - parameter locations: The array of the locations received
     */
    func updateLocations(locations: [CLLocation]) {
        
        // if we have received locations
        if !locations.isEmpty {
            
            // get the last onee
            let lastLocation = locations.last
            
            if self.accuracy == nil {
                
                self.latitude = lastLocation?.coordinate.latitude
                self.longitude = lastLocation?.coordinate.longitude
                self.accuracy = lastLocation?.horizontalAccuracy
            } else if self.accuracy! > Double((lastLocation?.horizontalAccuracy)!) {
                
                self.latitude = lastLocation?.coordinate.latitude
                self.longitude = lastLocation?.coordinate.longitude
                self.accuracy = lastLocation?.horizontalAccuracy
            }
            
            // reverse geocode from the coordinates to get address etc.
            CLGeocoder().reverseGeocodeLocation(lastLocation!, completionHandler: {[weak self](placemarks, error) -> Void in
                print(lastLocation!)
                
                if let weakSelf = self {
                    
                    // in case of error show an error
                    if error != nil {
                        
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                    }
                    
                    if (placemarks?.count)! > 0 {
                        
                        if !weakSelf.isFocusedToUsersPosition {
                            
                            weakSelf.zoomToCoordinates((placemarks?[0].location?.coordinate)!)
                        }
                        //                    let pm = placemarks?[0]
                        //                    print(placemarks)
                    } else {
                        
                        print("Problem with the data received from geocoder")
                    }
                }
            })
        }
    }
    
    // MARK: - Zoom map
    
    /**
     Zooms to user's location on map
     
     - parameter coordinates: The coordinates to zoom
     */
    private func zoomToCoordinates(_ coordinates: CLLocationCoordinate2D) {
        
        // construct the rect based on the coordinates
        let rect = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500)
        // set the region on map
        self.mapView.setRegion(rect, animated: true)
        
        self.isFocusedToUsersPosition = true
    }

}
