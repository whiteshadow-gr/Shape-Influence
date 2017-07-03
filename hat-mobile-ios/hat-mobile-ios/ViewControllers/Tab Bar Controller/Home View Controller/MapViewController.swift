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
import SwiftyJSON

// MARK: Class

/// The MapView to render the DataPoints
internal class MapViewController: UIViewController, MKMapViewDelegate, MapSettingsDelegate {

    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the mapView MKMapView
    @IBOutlet private weak var mapView: MKMapView!
    
    /// An IBOutlet for handling the buttonYesterday UIButton
    @IBOutlet private weak var buttonYesterday: UIButton!
    /// An IBOutlet for handling the buttonToday UIButton
    @IBOutlet private weak var buttonToday: UIButton!
    /// An IBOutlet for handling the buttonLastWeek UIButton
    @IBOutlet private weak var buttonLastWeek: UIButton!
    
    /// An IBOutlet for handling the calendarImageView UIImageView
    @IBOutlet private weak var calendarImageView: UIImageView!
    
    /// An IBOutlet for handling the hidden textField UITextField
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Variables
    
    /// The FBClusteringManager object constant
    private let clusteringManager: FBClusteringManager = FBClusteringManager()
    
    /// The selected enum category of Helper.TimePeriodSelected object
    private var timePeriodSelectedEnum: TimePeriodSelected = TimePeriodSelected.none
    
    /// The uidatepicker used in toolbar
    private var datePicker: UIDatePicker?
    
    /// The uidatepicker used in toolbar
    private var segmentControl: UISegmentedControl?
    
    /// The start date to filter for points
    private var filterDataPointsFrom: Date?
    /// The end date to filter for points
    private var filterDataPointsTo: Date?
    
    // MARK: - Auto generated methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // view controller title
        self.title = "Location"
        
        // add notification observer for refreshUI
        NotificationCenter.default.addObserver(self, selector: #selector(goToSettings), name: NSNotification.Name(Constants.NotificationNames.goToSettings), object: nil)
        
        // add gesture recognizers to today button
        buttonTodayTouchUp(UIBarButtonItem())
        
        let recogniser = UITapGestureRecognizer()
        recogniser.addTarget(self, action: #selector(self.selectDatesToViewLocations(gesture:)))
        self.calendarImageView.isUserInteractionEnabled = true
        self.calendarImageView.addGestureRecognizer(recogniser)
        
        self.createDatePickerAccessoryView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let result = KeychainHelper.getKeychainValue(key: Constants.Keychain.trackDeviceKey)
        
        if result != "true" {
            
            self.createClassicOKAlertWith(
                alertMessage: "You have disabled location tracking. To enable location tracking go to settings",
                alertTitle: "Location tracking disabled",
                okTitle: "OK",
                proceedCompletion: {})
        }
    }
    
    deinit {
        
        self.mapView.removeFromSuperview()
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.showsUserLocation = false
        self.mapView.delegate = nil
        self.mapView = nil
        self.removeFromParentViewController()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Create Date Picker
    
    /**
     Creates the date picker for choosing dates to show location for
     */
    private func createDatePickerAccessoryView() {
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 220))
        
        // Set some of UIDatePicker properties
        datePicker!.timeZone = NSTimeZone.local
        datePicker!.backgroundColor = .white
        datePicker!.datePickerMode = .date
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker!.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePickerButton(sender:)))
        doneButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.teal], for: .normal)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        spaceButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.teal], for: .normal)
        
        self.segmentControl = UISegmentedControl(items: ["From", "To"])
        self.segmentControl!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.teal], for: .normal)
        self.segmentControl!.selectedSegmentIndex = 0
        self.segmentControl!.addTarget(self, action: #selector(segmentedControlDidChange(sender:)), for: UIControlEvents.valueChanged)
        self.segmentControl!.tintColor = .teal
        
        let barButtonSegmentedControll = UIBarButtonItem(customView: segmentControl!)
        
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        spaceButton2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.teal], for: .normal)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelPickerButton(sender:)))
        cancelButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.teal], for: .normal)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .toolbarColor
        toolBar.sizeToFit()
        
        toolBar.setItems([cancelButton, spaceButton, barButtonSegmentedControll, spaceButton2, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.textField.inputView = datePicker
        self.textField.inputAccessoryView = toolBar
    }
    
    // MARK: - Toolbar methods
    
    /**
     Called everytime the segmented control changes value. Saves the from and to date to filter the locations
     
     - parameter sender: The object that called this method
     */
    func segmentedControlDidChange(sender: UISegmentedControl) {
        
        if self.segmentControl!.selectedSegmentIndex == 0 {
            
            if self.filterDataPointsFrom != nil {
                
                self.datePicker!.setDate(self.filterDataPointsFrom!, animated: true)
            }
        } else {
            
            if self.filterDataPointsTo != nil {
                
                self.datePicker!.setDate(self.filterDataPointsTo!, animated: true)
            }
        }
    }
    
    /**
    The method executed when user taps the done button on the toolbar to filter the locations
     
     - parameter sender: The object that called this method
     */
    func donePickerButton(sender: UIBarButtonItem) {
        
        self.textField.resignFirstResponder()
        let userToken = HATAccountService.getUsersTokenFromKeychain()
        let userDomain = HATAccountService.theUserHATDomain()
        
        let view = UIView()
        view.createFloatingView(
            frame: CGRect(x: self.view.frame.midX - 60, y: self.view.frame.midY - 15, width: 120, height: 30),
            color: .teal,
            cornerRadius: 15)
        
        let label = UILabel().createLabel(
            frame: CGRect(x: 0, y: 0, width: 120, height: 30),
            text: "Getting locations...",
            textColor: .white,
            textAlignment: .center,
            font: UIFont(name: Constants.FontNames.openSans, size: 12))
        
        view.addSubview(label)
        
        self.view.addSubview(view)
        
        func getLocationsFromTable(tableID: NSNumber, renewedUserToken: String?) {
            
            func receivedLocations(json: [JSON], renewedUserToken: String?) {
                
                var array: [HATLocationsObject] = []
                
                for item in json {
                    
                    array.append(HATLocationsObject(dict: item.dictionaryValue))
                }
                
                if array.isEmpty {
                    
                    if self.filterDataPointsTo! > Date() {
                        
                        self.createClassicOKAlertWith(
                            alertMessage: "There are no points for the selected dates, time travelling mode is deactivated",
                            alertTitle: "No points found",
                            okTitle: "OK",
                            proceedCompletion: {})
                    }
                    self.createClassicOKAlertWith(
                        alertMessage: "There are no points for the selected dates",
                        alertTitle: "No points found",
                        okTitle: "OK",
                        proceedCompletion: {})
                }
                
                let pins = clusteringManager.createAnnotationsFrom(objects: array)
                clusteringManager.addPointsToMap(annottationArray: pins, mapView: self.mapView)
                
                // refresh user token
                _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
                
                view.removeFromSuperview()
            }
            
            if self.filterDataPointsFrom != nil && self.filterDataPointsTo != nil {
                
                let starttime = HATFormatterHelper.formatDateToEpoch(date: self.filterDataPointsFrom!)
                let endtime = HATFormatterHelper.formatDateToEpoch(date: self.filterDataPointsTo!)
                
                if starttime != nil && endtime != nil {
                    
                    let parameters: Dictionary<String, String> = ["starttime": starttime!, "endtime": endtime!, "limit": "2000"]
                    
                    HATAccountService.getHatTableValues(
                        token: userToken,
                        userDomain: userDomain,
                        tableID: tableID,
                        parameters: parameters,
                        successCallback: receivedLocations,
                        errorCallback: {(error) in
                        
                            view.removeFromSuperview()
                            _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                        }
                    )
                }
            }
        }
        
        HATAccountService.checkHatTableExists(
            userDomain: userDomain,
            tableName: Constants.HATTableName.Location.name,
            sourceName: Constants.HATTableName.Location.source,
            authToken: userToken,
            successCallback: getLocationsFromTable,
            errorCallback: {(error) in
                
                view.removeFromSuperview()
                _ = CrashLoggerHelper.hatTableErrorLog(error: error)
            }
        )
    }
    
    /**
     The method executed when user taps the cancel button on the toolbar to filter the locations
     
     - parameter sender: The object that called this method
     */
    func cancelPickerButton(sender: UIBarButtonItem) {
        
        self.textField.resignFirstResponder()
        self.filterDataPointsFrom = nil
        self.filterDataPointsTo = nil
    }
    
    // MARK: - Date picker method
    
    /**
     The method executed when the picker value changes to save the date to the correct value
     
     - parameter sender: The object that called this method
     */
    func datePickerValueChanged(sender: UIDatePicker) {
        
        if self.segmentControl!.selectedSegmentIndex == 0 {
            
            self.filterDataPointsFrom = self.datePicker!.date.startOfTheDay()
            if let endOfDay = self.datePicker!.date.endOfTheDay() {
                
                self.filterDataPointsTo = endOfDay
            }
        } else {
            
            if let endOfDay = self.datePicker!.date.endOfTheDay() {
                
                self.filterDataPointsTo = endOfDay
            }
        }
    }
    
    // MARK: - Hidden Text Field method
    
    /**
     Init from and to values
     
    - parameter sender: The object that called this method
     */
    func selectDatesToViewLocations(gesture: UITapGestureRecognizer) {
        
        self.textField.becomeFirstResponder()
        self.filterDataPointsFrom = Date().startOfTheDay()
        if let endOfDay = Date().endOfTheDay() {
            
            self.filterDataPointsTo = endOfDay
        }
    }
    
    // MARK: - Notification methods
    
    /**
     Presents the settings view controller
     */
    @objc
    private func goToSettings() {
        
        self.performSegue(withIdentifier: Constants.Segue.settingsSequeID, sender: self)
    }
    
    // MARK: - IBActions
    
    /**
     Today tap event
     Create predicte for 7 days for now
     
     - parameter sender: The UIBarButtonItem that called this method
     */
    @IBAction func buttonLastWeekTouchUp(_ sender: UIBarButtonItem) {
        
        // filter data
        self.timePeriodSelectedEnum = TimePeriodSelected.lastWeek
        
        let lastWeek = Date().addingTimeInterval(FutureTimeInterval.init(days: Double(7), timeType: TimeType.past).interval)
        let predicate = NSPredicate(format: "dateAdded >= %@", lastWeek as CVarArg)
        clusteringManager.fetchAndClusterPoints(predicate, mapView: self.mapView)
    }
    
    /**
     Today tap event
     Create predicte for today
     
     - parameter sender: The UIBarButtonItem that called this method
     */
    @IBAction func buttonTodayTouchUp(_ sender: UIBarButtonItem) {
        
        // filter data
        self.timePeriodSelectedEnum = TimePeriodSelected.today
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let predicate = NSPredicate(format: "dateAdded >= %@", startOfToday as CVarArg)
        clusteringManager.fetchAndClusterPoints(predicate, mapView: self.mapView)
    }
    
    /**
     Today tap event
     Create predicte for yesterday *only*
     
     - parameter sender: The UIBarButtonItem that called this method
     */
    @IBAction func buttonYesterdayTouchUp(_ sender: UIBarButtonItem) {
        
        // filter data
        self.timePeriodSelectedEnum = TimePeriodSelected.yesterday
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let yesteday = startOfToday.addingTimeInterval(FutureTimeInterval.init(days: Double(1), timeType: TimeType.past).interval) // remove 24hrs
        let predicate = NSPredicate(format: "dateAdded >= %@ and dateAdded <= %@", yesteday as CVarArg, startOfToday as CVarArg)
        clusteringManager.fetchAndClusterPoints(predicate, mapView: self.mapView)
    }
    
    // MARK: - MapView delegate methods
    
    /**
     Called when the map region changes...pan..zoom, etc
     
     - parameter mapView: the mapview
     - parameter animated: animated
     */
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if self.textField.isFirstResponder {
            
            DispatchQueue.main.async { [unowned self] () -> Void in
                
                self.textField.resignFirstResponder()
                self.filterDataPointsFrom = nil
                self.filterDataPointsTo = nil
            }
        }
        
        OperationQueue().addOperation({ [weak self] () -> Void in
            
            if let wSelf = self {
                
                // calculate map size and scale
                let mapBoundsWidth = Double(wSelf.mapView.bounds.size.width)
                let mapRectWidth: Double = wSelf.mapView.visibleMapRect.size.width
                let scale: Double = mapBoundsWidth / mapRectWidth
                let annotationArray = wSelf.clusteringManager.clusteredAnnotations(withinMapRect: wSelf.mapView.visibleMapRect, zoomScale: scale)
                DispatchQueue.main.sync(execute: { [weak self] () -> Void in
                    
                    if let weakSelf = self {
                        
                        // display map
                        weakSelf.clusteringManager.display(annotations: annotationArray, onMapView: weakSelf.mapView)
                    }
                })
            }
        })
    }
    
    /**
     Called through map delegate to update its annotations
     
     - parameter mapView: the maoview object
     - parameter annotation: annotation to render
     
     - returns: An optional object of type MKAnnotationView
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "Pin"
        if annotation.isKind(of: FBAnnotationCluster.self) {
            
            return FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .green
            return pinView
        }
    }
    
    // MARK: - Protocol methods
    
    func onUpdateCount(_ count: Int) {
        
        // only update if today
        if self.timePeriodSelectedEnum == TimePeriodSelected.today {
            
            // refresh map UI too on changed
            DispatchQueue.main.async(execute: { [unowned self] () -> Void in
                
                // refresh map UI too
                self.buttonToday.sendActions(for: .touchUpInside)
            })
        }
    }
    
    func onUpdateError(_ error: String) {
        
        // used for debug only
        //self.labelErrors.text = error
    }
    
    func onChanged() {
        
        UpdateLocations.shared.resumeLocationServices()
    }
}
