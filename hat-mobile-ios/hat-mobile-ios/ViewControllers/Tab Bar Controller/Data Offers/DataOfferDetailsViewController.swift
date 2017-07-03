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

// MARK: Class

internal class DataOfferDetailsViewController: UIViewController, UserCredentialsProtocol {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var textField: UITextView!
    @IBOutlet private weak var dataRequirmentTextView: UITextView!
    
    @IBOutlet private weak var piiExplainedLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var offersRemainingLabel: UILabel!
    @IBOutlet private weak var ppiEnabledLabel: UILabel!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var infoView: UIView!
    
    @IBOutlet private weak var acceptOfferButton: UIButton!
    
    // MARK: - Variables
    
    var receivedOffer: DataOfferObject?
    
    // MARK: - IBActions
    
    @IBAction func acceptOfferAction(_ sender: Any) {
        
        let remaining = (receivedOffer?.requiredMaxUsers)! - (receivedOffer?.usersClaimedOffer)!
        if remaining > 0 {
            
            func gotApplicationToken(appToken: String, newUserToken: String?) {
                
                func success(claimResult: String, renewedUserToken: String?) {
                    
                    print(claimResult)
                    self.navigationController?.popViewController(animated: true)
                }
                
                func failed(error: DataPlugError) {
                    
                    print(error)
                }
                
                HATDataOffersService.claimOffer(
                    applicationToken: appToken,
                    offerID: (receivedOffer?.dataOfferID)!,
                    succesfulCallBack: success,
                    failCallBack: failed)
            }
            
            func failedGettingAppToken(error: JSONParsingError) {
                
                print(error)
            }
            
            HATService.getApplicationTokenFor(
                serviceName: "DataBuyer",
                userDomain: self.userDomain,
                token: self.userToken,
                resource: "https://databuyer.hubofallthings.com/",
                succesfulCallBack: gotApplicationToken,
                failCallBack: failedGettingAppToken)
        } else {
            
            self.createClassicOKAlertWith(
                alertMessage: "There are no remaining spots for this offer",
                alertTitle: "Offer reched maximum allowed user number",
                okTitle: "OK",
                proceedCompletion: {})
        }
    }
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.acceptOfferButton.addBorderToButton(width: 1, color: .white)
        
        if receivedOffer != nil {
            
            self.titleLabel.text = receivedOffer?.title
            self.detailsLabel.text = receivedOffer?.shortDescription
            self.imageView.image = receivedOffer?.image
            self.textField.text = receivedOffer?.longDescription
            self.offersRemainingLabel.text = String(describing: ((receivedOffer?.requiredMaxUsers)! - (receivedOffer?.usersClaimedOffer)!)) + " REMAINING"
            self.dataRequirmentTextView.attributedText = self.formatRequiredDataDefinitionText(requiredDataDefinition: (receivedOffer?.requiredDataDefinition)!)
            
            if receivedOffer!.isPΙIRequested {
                
                self.ppiEnabledLabel.text = "PII ENABLED"
                self.piiExplainedLabel.text = "PERSONALLY IDENTIFIABLE INFORMATION (PII) IS REQUIRED IN THIS OFFER"
            } else {
                
                self.ppiEnabledLabel.text = "PII DISABLED"
                self.piiExplainedLabel.text = "NO PERSONALLY IDENTIFIABLE INFORMATION (PII) IS REQUIRED IN THIS OFFER"
            }
        }
        
        self.stackView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.stackView.isHidden = false
        
        navigationController?.hidesBarsOnSwipe = false
        
        let view = self.stackView.arrangedSubviews[1]
        view.addLine(view: self.infoView, xPoint: self.infoView.bounds.midX, yPoint: 0)
        view.drawTicketView()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        let view = self.stackView.arrangedSubviews[1]
        view.drawTicketView()
        view.addLine(view: self.infoView, xPoint: self.infoView.bounds.midX, yPoint: 0)
    }
    
    // MARK: - Format Text
    
    /**
     Formatts the requirements to show in a nice way
     
     - parameter requiredDataDefinition: The requred data definition array, holding all the requirements for this offer
     
     - returns: An NSMutableString with the requirements formmated as needed
     */
    private func formatRequiredDataDefinitionText(requiredDataDefinition: [DataOfferRequiredDataDefinitionObject]) -> NSMutableAttributedString {
        
        let textToReturn = NSMutableAttributedString(string: "REQUIREMENTS:\n", attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!])
        
        for requiredData in requiredDataDefinition {
            
            let string = NSMutableAttributedString(string: "\(requiredData.source)\n", attributes: [NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 13)!])
            
            textToReturn.append(string)
            
            for dataSet in requiredData.dataSets {
                
                func reccuringFields(fieldsArray: [DataOfferRequiredDataDefinitionDataSetsFieldsObject], intend: String) -> NSMutableAttributedString {
                    
                    let tempText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!])
                    
                    for field in fieldsArray {
                        
                        let fieldString = NSMutableAttributedString(string: "\(intend)\(field.name)\n", attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!])
                        
                        tempText.append(fieldString)
                        
                        if !field.fields.isEmpty {
                            
                            tempText.append(reccuringFields(fieldsArray: field.fields, intend: intend + "\t"))
                        }
                    }
                    
                    return tempText
                }
                
                let dataName = NSMutableAttributedString(string: "\t\(dataSet.name)\n", attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!])
                
                textToReturn.append(dataName)
                textToReturn.append(reccuringFields(fieldsArray: dataSet.fields, intend: "\t\t"))
            }
        }
        
        return textToReturn
    }

}
