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

// MARK: UIViewController Extension

extension UIViewController {
    
    // MARK: - Keyboard methods
    
    /**
     Hides keyboard when tap anywhere in the screen except keyboard
     */
    public func hideKeyboardWhenTappedAround() {
        
        // create tap gesture
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        // add gesture to view
        view.addGestureRecognizer(gesture)
    }
    
    /**
     Hides keyboard
     */
    public func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    /**
     Adds keyboard handling to UIViewControllers via the common and standard Notifications
     */
    public func addKeyboardHandling() {
        
        // create 2 notification observers for listening to the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:.UIKeyboardWillHide, object: nil)
    }
    
    /**
     Function executed before the keyboard is shown to the user
     
     - parameter sender: The object that called this method
     */
    public func keyboardWillShow(sender: NSNotification) {
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == ((self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height) {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    /**
     Function executed before the keyboard hides from the user
     
     - parameter sender: The object that called this method
     */
    func keyboardWillHide(sender: NSNotification) {
        
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    /**
     Hides the keyboard and restores the scrollView to its original place
     
     - parameter scrollView: The UIScrollView object to handle
     */
    func hideKeyboardInScrollView(_ scrollView: UIScrollView) {
        
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    /**
     Shows the keyboard and lifts the view and scrollView accordingly
     
     - parameter view: The UIView object to handle
     - parameter scrollView: The UIScrollView object to handle
     - parameter sender: The object that called this method
     */
    func showKeyboardInView(_ view: UIView, scrollView: UIScrollView, sender: NSNotification) {
        
        var userInfo = sender.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    // MARK: - Textfield methods
    
    /**
     Function executed when the return key is pressed in order to hide the keyboard
     
     - parameter textField: The textfield that confronts to this function
     
     - returns: Bool
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Custom Alerts
    
    /**
     Creates a classic alert with 2 buttons
     
     - parameter alertMessage: The message of the alert
     - parameter alertTitle: The title of the alert
     - parameter cancelTitle: The title of the cancel button
     - parameter proceedTitle: The title of the proceed button
     - parameter proceedCompletion: The method to execute when the proceed button is pressed
     - parameter cancelCompletion: The method to execute when the cancel button is pressed
     */
    func createClassicAlertWith(alertMessage: String, alertTitle: String, cancelTitle: String, proceedTitle: String, proceedCompletion: @escaping () -> Void, cancelCompletion: @escaping () -> Void) {
        
        //change font
        let attrTitleString = NSAttributedString(string: alertTitle, attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 32)!])
        let attrMessageString = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 32)!])
        
        // create the alert
        let alert = UIAlertController(title: attrTitleString.string, message: attrMessageString.string, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: proceedTitle, style: .default, handler: { (_: UIAlertAction) in
            
            proceedCompletion()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (_: UIAlertAction) in
            
            cancelCompletion()
        }))
        
        // present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Creates a classic OK alert with 1 button
     
     - parameter alertMessage: The message of the alert
     - parameter alertTitle: The title of the alert
     - parameter okTitle: The title of the button
     - parameter proceedCompletion: The method to execute when the ok button is pressed
     */
    func createClassicOKAlertWith(alertMessage: String, alertTitle: String, okTitle: String, proceedCompletion: @escaping () -> Void) {
        
        //change font
        let attrTitleString = NSAttributedString(string: alertTitle, attributes: [NSFontAttributeName: UIFont(name: Constants.FontNames.openSans, size: 32)!])
        let attrMessageString = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: UIFont(name: Constants.FontNames.openSans, size: 32)!])
        
        // create the alert
        let alert = UIAlertController(title: attrTitleString.string, message: attrMessageString.string, preferredStyle: .alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (_: UIAlertAction) in
            
            proceedCompletion()
        }))
        
        // present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIStoryboard
    
    /**
     Get Main storyboard reference
     
     - returns: UIStoryboard
     */
    class func getMainStoryboard() -> UIStoryboard {
        
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    // MARK: - Remove view controller
    
    /**
     Removes the view controller that called this function of the superview and parent view controller
     */
    func removeViewController() {
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    // MARK: - Add view controller
    
    /**
     Adds the view controller passed in the parameter
     */
    func addViewController(_ viewController: UIViewController) {
        
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}
