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
import StoreKit

// MARK: Class

/// Get A hat view controller, used in onboarding of new users
internal class GetAHATViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    /// Stripe token for this purchase
    private var token: String = ""
    
    /// The hat image
    private var hatImage: UIImage?
    
    /// the available HAT providers fetched from HAT
    private var hatProviders: [HATProviderObject] = []
    
    /// a dark view pop up to hide the background
    private var darkView: UIVisualEffectView?
    
    /// the information of the hat provider cell that the user tapped
    private var selectedHATProvider: HATProviderObject?

    // MARK: - IBOutlets

    /// An IBOutlet for handling the learn more button
    @IBOutlet private weak var learnMoreButton: UIButton!
    
    /// An IBOutlet for handling the arrow bar on top of the view
    @IBOutlet private weak var arrowBarImage: UIImageView!
    
    /// An IBOutlet for handling the collection view
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - IBActions
    
    /**
     Triggers the sign up sequence
     
     - parameter sender: The object that called this method
     */
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        // create page view controller
        if let cell = self.collectionView.cellForItem(at: indexPath) as? OnboardingTileCollectionViewCell {
            
            self.registerForHatInfo(cell: cell, indexPath: indexPath)
        }
    }
    
    /**
     Presents a pop up view showing the user more information about HAT
     
     - parameter sender: The object that called this method
     */
    @IBAction func learnMoreInfoButtonAction(_ sender: Any) {
        
        // set up page controller
        if let popUp = InfoHatProvidersViewController.setUpInfoHatProviderViewControllerPopUp(from: self.storyboard!) {
            
            self.darkView = AnimationHelper.addBlurToView(self.view)
            AnimationHelper.animateView(
                popUp.view,
                duration: 0.2,
                animations: { [weak self] () -> Void in
                    
                    if let weakSelf = self {
                        
                        popUp.view.frame = CGRect(x: weakSelf.view.frame.origin.x + 15, y: weakSelf.view.bounds.origin.y + 150, width: weakSelf.view.frame.width - 30, height: weakSelf.view.bounds.height)
                    }
                },
                completion: { _ in return })
            
            // add the page view controller to self
            self.addViewController(popUp)
        }
    }
    
    // MARK: - UIViewController delegate methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // config the arrowBar
        self.arrowBarImage.image = self.arrowBarImage.image!.withRenderingMode(.alwaysTemplate)
        self.arrowBarImage.tintColor = .rumpelDarkGray
        
        self.learnMoreButton.addBorderToButton(width: 1, color: .teal)
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(hidePopUpView), name: NSNotification.Name(Constants.NotificationNames.hideGetAHATPopUp), object: nil)
        
        // fetch available hat providers
        HATService.getAvailableHATProviders(succesfulCallBack: refreshCollectionView, failCallBack: { (_) -> Void in return })
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        // reload collection view controller to adjust to the new width of the screen
        self.collectionView?.reloadData()
    }
    
    // MARK: - Refresh collection view
    
    /**
     Refreshes the collection view when the right notification is received
     
     - parameter dataReceived: A callback executed when data received
     */
    private func refreshCollectionView(dataReceived: [HATProviderObject], renewedUserToken: String?) {
        
        if !dataReceived.isEmpty {
            
            self.hatProviders = [dataReceived[0]]
            self.collectionView.reloadData()
            
            // refresh user token
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
        }
    }
    
    // MARK: - Hide pop up
    
    /**
     Hides the pop up view controller when the right notification is received
     
     - parameter notification: The norification object that called this method
     */
    @objc
    private func hidePopUpView(notification: Notification) {
        
        // check if we have an object
        if notification.object != nil && self.selectedHATProvider?.price == 0 {
            
            self.token = ""
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: Constants.Segue.stripeSegue, sender: self)
        }
        
        // remove the dark view pop up
        self.darkView?.removeFromSuperview()
    }
    
    // MARK: - UICollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        // create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseIDs.onboardingTile, for: indexPath) as? OnboardingTileCollectionViewCell
        
        let orientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        
        // format cell
        return OnboardingTileCollectionViewCell.setUp(cell: cell!, indexPath: indexPath, hatProvider: self.hatProviders[indexPath.row], orientation: orientation)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.hatProviders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        // create page view controller
        if let cell = collectionView.cellForItem(at: indexPath) as? OnboardingTileCollectionViewCell {
            
            self.registerForHatInfo(cell: cell, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width, height: self.view.frame.height - self.collectionView.frame.origin.y)
    }
    
    // MARK: - Register for hat animation
    
    /**
     Saves image and hat provider for later use and presents an animated View Controller with the info for that HAT provider
     
     - parameter cell: The cell to provide the info, image and provider
     - parameter indexPath: The index path of the tapped cell
     */
    private func registerForHatInfo(cell: OnboardingTileCollectionViewCell, indexPath: IndexPath) {
        
        // save the data we need for later use
        self.hatImage = cell.getProviderImage()
        self.hatProviders[indexPath.row].hatProviderImage = self.hatImage
        self.selectedHATProvider = self.hatProviders[indexPath.row]
        
        // set up page controller
        if let pageItemController = GetAHATInfoViewController.setUpInfoHatProviderViewControllerPopUp(from: self.storyboard!, hatProvider: self.hatProviders[indexPath.row]) {
            
            // present a dark pop up view to darken the background view controller
            self.darkView = AnimationHelper.addBlurToView(self.view)
            
            AnimationHelper.animateView(
                pageItemController.view,
                duration: 0.2,
                animations: {[weak self] () -> Void in
                    
                    if let weakSelf = self {
                        
                        pageItemController.view.frame = CGRect(x: weakSelf.view.frame.origin.x + 15, y: weakSelf.view.bounds.origin.y + 150, width: weakSelf.view.frame.width - 30, height: weakSelf.view.bounds.height - 130)
                    }
                },
                completion: { _ in return })
            
            // add the page view controller to self
            self.addViewController(pageItemController)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segue.stripeSegue {
            
            let controller = segue.destination as? StripeViewController
            
            controller?.sku = (self.selectedHATProvider?.sku)!
            controller?.token = self.token
            controller?.hatImage = self.hatImage
            controller?.domain = "." + (self.selectedHATProvider?.kind.domain)!
        }
    }
}
