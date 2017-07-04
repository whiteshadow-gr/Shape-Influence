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

/// The first PageViewController in Learn More. Responsible for showing a view controller with info about the HAT
internal class ParentPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: - Variables
    
    /// the number of pages for this page view controller
    private let numberOfPages: [Int] = [0, 1, 2, 3, 4, 5, 6]
    
    /// The current page index
    private var currentIndex: Int = 0
    
    // MARK: - PageViewController delegate methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create view controller
        self.createPageViewController()
        
        // change the color of the pagination dots at the bottom of the screen
        self.changePaginationColors(pageTintColor: .shapeInfluencePink, pageCurrentTintColor: .white)
        
        // add notification observers for disabling and enabling page controll
        NotificationCenter.default.addObserver(self, selector: #selector(disablePageControll), name: Notification.Name(Constants.NotificationNames.disablePageControll), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enablePageControll), name: Notification.Name(Constants.NotificationNames.enablePageControll), object: nil)
        
        // change background color
        self.view.backgroundColor = .shapeInfluencePink
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        //corrects scrollview frame to allow for full-screen view controller pages
        self.makePageControllerFullScreen()
    }
    
    // MARK: - Page view controller methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // create the view controller for the previous page
        if let itemController = viewController as? PageViewController {
            
            // check if we are out of bounds and return the view controller
            if itemController.itemIndex > 0 {
                
                return getItemController(itemIndex: itemController.itemIndex - 1)
            }
        }
        
        // reached first page return nil
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // create the view controller for the next page
        if let itemController = viewController as? PageViewController {
            
            // check if we are out of bounds and return the view controller
            if itemController.itemIndex + 1 < numberOfPages.count {
                
                return getItemController(itemIndex: itemController.itemIndex + 1)
            }
        }
        
        // reached final page return nil
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.numberOfPages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return self.currentIndex
    }
    
    // MARK: - Handle page control
    
    /**
     Disables page control
     
     - parameter notification: The Notification object send with this notification
     */
    @objc
    private func disablePageControll(notification: Notification) {
        
        self.dataSource = nil
    }
    
    /**
     Enables page control
     
     - parameter notification: The Notification object send with this notification
     */
    @objc
    private func enablePageControll(notification: Notification) {
        
        self.dataSource = self
        _ = self.getItemController(itemIndex: 6)
        
        // change the color of the pagination dots at the bottom of the screen
        UIPageControl.appearance().pageIndicatorTintColor = .shapeInfluencePink
    }
    
    // MARK: - Create view controller
    
    /**
     Creates and adds the view controller to the page view controller
     */
    private func createPageViewController() {
        
        // set datasource to self
        self.dataSource = self
        
        // if we have pages to show init them and add them to the page view controller
        if !numberOfPages.isEmpty {
            
            let firstController = getItemController(itemIndex: 0)!
            let startingViewControllers = [firstController]
            self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
    }
    
    /**
     Create the view controller to present
     
     - parameter itemIndex: The number of the page to create
     
     - returns: An optional HATCapabilitiesViewController
     */
    private func getItemController(itemIndex: Int) -> PageViewController? {
        
        // check if we are out of bounds
        if itemIndex < numberOfPages.count {
            
            // create the view controller and return it
            if let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as? PageViewController {
                
                pageItemController.itemIndex = itemIndex
                self.currentIndex = itemIndex
                
                return pageItemController
            }
        }
        
        return nil
    }
}
