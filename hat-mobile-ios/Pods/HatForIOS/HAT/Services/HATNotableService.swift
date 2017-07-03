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

import Alamofire
import SwiftyJSON

// MARK: Class

/// A class about the methods concerning the Notables service
public class HATNotablesService: NSObject {

    // MARK: - Get Notes

    /**
     Checks if notables table exists
     
     - parameter authToken: The auth token from hat
     */
    public class func fetchNotables(userDomain: String, authToken: String, structure: Dictionary<String, Any>, parameters: Dictionary<String, String>, success: @escaping (_ array: [JSON], String?) -> Void, failure: @escaping (HATTableError) -> Void ) {

        HATAccountService.checkHatTableExists(userDomain: userDomain, tableName: "notablesv1",
                                              sourceName: "rumpel",
                                              authToken: authToken,
                                              successCallback: getNotes(userDomain: userDomain, token: authToken, parameters: parameters, success: success),
                                              errorCallback: failure)
    }

    /**
     Gets the notes of the user from the HAT
     
     - parameter token: The user's token
     - parameter tableID: The table id of the notes
     */
    private class func getNotes(userDomain: String, token: String, parameters: Dictionary<String, String>, success: @escaping (_ array: [JSON], String?) -> Void) -> (_ tableID: NSNumber, _ token: String?) -> Void {

        return { (tableID: NSNumber, returnedToken: String?) -> Void in

            HATAccountService.getHatTableValues(token: token, userDomain: userDomain, tableID: tableID, parameters: parameters, successCallback: success, errorCallback: showNotablesFetchError)
        }
    }

    /**
     Shows alert that the notes couldn't be fetched
     */
    public class func showNotablesFetchError(error: HATTableError) {

        // alert magic
    }

    // MARK: - Delete notes

    /**
     Deletes a note from the hat
     
     - parameter id: the id of the note to delete
     - parameter tkn: the user's token as a string
     */
    public class func deleteNote(recordID: Int, tkn: String, userDomain: String) {

        HATAccountService.deleteHatRecord(userDomain: userDomain, token: tkn, recordId: recordID, success: { _ in }, failed: { (_) -> Void in return })
    }

    // MARK: - Post note

    /**
     Posts the note to the hat
     
     - parameter token: The token returned from the hat
     - parameter json: The json file as a Dictionary<String, Any>
     */
    public class func postNote(userDomain: String, userToken: String, note: HATNotesData, successCallBack: @escaping () -> Void) {

        func posting(resultJSON: Dictionary<String, Any>, token: String?) {

            // create the headers
            let headers = ["Accept": ContentType.JSON,
                           "Content-Type": ContentType.JSON,
                           "X-Auth-Token": userToken]

            // create JSON file for posting with default values
            let hatDataStructure = HATJSONHelper.createJSONForPosting(hatTableStructure: resultJSON)
            // update JSON file with the values needed
            let hatData = HATJSONHelper.updateNotesJSONFile(file: hatDataStructure, noteFile: note, userDomain: userDomain)

            // make async request
            HATNetworkHelper.asynchronousRequest("https://" + userDomain + "/data/record/values", method: HTTPMethod.post, encoding: Alamofire.JSONEncoding.default, contentType: ContentType.JSON, parameters: hatData, headers: headers, completion: { (response: HATNetworkHelper.ResultType) -> Void in

                // handle result
                switch response {

                case .isSuccess(let isSuccess, _, _, _):

                    if isSuccess {

                        // reload table
                        successCallBack()

                        HATAccountService.triggerHatUpdate(userDomain: userDomain, completion: { () })
                    }

                case .error(let error, _):

                    print("error res: \(error)")
                }
            })
        }

        func errorCall(error: HATTableError) {

        }

        HATAccountService.checkHatTableExistsForUploading(userDomain: userDomain, tableName: "notablesv1", sourceName: "rumpel", authToken: userToken, successCallback: posting, errorCallback: errorCall)
    }

    // MARK: - Remove duplicates

    /**
     Removes duplicates from an array of NotesData and returns the corresponding objects in an array
     
     - parameter array: The NotesData array
     - returns: An array of NotesData
     */
    public class func removeDuplicatesFrom(array: [HATNotesData]) -> [HATNotesData] {

        // the array to return
        var arrayToReturn: [HATNotesData] = []

        // go through each note object in the array
        for note in array {

            // check if the arrayToReturn it contains that value and if not add it
            let result = arrayToReturn.contains(where: {(note2: HATNotesData) -> Bool in

                if (note.data.createdTime == note2.data.createdTime) && (note.data.message == note2.data.message) {

                    if (note.lastUpdated < note2.lastUpdated) || (note.noteID == note2.noteID) {

                        return true
                    }
                }

                return false
            })

            if !result {

                arrayToReturn.append(note)
            }
        }

        for (outterIndex, note) in arrayToReturn.enumerated().reversed() {

            for (innerIndex, innerNote) in arrayToReturn.enumerated().reversed() where outterIndex != innerIndex {

                if innerNote.data.createdTime == note.data.createdTime && innerNote.lastUpdated != note.lastUpdated {
                    
                    if innerNote.lastUpdated > note.lastUpdated && outterIndex < arrayToReturn.count {
                        
                        arrayToReturn.remove(at: outterIndex)
                    } else if innerNote.lastUpdated <= note.lastUpdated && innerIndex < arrayToReturn.count {
                        
                        arrayToReturn.remove(at: innerIndex)
                    }
                }
            }
        }

        return arrayToReturn
    }

    // MARK: - Sort notables

    /**
     Sorts notes based on updated time
     
     - parameter notes: The NotesData array
     - returns: An array of NotesData
     */
    public class func sortNotables(notes: [HATNotesData]) -> [HATNotesData] {

        return notes.sorted { $0.lastUpdated > $1.lastUpdated }
    }
}
