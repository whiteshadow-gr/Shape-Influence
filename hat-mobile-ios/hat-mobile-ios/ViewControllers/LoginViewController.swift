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

/// The Login View Controller
internal class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets

    /// An IBOutlet for handling the learnMoreButton
    @IBOutlet private weak var learnMoreButton: UIButton!
    /// An IBOutlet for handling the getAHATButton
    @IBOutlet private weak var getAHATButton: UIButton!
    /// An IBOutlet for handling the buttonLogon
    @IBOutlet private weak var buttonLogon: UIButton!
    /// An IBOutlet for handling the joinCommunityButton
    @IBOutlet private weak var joinCommunityButton: UIButton!
    /// An IBOutlet for handling the domainButton
    @IBOutlet private weak var domainButton: UIButton!
    
    /// An IBOutlet for handling the labelAppVersion
    @IBOutlet private weak var labelAppVersion: UILabel!
    
    /// An IBOutlet for handling the labelTitle
    @IBOutlet private weak var labelTitle: UITextView!
    /// An IBOutlet for handling the labelSubTitle
    @IBOutlet private weak var labelSubTitle: UITextView!
    /// An IBOutlet for handling the inputUserHATDomain
    @IBOutlet private weak var inputUserHATDomain: UITextField!
    
    /// An IBOutlet for handling the background image
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    /// An IBOutlet for handling the scrollView
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    
    /// A String typealias
    typealias MarketAccessToken = String
   
    /// SafariViewController variable
    private var safariVC: SFSafariViewController?
    
    /// SafariViewController variable
    private var popUpView: UIView?
    
    /// The mail view controller to be able to send email
    private let mailHelper: MailHelper = MailHelper()
        
    // MARK: - IBActions
    
    /**
     A button showing the different HAT's to select in order to log in
     
     - parameter sender: The object that called this method
     */
    @IBAction func domainButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Select domain", message: nil, preferredStyle: .actionSheet)
        
        let hubofallthingsAction = UIAlertAction(title: ".hubofallthings.net", style: .default, handler: {[unowned self](_: UIAlertAction) -> Void in
            
            self.domainButton.setTitle(".hubofallthings.net", for: .normal)
        })
        
        let bsafeAction = UIAlertAction(title: ".bheard.org", style: .default, handler: {[unowned self](_: UIAlertAction) -> Void in
            
            self.domainButton.setTitle(".bheard.org", for: .normal)
        })
        
        let hubatAction = UIAlertAction(title: ".hubat.net", style: .default, handler: {[unowned self](_: UIAlertAction) -> Void in
            
            self.domainButton.setTitle(".hubat.net", for: .normal)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addActions(actions: [hubofallthingsAction, bsafeAction, hubatAction, cancelAction])
        alert.addiPadSupport(sourceRect: self.domainButton.frame, sourceView: self.domainButton)
        
        // present alert controller
        self.navigationController!.present(alert, animated: true, completion: nil)
    }
    
    /**
     A button launching email view controller
     
     - parameter sender: The object that called this method
     */
    @IBAction func contactUsActionButton(_ sender: Any) {
        
        self.mailHelper.sendEmail(atAddress: Constants.HATEndpoints.contactUs, onBehalf: self)
    }
    
    /**
     A button opening safari to redirect user to mad hatters
     
     - parameter sender: The object that called this method
     */
    @IBAction func joinOurCommunityButtonAction(_ sender: Any) {
        
        if let url = URL(string: Constants.HATEndpoints.mailingList) {
            
            UIApplication.shared.openURL(url)
        }
    }
    
    /**
     An action executed when the logon button is pressed
     
     - parameter sender: The object that calls this method
     */
    @IBAction func buttonLogonTouchUp(_ sender: AnyObject) {
        
        func failed(error: String) {
            
            self.createClassicOKAlertWith(alertMessage: "Please check your personal hat address again", alertTitle: "Wrong domain!", okTitle: "OK", proceedCompletion: {})
        }
        
        if self.inputUserHATDomain.text != "" {
            
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.logedIn, value: Constants.Keychain.Values.setFalse)
            let filteredDomain = self.removeDomainFromUserEnteredText(domain: self.inputUserHATDomain.text!)

            HATLoginService.formatAndVerifyDomain(userHATDomain: filteredDomain + (self.domainButton.titleLabel?.text)!, successfulVerification: self.authoriseUser, failedVerification: failed)
        } else {
            
            self.createClassicOKAlertWith(alertMessage: "Please input your HAT domain", alertTitle: "HAT domain is empty!", okTitle: "OK", proceedCompletion: {})
        }
    }
    
    // MARK: - Remove domain from entered text
    
    /**
     Removes domain from entered text
     
     - parameter domain: The user entered text
     - returns: The filtered text
     */
    private func removeDomainFromUserEnteredText(domain: String) -> String {
        
        let array = domain.components(separatedBy: ".")
        
        if !array.isEmpty {
            
            return array[0]
        }
        
        return domain
    }
    
    // MARK: - View Controller functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add keyboard handling
        self.addKeyboardHandling()
        self.hideKeyboardWhenTappedAround()
        
        // disable the navigation back button
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        // set title
        self.title = NSLocalizedString("logon_label", comment:  "logon title")
        
        let partOne = "Rumpel ".createTextAttributes(foregroundColor: .white, strokeColor: .white, font: UIFont(name: Constants.FontNames.openSansCondensedLight, size: 36)!)
        let partTwo = "Lite".createTextAttributes(foregroundColor: .shapeInfluencePink, strokeColor: .shapeInfluencePink, font: UIFont(name: Constants.FontNames.openSansCondensedLight, size: 36)!)
        
        self.labelTitle.attributedText = partOne.combineWith(attributedText: partTwo)
        self.labelTitle.textAlignment = .center
        
        // move placeholder inside by 5 points
        self.inputUserHATDomain.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        // input
        self.inputUserHATDomain.placeholder = NSLocalizedString("hat_domain_placeholder", comment:  "user HAT domain")

        // button
        self.buttonLogon.setTitle(NSLocalizedString("logon_label", comment:  "username"), for: UIControlState())
        self.buttonLogon.backgroundColor = .shapeInfluencePink
        
        // app version
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            self.labelAppVersion.text = "v. " + version
        }
        
        // add notification observer for the login in
        NotificationCenter.default.addObserver(self, selector: #selector(self.hatLoginAuth), name: NSNotification.Name(rawValue: Constants.Auth.notificationHandlerName), object: nil)
        
        self.joinCommunityButton.addBorderToButton(width: 1, color: .white)
        self.getAHATButton.addBorderToButton(width: 1, color: .white)
        self.learnMoreButton.addBorderToButton(width: 1, color: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // when the view appears clear the text field. The user might pressed sing out, this field must not contain the previous address
        self.inputUserHATDomain.text = ""
        
        // Create a button bar for the number pad
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
        
        if let result = KeychainHelper.getKeychainValue(key: Constants.Keychain.hatDomainKey) {
            
            let barButtonTitle = result
            
            // Setup the buttons to be put in the system.
            let autofillButton = UIBarButtonItem(title: barButtonTitle, style: .done, target: self, action: #selector(self.autofillPHATA))
            autofillButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: Constants.FontNames.openSans, size: 16.0)!, NSForegroundColorAttributeName: UIColor.white], for: .normal)
            toolbar.barTintColor = .black
            toolbar.setItems([autofillButton], animated: true)
            
            if barButtonTitle != "" {
                
                self.inputUserHATDomain.inputAccessoryView = toolbar
                self.inputUserHATDomain.inputAccessoryView?.backgroundColor = .black
            }
        }
    }
    
    // MARK: - Accesory Input View Method
    
    /**
     Fills the domain text field with the user's domain
     */
    @objc
    private func autofillPHATA() {
        
        if let result = KeychainHelper.getKeychainValue(key: Constants.Keychain.hatDomainKey) {
            
            let domain = result.components(separatedBy: ".")
            self.inputUserHATDomain.text = domain[0]
            self.domainButton.setTitle("." + domain[1] + "." + domain[2], for: .normal)
        }
    }
    
    // MARK: - Authorisation functions
    
    /**
     Authorise user with the hat
     
     - parameter hatDomain: The phata address of the user
     */
    private func authoriseUser(hatDomain: String) {
              
        self.safariVC = SFSafariViewController.openInSafari(url: Constants.HATEndpoints.hatLoginURL(userDomain: hatDomain), on: self, animated: true, completion: nil)
    }
    
    /**
     The notification received from the login precedure.
     
     - parameter NSNotification: notification
     */
    @objc
    private func hatLoginAuth(notification: NSNotification) {
        
        // get the url form the auth callback
        if let url = notification.object as? NSURL {
            
            // first of all, we close the safari vc
            self.safariVC?.dismissSafari(animated: true, completion: nil)
            
            self.popUpView = UIView()
            popUpView!.createFloatingView(frame: CGRect(x: self.view.frame.midX - 60, y: self.view.frame.midY - 15, width: 120, height: 30), color: .shapeInfluencePink, cornerRadius: 15)
            
            let label = UILabel().createLabel(frame: CGRect(x: 0, y: 0, width: 120, height: 30), text: "Authenticating...", textColor: .white, textAlignment: .center, font: UIFont(name: Constants.FontNames.openSans, size: 12))
            
            self.popUpView!.addSubview(label)
            
            self.view.addSubview(self.popUpView!)
            
            func success(token: String?) {
                
                self.hidePopUpLabel()
                
                if token != "" || token != nil {
                    
                    _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: token!)
                }
                
                let userDomain = HATAccountService.theUserHATDomain()
                
                self.enableLocationDataPlug(userDomain, userDomain)
                _ = self.navigationController?.popToRootViewController(animated: false)
            }
            
            func failed(error: AuthenicationError) {
                
                self.hidePopUpLabel()
                
                let alert = CrashLoggerHelper.authenticationErrorLog(error: error)
                self.present(alert, animated: true, completion: nil)
            }
            
            // authorize with hat
            let filteredDomain = self.removeDomainFromUserEnteredText(domain: self.inputUserHATDomain.text!)
            _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.hatDomainKey, value: self.inputUserHATDomain.text! + (self.domainButton.titleLabel?.text)!)
            HATLoginService.loginToHATAuthorization(userDomain: filteredDomain + (self.domainButton.titleLabel?.text)!, url: url, success: success, failed: failed)
        }
    }
    
    // MARK: - Enable location data plug
    
    /**
     Saves the hatdomain from token to keychain for easy log in
     
     - parameter userDomain: The user's domain
     - parameter HATDomainFromToken: The HAT domain extracted from the token
     */
    private func enableLocationDataPlug(_ userDomain: String, _ HATDomainFromToken: String) {
        
        func success(result: Bool) {
            
            // setting image to nil and everything to clear color because animation was laggy
            self.backgroundImage.image = nil
            self.backgroundImage.backgroundColor = .clear
            self.scrollView.backgroundColor = .clear
            self.view.backgroundColor = .clear
            self.hidePopUpLabel()
            
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
        
        func failed(error: JSONParsingError) {
            
            let alert = CrashLoggerHelper.JSONParsingErrorLog(error: error)
            self.present(alert, animated: true, completion: nil)
        }
        
        HATLocationService.enableLocationDataPlug(userDomain, HATDomainFromToken, success: success, failed: failed)
    }
    
    // MARK: - Keyboard handling
    
    override func keyboardWillHide(sender: NSNotification) {
        
        self.hideKeyboardInScrollView(self.scrollView)
    }
    
    override func keyboardWillShow(sender: NSNotification) {
        
        self.showKeyboardInView(self.view, scrollView: self.scrollView, sender: sender)
    }
    
    // MARK: - Hide label
    
    /**
     Hides the pop up, Authenticating..., label
     */
    private func hidePopUpLabel() {
        
        self.popUpView?.removeFromSuperview()
    }
}
