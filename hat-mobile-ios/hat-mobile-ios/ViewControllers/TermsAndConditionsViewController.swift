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

// MARK: class

/// The terms and conditions view controller class
internal class TermsAndConditionsViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Variables
    
    /// the path to the pdf file
    var filePathURL: String = ""
    
    // MARK: - IBOutlets

    /// An IBOutlet to handle the webview
    @IBOutlet private weak var webView: UIWebView!
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // if url not nil load the file
        if let url = URL(string: self.filePathURL) {
            
            let request = NSURLRequest(url: url)
            self.webView.delegate = self
            self.webView.loadRequest(request as URLRequest)
            
            // You might want to scale the page to fit
            self.webView.scalesPageToFit = true
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - WebView delegate
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        print(error)
    }

}
