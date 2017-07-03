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
import SafariServices
import SwiftyJSON

// MARK: Notables ViewController

/// The notables view controller
internal class NotablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserCredentialsProtocol {
    
    // MARK: - Variables
    
    /// a cached array of the notes to display
    private var cachedNotesArray: [HATNotesData] = []
    /// an array of the notes to work on without touching the cachedNotesArray
    private var notesArray: [HATNotesData] = []
    
    /// the index of the selected note
    private var selectedIndex: Int?
    
    /// the kind of the note to create
    private var kind: String = ""
    /// the notables fetch items limit
    private var notablesFetchLimit: String = "50"
    /// the notables fetch end date
    private var notablesFetchEndDate: String?
    
    /// the paramaters to make the request for fetching the notes
    private var parameters: Dictionary<String, String> = ["starttime": "0",
                                                          "limit": "50"]
    
    /// a dark view pop up to hide the background
    private var authorise: AuthoriseUserViewController?

    // MARK: - IBOutlets

    /// An IBOutlet for handling the table view
    @IBOutlet private weak var tableView: UITableView!
    
    /// An IBOutlet for handling the create new notes green view at the bottom of the screen
    @IBOutlet private weak var createNewNoteView: UIView!
    
    /// An IBOutlet for handling the create new note button
    @IBOutlet private weak var createNewNoteButton: UIButton!
    /// An IBOutlet for handling the info label when table view is empty or an error has occured
    @IBOutlet private weak var eptyTableInfoLabel: UILabel!
    
    /// An IBOutlet for handling the retry connecting button when an error has occured
    @IBOutlet private weak var retryConnectingButton: UIButton!

    // MARK: - IBActions
    
    /**
     Try to reconnect to get notes
     
     - parameter sender: The object that calls this function
     */
    @IBAction func refreshTableButtonAction(_ sender: Any) {
        
        // hide retry connection button
        self.retryConnectingButton.isHidden = true
        
        // fetch notes
        self.connectToServerToGetNotes(result: nil)
        
        // if something wrong show error
        let failCallBack = { [weak self] () -> Void in
            
            self?.createClassicOKAlertWith(
                alertMessage: "There was an error enabling data plugs, please go to web rumpel to enable the data plugs",
                alertTitle: "Data Plug Error",
                okTitle: "OK",
                proceedCompletion: {})
        }
        
        // check if data plug is ready
        HATDataPlugsService.ensureOffersReady(succesfulCallBack: { _ in }, tokenErrorCallback: failCallBack, failCallBack: {error in
        
            switch error {
                
            case .offerClaimed:
                
                break
            default:
                
                failCallBack()
            }
        })
    }
    
    /**
     Go to New note and create a note
     
     - parameter sender: The object that calls this function
     */
    @IBAction func newNoteButton(_ sender: Any) {
        
        kind = "note"
        self.performSegue(withIdentifier: Constants.Segue.optionsSegue, sender: self)
    }
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // view controller title
        self.title = "Notes"
        
        // keep the green bar at the top
        self.view.bringSubview(toFront: createNewNoteView)
        
        // register observers for a notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: Constants.NotificationNames.reloadTable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideTable), name: NSNotification.Name(rawValue: Constants.NotificationNames.networkMessage), object: nil)
                
        self.createNewNoteButton.addBorderToButton(width: 0.5, color: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        func success(token: String?) {
            
            self.authorise = nil
            
            // fetch notes
            self.connectToServerToGetNotes(result: nil)
        }
        
        HATDataPlugsService.ensureOffersReady(
            succesfulCallBack: success,
            tokenErrorCallback: {
        
                print("error")
            },
            failCallBack: {error in
            
                print(error)
            }
        )

        // get notes
        HATAccountService.checkIfTokenExpired(
            token: userToken,
            expiredCallBack: self.unauthorisedResponse(proceedCompletion: connectToServerToGetNotes),
            tokenValidCallBack: success,
            errorCallBack: self.createClassicOKAlertWith)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Show Notes
    
    /**
     Shows the received notes
     
     - parameter notification: The notification object
     */
    private func showReceivedNotesFrom(array: [JSON]) {
        
        DispatchQueue.global().async { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                // for each dictionary parse it and add it to the array
                for dict in array {
                    
                    weakSelf.notesArray.append(HATNotesData.init(dict: dict.dictionary!))
                }
                
                DispatchQueue.main.async {
                    
                    // update UI
                    weakSelf.updateUI()
                }
            }
        }
    }
    
    /**
     Refreshes the table per new data request
     
     - parameter notification: The notification object
     */
    @objc
    private func refreshData(notification: Notification) {
        
        DispatchQueue.main.async { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                if weakSelf.selectedIndex != nil {
                    
                    weakSelf.cachedNotesArray.remove(at: weakSelf.selectedIndex!)
                    weakSelf.selectedIndex = nil
                }
            }
        }
    }
    
    /**
     Shows notables fetched from HAT
     
     - parameter array: The fetched notables
     */
    private func showNotables(array: [JSON], renewedUserToken: String?) {
        
        if self.isViewLoaded && (self.view.window != nil) {
            
            DispatchQueue.global().async { [weak self] () -> Void in
                
                if let weakSelf = self {
                    
                    if array.count >= Int(weakSelf.notablesFetchLimit)! {
                        
                        // increase limit
                        weakSelf.notablesFetchLimit = "500"
                        
                        // init object from array
                        let object = HATNotesData(dict: (array.last?.dictionaryValue)!)
                        
                        // set unix date
                        weakSelf.notablesFetchEndDate = HATFormatterHelper.formatDateToEpoch(date: object.lastUpdated)
                        
                        // change parameters
                        weakSelf.parameters = ["starttime": "0",
                                           "endtime": weakSelf.notablesFetchEndDate!,
                                           "limit": weakSelf.notablesFetchLimit]
                        
                        // fetch notes
                        HATNotablesService.fetchNotables(userDomain: weakSelf.userDomain, authToken: weakSelf.userToken, structure: HATJSONHelper.createNotablesTableJSON(), parameters: weakSelf.parameters, success: weakSelf.showNotables, failure: { _ in })
                        
                    } else {
                        
                        // revert parameters to initial values
                        weakSelf.notablesFetchEndDate = nil
                        weakSelf.parameters = ["starttime": "0",
                                           "limit": weakSelf.notablesFetchLimit]
                    }
                    
                    weakSelf.showReceivedNotesFrom(array: array)
                    
                    // refresh user token
                    _ = KeychainHelper.setKeychainValue(key: Constants.Keychain.userToken, value: renewedUserToken)
                }
            }
        }
    }

    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell from the reusable id
        let controller = NotablesTableViewCell()
        controller.notesDelegate = self
        
        if self.cachedNotesArray[indexPath.row].data.photoData.link != "" {
            
            if let tempCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.cellDataWithImage, for: indexPath) as? NotablesTableViewCell {
                
                return controller.setUpCell(tempCell, note: self.cachedNotesArray[indexPath.row], indexPath: indexPath)
            }
        } else {
            
            if let tempCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.cellData, for: indexPath) as? NotablesTableViewCell {
                
                return controller.setUpCell(tempCell, note: self.cachedNotesArray[indexPath.row], indexPath: indexPath)
            }
        }
        
        // return cell
        return tableView.dequeueReusableCell(withIdentifier: Constants.CellReuseIDs.cellDataWithImage, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return number of notes
        return self.cachedNotesArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // enable swipe to delete
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            func proceedCompletion(result: String?) {
                
                func success(token: String?) {
                    
                    var unwrappedToken = ""
                    if token == nil {
                        
                        unwrappedToken = userToken
                    } else {
                        
                        unwrappedToken = token!
                    }
                    HATNotablesService.deleteNote(recordID: self.cachedNotesArray[indexPath.row].noteID, tkn: unwrappedToken, userDomain: userDomain)
                    self.cachedNotesArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.updateUI()
                    
                    self.authorise = nil
                }
                
                // delete data from hat and remove from table
                HATAccountService.checkIfTokenExpired(
                    token: userToken,
                    expiredCallBack: self.unauthorisedResponse(proceedCompletion: proceedCompletion),
                    tokenValidCallBack: success,
                    errorCallBack: self.createClassicOKAlertWith)
            }
            
            // if it is shared show message else delete the row
            if self.cachedNotesArray[indexPath.row].data.shared {
                
                self.createClassicAlertWith(
                    alertMessage: "Deleting a note that has already been shared will not delete it at the destination. \n\nTo remove a note from the external site, first make it private. You may then choose to delete it.",
                    alertTitle: "",
                    cancelTitle: "Cancel",
                    proceedTitle: "Proceed",
                    proceedCompletion: { proceedCompletion(result: nil) },
                    cancelCompletion: {})
            } else {
                
                proceedCompletion(result: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.cachedNotesArray[indexPath.row].data.photoData.link != "" {
            
            return 235
        }
        
        return 139
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedIndex = indexPath.row
    }
    
    // MARK: - Unauthorised response
    
    func unauthorisedResponse(proceedCompletion: @escaping (String?) -> Void) -> (Void) -> Void {
        
        return {
            
            if self.authorise == nil {
                
                self.authorise = AuthoriseUserViewController()
                self.authorise!.view.frame = CGRect(x: self.view.center.x - 50, y: self.view.center.y - 20, width: 100, height: 40)
                self.authorise!.view.layer.cornerRadius = 15
                self.authorise!.completionFunc = proceedCompletion
                
                // add the page view controller to self
                self.addChildViewController(self.authorise!)
                self.view.addSubview(self.authorise!.view)
                self.authorise!.didMove(toParentViewController: self)
            }
        }
    }
    
    // MARK: - Network functions
    
    /**
     Connects to the server to get the notes
     */
    private func connectToServerToGetNotes(result: String?) {
        
        if userToken == "" {
            
            if let loginPageView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                
                self.navigationController?.pushViewController(loginPageView, animated: false)
            }
        } else {
            
            self.showEmptyTableLabelWith(message: "Accessing your HAT...")
            
            HATNotablesService.fetchNotables(userDomain: userDomain, authToken: userToken, structure: HATJSONHelper.createNotablesTableJSON(), parameters: self.parameters, success: self.showNotables, failure: {[weak self] error in
                
                switch error {
                    
                case .generalError(_, let statusCode, _) :
                    
                    if statusCode != nil && self != nil {
                        
                        if statusCode != 404 && statusCode != 401 {
                            
                            self!.showEmptyTableLabelWith(message: "There was an error fetching notes. Please try again later")
                        }
                        self!.connectToServerToGetNotes(result: nil)
                    }
                    
                case .tableDoesNotExist:
                    
                    if self != nil {
                        
                        HATAccountService.createHatTable(userDomain: self!.userDomain, token: self!.userToken, notablesTableStructure: HATJSONHelper.createNotablesTableJSON(), failed: {(createTableError: HATTableError) -> Void in
                            
                            _ = CrashLoggerHelper.hatTableErrorLog(error: createTableError)
                        })()
                    }
                    
                default:
                    
                    _ = CrashLoggerHelper.hatTableErrorLog(error: error)
                }
            })
        }
    }
    
    // MARK: - Update notes data
    
    func updateNote(_ note: HATNotesData, at index: Int) {
        
        self.cachedNotesArray[index] = note
    }
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is ShareOptionsViewController {
            
            weak var destinationVC = segue.destination as? ShareOptionsViewController

            if segue.identifier == Constants.Segue.editNoteSegue || segue.identifier == Constants.Segue.editNoteSegueWithImage {
                
                if let senderAsCell = sender as? UITableViewCell {
                    
                    let cellIndexPath = self.tableView.indexPath(for: senderAsCell)
                    destinationVC?.receivedNote = self.cachedNotesArray[(cellIndexPath?.row)!]
                    destinationVC?.isEditingExistingNote = true
                    
                    if let cell = self.tableView.cellForRow(at: cellIndexPath!) as? NotablesTableViewCell {
                        
                        if cell.fullSizeImage != nil {
                            
                            destinationVC?.selectedImage = cell.fullSizeImage
                        }
                    }
                }
            } else {
                
                destinationVC?.kind = self.kind
            }
        }
    }
    
    // MARK: - Update UI
    
    /**
     Hides table and shows a label with a message
     */
    @objc
    private func hideTable(_ notif: Notification) {
        
        guard let message = notif.object as? String else {
            
            self.showEmptyTableLabelWith(message: "There was an unknown error, please try again later.")
            return
        }
        self.showEmptyTableLabelWith(message: message)
    }
    
    /**
     Hides table and shows a label with the predifined label
     
     - parameter message: The message to show on the label
     */
    private func showEmptyTableLabelWith(message: String) {
        
        DispatchQueue.main.async { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                if weakSelf.cachedNotesArray.isEmpty {
                    
                    var stringMessage = message
                    
                    if stringMessage == "The Internet connection appears to be offline." {
                        
                        weakSelf.retryConnectingButton.isHidden = false
                        stringMessage = "No Internet connection. Please retry"
                    } else {
                        
                        weakSelf.retryConnectingButton.isHidden = true
                    }
                    
                    weakSelf.eptyTableInfoLabel.isHidden = false
                    
                    weakSelf.eptyTableInfoLabel.text = stringMessage
                    
                    weakSelf.tableView.isHidden = true
                }
            }
        }
    }
    
    /**
     Updates the UI elements according the messages received from the HAT
     */
    private func updateUI() {
        
        DispatchQueue.main.async { [weak self] () -> Void in
            
            if let weakSelf = self {
                
                if !weakSelf.notesArray.isEmpty {
                    
                    weakSelf.eptyTableInfoLabel.isHidden = true
                    
                    weakSelf.tableView.isHidden = false
                    
                    var temp = weakSelf.cachedNotesArray
                    
                    for note in weakSelf.notesArray {
                        
                        temp.append(note)
                    }
                    
                    weakSelf.cachedNotesArray.removeAll()
                    
                    temp = HATNotablesService.removeDuplicatesFrom(array: temp)
                    
                    weakSelf.cachedNotesArray = HATNotablesService.sortNotables(notes: temp)
                    
                    weakSelf.notesArray.removeAll()
                    
                    // reload table
                    weakSelf.tableView.reloadData()
                    
                } else if weakSelf.notesArray.isEmpty {
                    
                    weakSelf.showEmptyTableLabelWith(message: "No notables. Keep your words on your HAT. Create your first notable!")
                }
            }
        }
    }
}
