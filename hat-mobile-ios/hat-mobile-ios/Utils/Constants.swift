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

// A class handling all the constant values for easy access
internal class Constants {
    
    // MARK: - Typealiases
    
    typealias MarketAccessTokenAlias = String
    typealias MarketDataPlugIDAlias = String
    typealias HATUsernameAlias = String
    typealias HATPasswordAlias = String
    typealias UserHATDomainAlias = String
    typealias HATRegistrationURLAlias = String
    typealias UserHATAccessTokenURLAlias = String
    typealias UserHATDomainPublicTokenURLAlias = String
    
    // MARK: - Enums
    
    /**
     The request fields for data points
     
     - Latitude: latitude
     - Longitude: longitude
     - Accuracy: accuracy
     - Timestamp: timestamp
     - allValues: An array of all the above values
     */
    enum RequestFields: String {
        
        /// Requesting Latitude
        case latitude
        /// Requesting Longitude
        case longitude
        /// Requesting Accuracy
        case accuracy
        /// Requesting Timestamp
        case timestamp
        
        /// Requesting all of RequestFields values in an array
        static let allValues: [RequestFields] = [latitude, longitude, accuracy, timestamp]
    }
    
    // MARK: - Structs
    
    /**
     The possible notification names, stored in convenience in one place
     
     - reauthorised: reauthorised
     - dataPlug: dataPlugMessage
     - hideNewbie: hideNewbiePageViewContoller
     */
    struct NotificationNames {
        
        static let reauthorised: String = "reauthorisedUser"
        static let dataPlug: String = "dataPlugMessage"
        static let hideGetAHATPopUp: String = "hideView"
        static let hatProviders: String = "hatProviders"
        static let hideInfoHATProvider: String = "hideInfoHATProvider"
        static let enablePageControll: String = "enablePageControll"
        static let disablePageControll: String = "disablePageControll"
        static let hideCapabilitiesPageViewContoller: String = "hideCapabilitiesPageViewContoller"
        static let hideLearnMore: String = "HideLearnMore"
        static let hideDataServicesInfo: String = "hideDataServicesInfo"
        static let networkMessage: String = "NetworkMessage"
        static let goToSettings: String = "goToSettings"
        static let reloadTable: String = "reloadTable"
    }
    
    /**
     The possible notification names, stored in convenience in one place
     
     - reauthorised: reauthorised
     - dataPlug: dataPlugMessage
     - hideNewbie: hideNewbiePageViewContoller
     */
    struct FontNames {
        
        static let openSansCondensedLight: String = "OpenSans-CondensedLight"
        static let openSans: String = "OpenSans"
        static let openSansBold: String = "OpenSans-Bold"
        static let ssGlyphishFilled: String = "SSGlyphish-Filled"
    }
    
    /**
     The possible reuse identifiers of the cells
     
     - dataplug: dataPlugCell
     */
    struct CellReuseIDs {
        
        static let dataplug: String = "dataPlugCell"
        static let onboardingTile: String = "onboardingTile"
        static let homeHeader: String = "homeHeader"
        static let socialCell: String = "socialCell"
        static let offerCell: String = "offerCell"
        static let dataStoreCell: String = "DataStoreCell"
        static let nameCell: String = "nameCell"
        static let dataStoreNameCell: String = "dataStoreNameCell"
        static let profileInfoCell: String = "profileInfoCell"
        static let dataStoreNationalityCell: String = "dataStoreNationalityCell"
        static let dataStoreRelationshipCell: String = "dataStoreRelationshipCell"
        static let dataStoreEducationCell: String = "dataStoreEducationCell"
        static let homeScreenCell: String = "homeScreenCell"
        static let cellDataWithImage: String = "cellDataWithImage"
        static let cellData: String = "cellData"
        static let addedImageCell: String = "addedImageCell"
        static let photosCell: String = "photosCell"
        static let imageSocialFeedCell: String = "imageSocialFeedCell"
        static let statusSocialFeedCell: String = "statusSocialFeedCell"
        static let aboutCell: String = "aboutCell"
        static let addressCell: String = "addressCell"
        static let emailCell: String = "emailCell"
        static let emergencyContactCell: String = "emergencyContactCell"
        static let optionsCell: String = "optionsCell"
        static let phataSettingsCell: String = "phataSettingsCell"
        static let phataCell: String = "phataCell"
        static let phoneCell: String = "phoneCell"
        static let resetPasswordCell: String = "resetPasswordCell"
        static let socialLinksCell: String = "socialLinksCell"
    }
    
    struct HATTableName {
        
        struct Profile {
            
            static let name: String = "profile"
            static let source: String = "rumpel"
        }
        
        struct Location {
            
            static let name: String = "locations"
            static let source: String = "iphone"
        }
    }
    
    /**
     Date formats
     */
    struct DateFormats {
        
        /// UTC format
        static let utc: String = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let gmt: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        static let posix: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let alternative: String = "E MMM dd HH:mm:ss Z yyyy"
    }
    
    /**
     Time zone formats
     */
    struct TimeZone {
        
        /// UTC format
        static let utc: String = "UTC"
        static let gmt: String = "GMT"
        static let posix: String = "en_US_POSIX"
    }
    
    /**
     DataPoint Block size
     */
    struct DataPointBlockSize {
        
        /// Max block size
        static let maxBlockSize: Int = 100
    }
    
    /**
     DataPoint purge data
     */
    struct PurgeData {
        
        /// Older than 7 days
        static let olderThan: Double = 7
    }
    
    /**
     Authentication struct
     */
    struct Auth {
        
        /// The name of the declared in the bundle identifier
        static let urlScheme: String = "rumpellocationtrackerapp"
        /// The name of the service, RumpelLite
        static let serviceName: String = "RumpelLite"
        /// The name of the local authentication host, can be anything
        static let localAuthHost: String = "rumpellocationtrackerapphost"
        /// The notification handler name, can be anything
        static let notificationHandlerName: String = "rumpellocationtrackerappnotificationhandler"
        /// The token name, QS parameter
        static let tokenParamName: String = "token"
    }
    
    /**
     Keychain struct
     */
    struct Keychain {
        
        struct Values {
            
            static let setTrue: String = "true"
            static let setFalse: String = "false"
            static let expired: String = "expired"
        }
        
        /// the HAT domain key
        static let hatDomainKey: String = "user_hat_domain"
        static let trackDeviceKey: String = "trackDevice"
        static let userToken: String = "UserToken"
        static let logedIn: String = "logedIn"
    }
    
    /**
     The content types available
     */
    struct ContentType {
        
        /// JSON content
        static let json: String = "application/json"
        /// Text content
        static let text: String = "text/plain"
    }
    
    struct Headers {
        
        static let accept: String = "Accept"
        static let contentType: String = "Content-Type"
        static let authToken: String = "X-Auth-Token"
    }
    
    struct UIViewLayerNames {
        
        static let dashedLine: String = "DashedTopLine"
        static let line: String = "Line"
    }
     
    /**
     HAT credintials for location tracking
     */
    struct HATDataPlugCredentials {
        
        /// hat username used for location data plug
        static let hatUsername: String = "location"
        /// hat password used for location data plug
        static let hatPassword: String = "MYl06ati0n"
        /// market data plug id used for location data plug
        static let marketsquareDataPlugID: String = "c532e122-db4a-44b8-9eaf-18989f214262"
        /// market access token used for location data plug
        static let marketsquareAccessToken: MarketAccessTokenAlias = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxLVZyaHVrWFh1bm9LRVwvd3p2Vmh4bm5FakdxVHc2RCs3WVZoMnBLYTdIRjJXbHdUV29MQWR3K0tEdzZrTCtkQjI2eHdEbE5sdERqTmRtRlwvVWtWM1A2ODF3TXBPSUxZbFVPaHI1WnErTT0iLCJkYXRhcGx1ZyI6ImM1MzJlMTIyLWRiNGEtNDRiOC05ZWFmLTE4OTg5ZjIxNDI2MiIsImlzcyI6ImhhdC1tYXJrZXQiLCJleHAiOjE1MTU2MDQ3NzUsImlhdCI6MTQ4NDg0NjM3NSwianRpIjoiZTBlMjIwY2VmNTMwMjllZmQ3ZDFkZWQxOTQzYzdlZWE5NWVjNWEwNGI4ZjA1MjU1MzEwNDgzYTk1N2VmYTQzZWZiMzQ5MGRhZThmMTY0M2ViOGNhNGVlOGZkNzI3ZDBiZDBhZGQyZTgzZWZkNmY4NjM2NWJiMjllYjY2NzQ3MWVhMjgwMmQ4ZTdkZWIxMzlhZDUzY2UwYzQ1ZTgxZmVmMGVjZTI5NWRkNTU0N2I2ODQzZmRiZTZlNjJmZTU1YzczYzAyYjA4MDAzM2FlMzQyMWUxZWJlMGFhOTgzNmE4MGNjZjQ0YmIxY2E1NmQ0ZjM4NWJkMzg1ZDY4ZmY0ZTIwMyJ9.bPTryrVhFa2uAMSZ6A5-Vvca7muEf8RrWoiire7K7ko"
    }
        
    /**
     The user's preferences, settings
     */
    struct Preferences {

        /// User's default accuracy
        static let userNewDefaultAccuracy: String = "shared_user_new_default_accuracy"
        static let userDefaultAccuracy: String = "UserNewDefaultAccuracy"
        /// User's map accuracy
        static let mapLocationAccuracy: String = "shared_map_location_accuracy"
        /// User's map distance
        static let mapLocationDistance: String = "shared_map_location_distance"
        /// User's map deferred distance
        static let mapLocationDeferredDistance: String = "shared_map_location_deferred_distance"
        /// User's map deferred timeout
        static let mapLocationDeferredTimeout: String = "shared_map_location_deferred_timeout"
        
        /// Successful sync count
        static let successfulSyncCount: String = "shared_successful_sync_count"
        /// Successful sync date
        static let successfulSyncDate: String = "shared_successful_sync_date"
    }
    
    /**
     The HAT datasource will never change (not for v1 at least). It's the structure for the data held at HAT
     */
     struct HATDataSource {
        
        /// The name of the data source
        let name: String = "locations"
        /// The source of the data source
        let source: String = "iphone"
        /// The fields of the data source
        var fields: [JSONDataSourceRequestField] = [JSONDataSourceRequestField]()

        /**
         Initializer, for each field in RequestFields.allValues extracts the info and adds it to fields
         */
        init() {

            // iterate over our RequestFields enum
            for field in RequestFields.allValues {
                
                let f: JSONDataSourceRequestField = JSONDataSourceRequestField()
                
                f.name = field.rawValue
                f.fieldEnum = field
                
                fields.append(f)
            }
        }
        
        /**
         Turns the fields into a JSON object, dictionary
         
         - returns: A dictionary of <String, AnyObject>
         */
        func toJSON() -> Dictionary<String, AnyObject> {
            
            var dictionaries = [[String: String]]()

            for field: JSONDataSourceRequestField in self.fields {
                
                dictionaries.append(["name": field.name])
            }

            // return the json as dictionary
            return [
                "name": self.name as AnyObject,
                "source": self.source as AnyObject,
                "fields": dictionaries as AnyObject
            ]
        }
    }
    
    // MARK: - Image names
    
    struct ImageNames {
        
        static let placeholderImage: String = "Image Placeholder"
        static let twitterImage: String = "Twitter"
        static let facebookImage: String = "Facebook"
        static let marketsquareImage: String = "Marketsquare"
        static let gpsFilledImage: String = "gps filled"
        static let imageDeleted: String = "Image Deleted"
        static let notesImage: String = "notes"
        static let gpsOutlinedImage: String = "gps outlined"
        static let socialFeedImage: String = "SocialFeed"
        static let photoViewerImage: String = "Photo Viewer"
        
        static let profileImage: String = "Profile"
        static let dataStoreImage: String = "Data store"
        static let individualImage: String = "Individual"
        static let secureImage: String = "Secure"
        static let portableImage: String = "Portable"
        static let futureImage: String = "Future"
        static let researchImage: String = "Research"
        static let standsForImage: String = "Stands for"
        static let stuffYourHATImage: String = "Stuff your HAT"
        static let hatServiceImage: String = "HAT Service"
        static let monetizeImage: String = "Monetize"
        static let personaliseImage: String = "Personalize"
        static let getSmartImage: String = "Get Smart"
        static let rumpelImage: String = "Rumpel"
        static let tealBinaryImage: String = "TealBinary"
        static let tealFingerprintImage: String = "TealFingerprint"
        static let tealDevicesImage: String = "TealDevices"
        static let tealImage: String = "Teal Image"
        static let addLocation: String = "Add Location"
    }
    
    // MARK: - Data Plug
    
    struct DataPlug {
        
        static let offerID: String = "32dde42f-5df9-4841-8257-5639db222e41"
        
        static func twitterDataPlugServiceURL(userDomain: String, socialServiceURL: String) -> String {
            
            return "https://" + userDomain + "/hatlogin?name=Twitter&redirect=" + socialServiceURL + "/authenticate/hat"
        }
        
        static func facebookDataPlugServiceURL(userDomain: String, socialServiceURL: String) -> String {
            
            return "https://" + userDomain + "/hatlogin?name=Facebook&redirect=" + socialServiceURL.replacingOccurrences(of: "dataplug", with: "hat/authenticate")
        }
    }
    
    // MARK: - Social networks
    
    struct SocialNetworks {
        
        struct Facebook {
            
            static let name: String = "facebook"
        }
        
        struct Twitter {
            
            static let name: String = "twitter"
        }
    }
    
    // MARK: - Application Tokens
    
    struct ApplicationToken {
        
        struct Dex {
            
            static let name: String = "dex"
            static let source: String = "https://dex.hubofallthings.com"
        }
        
        struct Marketsquare {
            
            static let name: String = "MarketSquare"
            static let source: String = "https://marketsquare.hubofallthings.com"
        }
    }
    
    // MARK: - Segue
    
    struct Segue {
        
        static let stripeSegue: String = "stripeSegue"
        static let termsSegue: String = "termsSegue"
        static let completePurchaseSegue: String = "completePurchaseSegue"
        static let offerToOfferDetailsSegue: String = "offerToOfferDetailsSegue"
        static let dataStoreToName: String = "dataStoreToName"
        static let dataStoreToInfoSegue: String = "dataStoreToInfoSegue"
        static let dataStoreToContactInfoSegue: String = "dataStoreToContactInfoSegue"
        static let dataStoreToNationalitySegue: String = "dataStoreToNationalitySegue"
        static let dataStoreToHouseholdSegue: String = "dataStoreToHouseholdSegue"
        static let dataStoreToEducationSegue: String = "dataStoreToEducationSegue"
        static let notesSegue: String = "notesSegue"
        static let locationsSegue: String = "locationsSegue"
        static let socialDataSegue: String = "socialDataSegue"
        static let photoViewerSegue: String = "photoViewerSegue"
        static let settingsSequeID: String = "SettingsSequeID"
        static let optionsSegue: String = "optionsSegue"
        static let editNoteSegue: String = "editNoteSegue"
        static let editNoteSegueWithImage: String = "editNoteSegueWithImage"
        static let checkInSegue: String = "checkInSegue"
        static let goToFullScreenSegue: String = "goToFullScreenSegue"
        static let createNoteToHATPhotosSegue: String = "createNoteToHATPhotosSegue"
        static let fullScreenPhotoViewerSegue: String = "fullScreenPhotoViewerSegue"
        static let phataSegue: String = "phataSegue"
        static let moreToResetPasswordSegue: String = "moreToResetPasswordSegue"
        static let dataSegue: String = "dataSegue"
        static let locationsSettingsSegue: String = "locationsSettingsSegue"
        static let moreToTermsSegue: String = "moreToTermsSegue"
        static let profilePhotoToFullScreenPhotoSegue: String = "profilePhotoToFullScreenPhotoSegue"
        static let profilePictureCell: String = "profilePictureCell"
        static let profileImageHeader: String = "profileImageHeader"
        static let profileToHATPhotosSegue: String = "profileToHATPhotosSegue"
        static let phataSettingsSegue: String = "phataSettingsSegue"
        static let phataToEmailSegue: String = "phataToEmailSegue"
        static let phataToPhoneSegue: String = "phataToPhoneSegue"
        static let phataToAddressSegue: String = "phataToAddressSegue"
        static let phataToNameSegue: String = "phataToNameSegue"
        static let phataToProfilePictureSegue: String = "phataToProfilePictureSegue"
        static let phataToEmergencyContactSegue: String = "phataToEmergencyContactSegue"
        static let phataToAboutSegue: String = "phataToAboutSegue"
        static let phataToSocialLinksSegue: String = "phataToSocialLinksSegue"
        static let phataToProfileInfoSegue: String = "phataToProfileInfoSegue"
    }
    
    // MARK: - HAT Endpoints
    
    struct HATEndpoints {
        
        static let appRegistrationWithHATURL: String = "https://marketsquare.hubofallthings.com/api/dataplugs/"
        static let contactUs: String = "contact@hatdex.org"
        static let mailingList: String = "http://hatdex.us12.list-manage2.com/subscribe?u=bf49285ca77275f68a5263b83&id=3ca9558266"
        static let purchaseHat: String = "https://hatters.hubofallthings.com/api/products/hat/purchase"
        
        static func hatLoginURL(userDomain: String) -> String {
            
            return "https://" + userDomain + "/hatlogin?name=" + Constants.Auth.serviceName + "&redirect=" +
                Constants.Auth.urlScheme + "://" + Constants.Auth.localAuthHost
        }
        
        static func fileInfoURL(fileID: String, userDomain: String) -> String {
            
            return "https://" + userDomain + "/api/v2/files/content/" + fileID
        }
        
        /**
         Should be performed before each data post request as token lifetime is short.
         
         - returns: UserHATAccessTokenURLAlias
         */
        static func theUserHATAccessTokenURL(userDomain: String) -> Constants.UserHATAccessTokenURLAlias {
            
            return "https://" + userDomain + "/users/access_token?username=" + Constants.HATDataPlugCredentials.hatUsername + "&password=" + Constants.HATDataPlugCredentials.hatPassword
        }
        
        /**
         Constructs the url to access the table we want
         
         - parameter tableName: The table name
         - parameter sourceName: The source name
         
         - returns: String
         */
        static func theUserHATCheckIfTableExistsURL(tableName: String, sourceName: String, userDomain: String) -> String {
            
            return "https://" + userDomain + "/data/table?name=" + tableName + "&source=" + sourceName
        }
        
        /**
         Constructs the URL in order to create new table. Should be performed only if there isn’t an existing data source already.
         
         - returns: String
         */
        static func theConfigureNewDataSourceURL(userDomain: String) -> String {
            
            return "https://" + userDomain + "/data/table"
        }
        
        /**
         Constructs the URL to get a field from a table
         
         - parameter fieldID: The fieldID number
         
         - returns: String
         */
        static func theGetFieldInformationUsingTableIDURL(_ fieldID: Int, userDomain: String) -> String {
            
            return "https://" + userDomain + "/data/table/" + String(fieldID)
        }
        
        /**
         Constructs the URL to post data to HAT
         
         - returns: String
         */
        static func thePOSTDataToHATURL(userDomain: String) -> String {
            
            return "https://" + userDomain + "/data/record/values"
        }
    }
}
