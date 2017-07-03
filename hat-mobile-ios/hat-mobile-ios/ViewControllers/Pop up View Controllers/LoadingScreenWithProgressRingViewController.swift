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

/// The class responsible for the loading ring progress bar pop up view controller
internal class LoadingScreenWithProgressRingViewController: UIViewController {
    
    // MARK: - Variables
    
    /// The percentage of the proccess completed
    private var completionPercentage: Double?
    
    // MARK: - IBOutlets

    /// An IBOutlet for handling the RingProgressCircle
    @IBOutlet private weak var progressRing: RingProgressCircle!
    
    /// An IBOutlet for handling the percentage UILabel
    @IBOutlet private weak var percentageLabel: UILabel!
    
    /// An IBOutlet for handling the cancel UIButton
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - IBActions

    /**
     It hides the loading ring progress bar
     
     - parameter sender: The object that called this method
     */
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.percentageLabel.text = String(describing: self.completionPercentage!) + " %"
        self.progressRing.ringRadius = 40
        self.progressRing.ringLineWidth = 5
        self.progressRing.ringColor = .white
        self.progressRing.backgroundRingColor = .rumpelDarkGray
        let fullCircle = 2.0 * CGFloat(Double.pi)
        self.progressRing.startPoint = -0.25 * fullCircle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        var frame = self.percentageLabel.frame
        frame.size.height = 21
        
        self.percentageLabel.frame = frame
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Update view
    
    /**
     Updates the ring view with new values
     
     - parameter completion: The percentage of the circle from 0 to 1
     - parameter animateFrom: The positions to start animating from
     - parameter removePreviousRingLayer: A bool value determing if removes the previous ring or adds one on top
     */
    func updateView(completion: Double, animateFrom: Float, removePreviousRingLayer: Bool) {
        
        self.progressRing.isHidden = false
        
        let end = (CGFloat(completion))
        
        let currentRatio = String(describing: floor(end * 100))
        self.percentageLabel.text = currentRatio + " %"

        self.progressRing.updateCircle(end: end, animate: animateFrom, removePreviousLayer: removePreviousRingLayer)
    }

    // MARK: - Init view
    
    /**
     Inits a TextPopUpViewController for immediate use
     
     - parameter stringToShow: The string to show to the pop up
     - parameter storyBoard: The storyboard to init the view from
     
     - returns: An optional instance of TextPopUpViewController ready to present from a view controller
     */
    class func customInit(completion: Double, from storyBoard: UIStoryboard) -> LoadingScreenWithProgressRingViewController? {
        
        let loadingViewController = storyBoard.instantiateViewController(withIdentifier: "loadingScreen") as? LoadingScreenWithProgressRingViewController
        
        loadingViewController?.completionPercentage = completion
        
        return loadingViewController
    }
    
    // MARK: Update ring
    
    func getRingEndPoint() -> CGFloat {
        
        return self.progressRing.endPoint
    }
}
