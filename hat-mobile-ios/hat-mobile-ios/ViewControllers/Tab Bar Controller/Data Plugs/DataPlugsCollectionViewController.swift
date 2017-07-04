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
import SafariServices

// MARK: Class

/// The data plugs View in the tab bar view controller
internal class DataPlugsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// An array with the available data plugs
    private var dataPlugs: [HATDataPlugObject] = []
    
    /// A view to show that app is loading, fetching data plugs
    private var loadingView: UIView = UIView()
    
    /// A reference to safari view controller in order to be able to show or hide it
    private var safariVC: SFSafariViewController?
    
    // MARK: - View controller methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add notification observer for response from server
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertForDataPlug), name: Notification.Name(Constants.NotificationNames.dataPlug), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.dataPlugs.removeAll()
        self.collectionView?.reloadData()
                
        /// method to execute on a successful callback
        func successfullCallBack(data: [HATDataPlugObject], renewedUserToken: String?) {
            
            // remove the existing dataplugs from array
            self.dataPlugs = HATDataPlugsService.filterAvailableDataPlugs(dataPlugs: data)
            
            // check if dataplugs are active
            self.checkDataPlugsIfActive()
            
            // refresh user token
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
        }
        
        /// method to execute on a failed callback
        func failureCallBack() {
            
            // remove the loading screen from the view
            self.loadingView.removeFromSuperview()
        }
        
        // create loading pop up screen
        self.loadingView = UIView.createLoadingView(with: CGRect(x: (self.collectionView?.frame.midX)! - 70, y: (self.collectionView?.frame.midY)! - 15, width: 140, height: 30), color: .shapeInfluencePink, cornerRadius: 15, in: self.view, with: "Getting data plugs...", textColor: .white, font: UIFont(name: Constants.FontNames.openSans, size: 12)!)
        
        // get available data plugs from server
        HATDataPlugsService.getAvailableDataPlugs(succesfulCallBack: successfullCallBack, failCallBack: {(error) -> Void in
        
            failureCallBack()
            _ = CrashLoggerHelper.dataPlugErrorLog(error: error)
        })
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        // reload collection view
        self.collectionView?.reloadData()
    }
    
    // MARK: - Notification observer method
    
    /**
     Hides safari view controller
     
     - parameter notif: The notification object sent
     */
    @objc
    private func showAlertForDataPlug(notif: Notification) {
        
        // check that safari is not nil, if it's not hide it
        self.safariVC?.dismissSafari(animated: true, completion: nil)
    }
    
    // MARK: - Check if data plugs are active

    /**
     Checks if both data plugs are active
     */
    private func checkDataPlugsIfActive() {
        
        func setupCheckMark(onDataPlug: String, value: Bool) {
            
            // search in data plugs array for facebook and enable the checkmark
            if !self.dataPlugs.isEmpty {
                
                for i in 0 ... self.dataPlugs.count - 1 where self.dataPlugs[i].name == onDataPlug {
                    
                    self.dataPlugs[i].showCheckMark = value
                    self.collectionView?.reloadData()
                    self.loadingView.removeFromSuperview()
                }
            }
        }
        
        HATDataPlugsService.checkDataPlugsIfActive(completion: setupCheckMark)
    }

    // MARK: - UICollectionView methods

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataPlugs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let orientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIDs.dataplug, for: indexPath) as? DataPlugCollectionViewCell {
            
            return DataPlugCollectionViewCell.setUp(cell: cell, indexPath: indexPath, dataPlug: self.dataPlugs[indexPath.row], orientation: orientation)
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIDs.dataplug, for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let url = HATDataPlugsService.createURLBasedOn(socialServiceName: self.dataPlugs[indexPath.row].name, socialServiceURL: self.dataPlugs[indexPath.row].url) {
            
            // open safari view controller
            self.safariVC = SFSafariViewController.openInSafari(url: url, on: self, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        
        // in case of landscape show 3 tiles instead of 2
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            
            return CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        }
        
        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
    }
    
}
