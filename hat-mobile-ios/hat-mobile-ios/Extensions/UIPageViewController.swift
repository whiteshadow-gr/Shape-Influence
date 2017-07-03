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

// MARK: Extension

extension UIPageViewController {
    
    // MARK: - Make page controller go Full Screen
    
    /**
     Present the page controller full screen
     */
    func makePageControllerFullScreen() {
        
        //corrects scrollview frame to allow for full-screen view controller pages
        for subView in self.view.subviews where subView is UIScrollView {
            
            subView.frame = self.view.bounds
        }
    }
    
    // MARK: - Change colors of the paginator
    
    /**
     Change pagination color of the page controller
     
     - parameter pageTintColor: The color of the pagination controller
     - parameter pageCurrentTintColor: The color of the current pagination controller
     */
    func changePaginationColors(pageTintColor: UIColor, pageCurrentTintColor: UIColor) {
        
        // change the color of the pagination dots at the bottom of the screen
        UIPageControl.appearance().pageIndicatorTintColor = pageTintColor
        UIPageControl.appearance().currentPageIndicatorTintColor = pageCurrentTintColor
    }
}
