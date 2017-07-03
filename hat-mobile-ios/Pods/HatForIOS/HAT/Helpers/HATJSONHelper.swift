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

import SwiftyJSON

// MARK: Struct

public struct HATJSONHelper {

    // MARK: - Create JSON files functions

    /**
     Creates the profile JSON file
     
     - returns: Dictionary<String, Any>
     */
    public static func createProfileTableJSON() -> Dictionary<String, Any> {

        let fieldsJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let facebookProfilePhoto: Any = [

            "name": "fb_profile_photo",
            "source": "rumpel",
            "fields": fieldsJSON
        ]

        let personalJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "title")),
            Dictionary.init(dictionaryLiteral: ("name", "first_name")),
            Dictionary.init(dictionaryLiteral: ("name", "middle_name")),
            Dictionary.init(dictionaryLiteral: ("name", "last_name")),
            Dictionary.init(dictionaryLiteral: ("name", "preferred_name")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let personal: Any = [

            "name": "personal",
            "source": "rumpel",
            "fields": personalJSON
        ]

        let nickJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "name")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let nick: Any = [

            "name": "nick",
            "source": "rumpel",
            "fields": nickJSON
        ]

        let birthJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "date")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let birth: Any = [

            "name": "birth",
            "source": "rumpel",
            "fields": birthJSON
        ]

        let genderJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "type")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let gender: Any = [

            "name": "gender",
            "source": "rumpel",
            "fields": genderJSON
        ]

        let ageJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "group")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let age: Any = [

            "name": "age",
            "source": "rumpel",
            "fields": ageJSON
        ]

        let emailJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "value")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let primaryEmail: Any = [

            "name": "primary_email",
            "source": "rumpel",
            "fields": emailJSON
        ]

        let alternativeEmail: Any = [

            "name": "alternative_email",
            "source": "rumpel",
            "fields": emailJSON
        ]

        let phoneJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "no")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let homePhone: Any = [

            "name": "home_phone",
            "source": "rumpel",
            "fields": phoneJSON
        ]

        let mobile: Any = [

            "name": "mobile",
            "source": "rumpel",
            "fields": phoneJSON
        ]

        let addressDetailsJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "no")),
            Dictionary.init(dictionaryLiteral: ("name", "street")),
            Dictionary.init(dictionaryLiteral: ("name", "postcode")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let addressDetails: Any = [

            "name": "address_details",
            "source": "rumpel",
            "fields": addressDetailsJSON
        ]

        let addressGlobalJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "city")),
            Dictionary.init(dictionaryLiteral: ("name", "county")),
            Dictionary.init(dictionaryLiteral: ("name", "country")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let addressGlobal: Any = [

            "name": "address_global",
            "source": "rumpel",
            "fields": addressGlobalJSON
        ]

        let socialJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "link")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let website: Any = [

            "name": "website",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let blog: Any = [

            "name": "blog",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let facebook: Any = [

            "name": "facebook",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let twitter: Any = [

            "name": "twitter",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let google: Any = [

            "name": "google",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let youtube: Any = [

            "name": "youtube",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let linkedIn: Any = [

            "name": "linkedin",
            "source": "rumpel",
            "fields": socialJSON
        ]

        let aboutJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "title")),
            Dictionary.init(dictionaryLiteral: ("name", "body")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let about: Any = [

            "name": "about",
            "source": "rumpel",
            "fields": aboutJSON
        ]

        let emergencyContactJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "first_name")),
            Dictionary.init(dictionaryLiteral: ("name", "last_name")),
            Dictionary.init(dictionaryLiteral: ("name", "mobile")),
            Dictionary.init(dictionaryLiteral: ("name", "relationship")),
            Dictionary.init(dictionaryLiteral: ("name", "private"))
        ]

        let emergencyContact: Any = [

            "name": "emergency_contact",
            "source": "rumpel",
            "fields": emergencyContactJSON
        ]

        let subtables: Array = [

            facebookProfilePhoto,
            personal,
            nick,
            birth,
            gender,
            age,
            primaryEmail,
            alternativeEmail,
            homePhone,
            mobile,
            addressDetails,
            addressGlobal,
            website,
            blog,
            facebook,
            twitter,
            google,
            linkedIn,
            youtube,
            emergencyContact,
            about
        ]

        // create the final json file
        let JSON: Dictionary = [

            "name": "profile",
            "source": "rumpel",
            "fields": fieldsJSON,
            "subTables": subtables
            ] as [String : Any]

        // return the json file
        return JSON
    }

    /**
     Creates the notables JSON file
     
     - returns: Dictionary<String, Any>
     */
    public static func createNotablesTableJSON() -> Dictionary<String, Any> {

        // create the author table fields
        let authorFieldsJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "id")),
            Dictionary.init(dictionaryLiteral: ("name", "name")),
            Dictionary.init(dictionaryLiteral: ("name", "nick")),
            Dictionary.init(dictionaryLiteral: ("name", "phata")),
            Dictionary.init(dictionaryLiteral: ("name", "photo_url"))
        ]

        // create the author table
        let authorTableJSON: Dictionary = [

            "name": "authorv1",
            "source": "rumpel",
            "fields": authorFieldsJSON
            ] as [String : Any]

        // create the notes table
        let notesTable: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "message")),
            Dictionary.init(dictionaryLiteral: ("name", "message")),
            Dictionary.init(dictionaryLiteral: ("name", "kind")),
            Dictionary.init(dictionaryLiteral: ("name", "created_time")),
            Dictionary.init(dictionaryLiteral: ("name", "updated_time")),
            Dictionary.init(dictionaryLiteral: ("name", "public_until")),
            Dictionary.init(dictionaryLiteral: ("name", "shared")),
            Dictionary.init(dictionaryLiteral: ("name", "shared_on"))
        ]

        // create the location table fields
        let locationFieldsJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "latitude")),
            Dictionary.init(dictionaryLiteral: ("name", "longitude")),
            Dictionary.init(dictionaryLiteral: ("name", "accuracy")),
            Dictionary.init(dictionaryLiteral: ("name", "altitude")),
            Dictionary.init(dictionaryLiteral: ("name", "locationv1")),
            Dictionary.init(dictionaryLiteral: ("name", "altitude_accuracy")),
            Dictionary.init(dictionaryLiteral: ("name", "heading")),
            Dictionary.init(dictionaryLiteral: ("name", "speed")),
            Dictionary.init(dictionaryLiteral: ("name", "shared"))
        ]

        // create the location table
        let locationJSON: Dictionary = [

            "name": "locationv1",
            "source": "rumpel",
            "fields": locationFieldsJSON
            ] as [String : Any]

        // create the photos table field
        let photosFieldsJSON: Array = [

            Dictionary.init(dictionaryLiteral: ("name", "link")),
            Dictionary.init(dictionaryLiteral: ("name", "source")),
            Dictionary.init(dictionaryLiteral: ("name", "caption")),
            Dictionary.init(dictionaryLiteral: ("name", "shared"))
        ]

        // create the photos table
        let photosJSON: Dictionary = [

            "name": "photov1",
            "source": "rumpel",
            "fields": photosFieldsJSON
            ] as [String : Any]

        // add the created tables in as subarrays
        let subTablesJSON: Array = [

            authorTableJSON,
            locationJSON,
            photosJSON
        ]

        // create the final json file
        let JSON: Dictionary = [

            "name": "notablesv1",
            "source": "rumpel",
            "fields": notesTable,
            "subTables": subTablesJSON
            ] as [String : Any]

        // return the json file
        return JSON
    }

    public static func createJSONForNotablesV2(note: HATNotesData) -> Dictionary<String, Any> {

        // create the author table fields
        let authorFieldsJSON: Dictionary = [

            "nick": note.data.authorData.nickName,
            "name": note.data.authorData.name,
            "photo_url": note.data.authorData.photoURL,
            "id": note.data.authorData.authorID,
            "phata": note.data.authorData.phata
        ] as [String : Any]

        var latitude = 0.0
        if note.data.locationData.latitude != nil {

            latitude = note.data.locationData.latitude!
        }
        var longitude = 0.0
        if note.data.locationData.longitude != nil {

            longitude = note.data.locationData.longitude!
        }

        // create the location table fields
        let locationFieldsJSON: Dictionary = [

            "altitude": note.data.locationData.altitude,
            "altitude_accuracy": note.data.locationData.altitudeAccuracy,
            "heading": note.data.locationData.heading,
            "latitude": latitude,
            "shared": note.data.locationData.shared,
            "accuracy": note.data.locationData.accuracy,
            "longitude": longitude,
            "speed": note.data.locationData.speed
        ] as [String : Any]

        // create the photos table field
        let photosFieldsJSON: Dictionary = [

            "link": note.data.photoData.link,
            "source": note.data.photoData.source,
            "caption": note.data.photoData.caption,
            "shared": note.data.photoData.shared
        ] as [String : Any]

        var publicUntil = ""
        if note.data.publicUntil != nil {

            publicUntil = HATFormatterHelper.formatDateToISO(date: note.data.publicUntil!)
        }

        // create the final json file
        let JSON: Dictionary = [

            "lastUpdated": (HATFormatterHelper.formatDateToEpoch(date: Date())!),
            "authorv1": authorFieldsJSON,
            "created_time": note.data.createdTime,
            "shared": note.data.shared,
            "shared_on": note.data.sharedOn,
            "photov1": photosFieldsJSON,
            "locationv1": locationFieldsJSON,
            "message": note.data.message,
            "public_until": publicUntil,
            "updated_time": note.data.updatedTime,
            "kind": note.data.kind
            ] as [String : Any]

        // return the json file
        return JSON
    }

    /**
     Creates the json file to update a note
     
     - parameter hatTableStructure: Dictionary<String, Any>
     - returns: Dictionary<String, Any>
     */
    public static func createJSONForPosting(hatTableStructure: Dictionary<String, Any>) -> Dictionary<String, Any> {

        // init array
        var valuesArray: [Dictionary<String, Any>] = []

        // format date in an iso format
        let iso8601String = HATFormatterHelper.formatDateToISO(date: Date())

        // the record json fields
        let recordDictionary: Dictionary = [

            "name": iso8601String
            ] as [String : Any]

        // for each json file in hatTableStructure
        for tableProperty in hatTableStructure {

            // check for the fields
            if tableProperty.key == "fields" {

                // save as a dict in JSON format
                guard let tempDict = tableProperty.value as? JSON else { break }
                // get the array from the dictionary
                let tempArray = tempDict.array

                // for each dictionary in the array
                for dict in tempArray! {

                    // create the message fields
                    let messageFieldDictionary: Dictionary = [

                        "id": Int(dict.dictionary!["id"]!.number!),
                        "name": dict.dictionary!["name"]!.string!
                        ] as [String : Any]

                    // create the message table
                    let messageDictionary: Dictionary = [

                        "field": messageFieldDictionary,
                        "value": ""
                        ] as [String : Any]

                    valuesArray.append(messageDictionary)
                }

                print("fields")
                // find subtables
            } else if tableProperty.key == "subTables" {

                // save as a dict in JSON format
                guard let tempDict = tableProperty.value as? JSON else { break }
                // get the array from the dictionary
                let tempArray = tempDict.array

                // for each dictionary in the array
                for dict in tempArray! {

                    // get the table
                    let fieldsArray = dict["fields"].array!

                    // for each field in the tables
                    for field in fieldsArray {

                        // create the message field
                        let messageFieldDictionary: Dictionary = [

                            "id": Int(field.dictionary!["id"]!.number!),
                            "name": field.dictionary!["name"]!.string!
                            ] as [String : Any]

                        // create the message table
                        let messageDictionary: Dictionary = [

                            "field": messageFieldDictionary,
                            "value": ""
                            ] as [String : Any]

                        valuesArray.append(messageDictionary)
                    }
                }
            }
        }

        // add everything in a dictionary
        let arrayDictionary: Dictionary = [

            "record": recordDictionary,
            "values": valuesArray
            ] as [String : Any]

        // return the dictionary
        return arrayDictionary
    }

    // MARK: - Update JSON file functions

    /**
     Updates the message of the note json file
     
     - parameter file: The json file to update
     - parameter message: The message to add to the note
     
     - returns: JSON
     */
    public static func updateMessageOnJSON(file: JSON, message: String) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "message" {

            jsonFile["values"][itemNumber]["value"] = JSON(message)
        }

        return jsonFile
    }

    /**
     Updates the visibility of the note json file
     
     - parameter file: The json file to update
     - parameter isShared: the boolean value as a string indicating if the note is shared
     
     - returns: JSON
     */
    public static func updateVisibilityOfNoteOnJSON(file: JSON, isShared: Bool) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "shared" {

            jsonFile["values"][itemNumber]["value"] = JSON(String(isShared))
        }

        return jsonFile
    }

    /**
     Updates the kind of the note json file
     
     - parameter file: The json file to update
     - parameter messageKind: the kind of the message. 3 kinds available, note, blog, list
     
     - returns: JSON
     */
    public static func updateKindOfNoteOnJSON(file: JSON, messageKind: String) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "kind" {

            jsonFile["values"][itemNumber]["value"] = JSON(messageKind)
        }

        return jsonFile
    }

    /**
     Updates the updated date of the note json file
     
     - parameter file: The json file to update
     - parameter date: the updated date
     
     - returns: JSON
     */
    public static func updateUpdatedOnDateOfNoteOnJSON(file: JSON) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "updated_time" {

            jsonFile["values"][itemNumber]["value"] = JSON(HATFormatterHelper.formatDateToISO(date: Date()))
        }

        return jsonFile
    }

    /**
     Updates the created date of the note json file if needed
     
     - parameter file: The json file to update
     - parameter date: the created date
     
     - returns: JSON
     */
    public static func updateCreatedOnDateOfNoteOnJSON(file: JSON, date: Date) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where (jsonFile["values"][itemNumber]["field"]["name"] == "created_time" && jsonFile["values"][itemNumber]["value"] == "") {

            jsonFile["values"][itemNumber]["value"] = JSON(HATFormatterHelper.formatDateToISO(date: date))
        }

        return jsonFile
    }

    /**
     Updates the social media that this note is shared in the json file
     
     - parameter file: The json file to update
     - parameter socialString: Coma seperated string indicating the social media that this note will be shared into
     
     - returns: JSON
     */
    public static func updateSharedOnDateOfNoteOnJSON(file: JSON, socialString: String) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "shared_on" {

            jsonFile["values"][itemNumber]["value"] = JSON(socialString)
        }

        return jsonFile
    }

    /**
     Updates the public until date of the note json file
     
     - parameter file: The json file to update
     - parameter parameter date: the shared for duration date
     
     - returns: JSON
     */
    public static func updateSharedForDurationOfNoteOnJSON(file: JSON, date: Date?) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "public_until" {

            jsonFile["values"][itemNumber]["value"] = ""
            
            if let unwrappedDate = date {
                
                if unwrappedDate > Date() {
                    
                    jsonFile["values"][itemNumber]["value"] = JSON(HATFormatterHelper.formatDateToISO(date: unwrappedDate))
                }
            }
        }

        return jsonFile
    }

    /**
     Updates the phata of the note json file
     
     - parameter file: The json file to update
     - parameter phata: The user's phata
     
     - returns: JSON
     */
    public static func updatePhataOfNoteOnJSON(file: JSON, phata: String) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "phata" {

            jsonFile["values"][itemNumber]["value"] = JSON(phata)
        }

        return jsonFile
    }

    /**
     Updates the photo of the note json file
     
     - parameter file: The json file to update
     - parameter photoURL: The link to the uploaded photo
     
     - returns: JSON
     */
    public static func updatePhotosOfNoteOnJSON(file: JSON, photoURL: String) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count where jsonFile["values"][itemNumber]["field"]["name"] == "link" {

            jsonFile["values"][itemNumber]["value"] = JSON(photoURL)
        }

        return jsonFile
    }

    /**
     Updates the photo of the note json file
     
     - parameter file: The json file to update
     - parameter photoURL: The link to the uploaded photo
     
     - returns: JSON
     */
    public static func updateLocationsOfNoteOnJSON(file: JSON, latitude: Double, longitude: Double, accuracy: Double) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count {

            if jsonFile["values"][itemNumber]["field"]["name"] == "latitude" {

                jsonFile["values"][itemNumber]["value"] = JSON(String(latitude))
            } else if jsonFile["values"][itemNumber]["field"]["name"] == "longitude" {

                jsonFile["values"][itemNumber]["value"] = JSON(String(longitude))
            } else if jsonFile["values"][itemNumber]["field"]["name"] == "accuracy" {

                jsonFile["values"][itemNumber]["value"] = JSON(String(accuracy))
            }
        }

        return jsonFile
    }

    /**
     Adds all the info about the note we want to add to the JSON file
     
     - parameter file: The JSON file in a Dictionary<String, Any>
     - returns: Dictionary<String, Any>
     */
    public static func updateNotesJSONFile(file: Dictionary<String, Any>, noteFile: HATNotesData, userDomain: String) -> Dictionary<String, Any> {

        var jsonFile = JSON(file)

        //update message
        jsonFile = HATJSONHelper.updateMessageOnJSON(file: jsonFile, message: noteFile.data.message)
        //update kind
        jsonFile = HATJSONHelper.updateKindOfNoteOnJSON(file: jsonFile, messageKind: noteFile.data.kind)
        //update updated time
        jsonFile = HATJSONHelper.updateUpdatedOnDateOfNoteOnJSON(file: jsonFile)
        //update created time
        jsonFile = HATJSONHelper.updateCreatedOnDateOfNoteOnJSON(file: jsonFile, date: noteFile.data.createdTime)
        //update share duration time
        jsonFile = HATJSONHelper.updateSharedForDurationOfNoteOnJSON(file: jsonFile, date: noteFile.data.publicUntil)
        //update public
        jsonFile = HATJSONHelper.updateVisibilityOfNoteOnJSON(file: jsonFile, isShared: noteFile.data.shared)
        //update share on
        jsonFile = HATJSONHelper.updateSharedOnDateOfNoteOnJSON(file: jsonFile, socialString: noteFile.data.sharedOn)
        //update phata
        jsonFile = HATJSONHelper.updatePhataOfNoteOnJSON(file: jsonFile, phata: userDomain)
        //update image file
        jsonFile = HATJSONHelper.updatePhotosOfNoteOnJSON(file: jsonFile, photoURL: noteFile.data.photoData.link)
        //update location
        if let latitude = noteFile.data.locationData.latitude, let longitude = noteFile.data.locationData.longitude {

            jsonFile = HATJSONHelper.updateLocationsOfNoteOnJSON(file: jsonFile, latitude: latitude, longitude: longitude, accuracy: noteFile.data.locationData.accuracy)
        }

        return jsonFile.dictionaryObject!
    }

    /**
     Adds all the info about the profile we want to add to the JSON file
     
     - parameter file: The JSON file in a Dictionary<String, Any>
     - returns: Dictionary<String, Any>
     */
    public static func updateProfileJSONFile(file: Dictionary<String, Any>, profileFile: HATProfileObject) -> Dictionary<String, Any> {

        var jsonFile = JSON(file)

        // update profile
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.isPrivateTuple)

        // update profile picture
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.facebookProfilePhoto.isPrivateTuple)

        // update name
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.firstNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.lastNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.middleNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.prefferedNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.titleTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.personal.isPrivateTuple)

        // update email addresses
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.primaryEmail.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.primaryEmail.valueTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.alternativeEmail.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.alternativeEmail.valueTuple)

        // update address
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressDetails.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressDetails.numberTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressDetails.postCodeTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressDetails.streetTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressGlobal.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressGlobal.cityTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressGlobal.countyTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.addressGlobal.countryTuple)

        // update phone number
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.homePhone.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.homePhone.numberTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.mobile.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.mobile.numberTuple)

        // update profile info
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.age.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.age.groupTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.gender.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.gender.typeTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.birth.dateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.birth.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.nick.nameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.nick.isPrivateTuple)

        // update emergency contact
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.emergencyContact.firstNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.emergencyContact.lastNameTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.emergencyContact.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.emergencyContact.mobileTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.emergencyContact.relationshipTuple)

        // update social networks and websites
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.facebook.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.facebook.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.twitter.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.twitter.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.linkedIn.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.linkedIn.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.google.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.google.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.blog.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.blog.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.website.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.website.linkTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.youtube.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.youtube.linkTuple)

        // update about info
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.about.isPrivateTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.about.bodyTuple)
        jsonFile = HATJSONHelper.updateFieldOnJSON(jsonFile, field: profileFile.data.about.titleTuple)

        return jsonFile.dictionaryObject!
    }

    /**
     Updates the photo of the note json file
     
     - parameter file: The json file to update
     - parameter firstName: The first name entered in profile
     
     - returns: JSON
     */
    public static func updateFieldOnJSON(_ file: JSON, field: (String, Int)) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count {

            if jsonFile["values"][itemNumber]["field"]["id"].stringValue == String(describing: field.1) {

                jsonFile["values"][itemNumber]["value"] = JSON(field.0)
            }
        }

        return jsonFile
    }

    /**
     Updates the photo of the note json file
     
     - parameter file: The json file to update
     - parameter firstName: The first name entered in profile
     
     - returns: JSON
     */
    public static func updateFieldOnJSON(_ file: JSON, field: (Date?, Int)) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count {

            if jsonFile["values"][itemNumber]["field"]["id"].stringValue == String(describing: field.1) {

                if field.0 != nil {

                    jsonFile["values"][itemNumber]["value"] = JSON(HATFormatterHelper.formatDateToISO(date: field.0!))
                }
            }
        }

        return jsonFile
    }

    /**
     Updates the photo of the note json file
     
     - parameter file: The json file to update
     - parameter firstName: The first name entered in profile
     
     - returns: JSON
     */
    public static func updateFieldOnJSON(_ file: JSON, field: (Bool, Int)) -> JSON {

        var jsonFile = file

        for itemNumber in 0...jsonFile["values"].count {

            if jsonFile["values"][itemNumber]["field"]["id"].stringValue == String(describing: field.1) {

                jsonFile["values"][itemNumber]["value"] = JSON(String(describing: field.0))
            }
        }

        return jsonFile
    }

    // MARK: - Create JSON for file uploading

    /**
     Creates the json file to purchase a HAT
     
     - parameter fileName: The file name of the photo
     - parameter tags: The tags attached to the photo
     - returns: A Dictionary <String, Any>
     */
    static func createFileUploadingJSONFrom(fileName: String, tags: [String]) -> Dictionary <String, Any> {

        // the final JSON file to be returned
        return [

            "name": fileName,
            "source": "iPhone",
            "tags": tags
            ] as [String : Any]
    }

    // MARK: - Create JSON for nationality uploading

    /**
     Creates the json file to upload the nationality to  HAT
     
     - parameter nationality: The HATNationalityObject with all the necessary values
     - returns: A Dictionary <String, String>
     */
    static func createFileUploadingJSONFrom(nationality: HATNationalityObject) -> Dictionary <String, String> {

        // the final JSON file to be returned
        return [

            "nationality": nationality.nationality,
            "passportHeld": nationality.passportHeld,
            "passportNumber": nationality.passportNumber,
            "placeOfBirthe": nationality.placeOfBirth,
            "language": nationality.language
            ] as [String : String]
    }
}
