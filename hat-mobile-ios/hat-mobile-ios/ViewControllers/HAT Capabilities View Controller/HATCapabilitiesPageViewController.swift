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

/// The second PageViewController. Responsible for showing a view controller with info about the HAT
internal class HATCapabilitiesPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    
    /// the number of pages array.
    private let numberOfPages: [Int] = [0, 1, 2, 3, 4]

    // MARK: - View controller delegate methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // create page view controller
        self.createPageViewController()
        
        // change the color of the pagination dots at the bottom of the screen
        self.changePaginationColors(pageTintColor: .lightGray, pageCurrentTintColor: .white)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        
        //corrects scrollview frame to allow for full-screen view controller pages
        self.makePageControllerFullScreen()
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Create page view controller
    
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
    private func getItemController(itemIndex: Int) -> HATCapabilitiesViewController? {
        
        // check if we are out of bounds
        if itemIndex < numberOfPages.count {
            
            // create the view controller and return it
            if let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "CapabilitiesViewController") as? HATCapabilitiesViewController {
                
                pageItemController.pageIndex = itemIndex
                return pageItemController
            }
        }
        
        return nil
    }
    
    // MARK: - Page view controlelr delegate methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // create the view controller for the previous page
        if let itemController = viewController as? HATCapabilitiesViewController {
            
            // check if we are out of bounds and return the view controller
            if itemController.pageIndex > 0 {
                
                return getItemController(itemIndex: itemController.pageIndex - 1)
            }
        }
        
        // reached first page return nil
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // create the view controller for the next page
        if let itemController = viewController as? HATCapabilitiesViewController {
            
            // check if we are out of bounds and return the view controller
            if itemController.pageIndex + 1 < numberOfPages.count {
                
                return getItemController(itemIndex: itemController.pageIndex + 1)
            }
        }
        
        // reached final page, return nil
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.numberOfPages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
}
