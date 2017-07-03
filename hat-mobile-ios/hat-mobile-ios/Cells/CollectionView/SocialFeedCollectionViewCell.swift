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

/// The social feed collection view cell class
internal class SocialFeedCollectionViewCell: UICollectionViewCell, UserCredentialsProtocol {
    
    // MARK: - IBOutlets
    
    /// An IBOutlet for handling the profile image of the cell
    @IBOutlet private weak var profileImage: UIImageView!
    /// An IBOutlet for handling the social network's image of the cell
    @IBOutlet private weak var socialNetworkImage: UIImageView!
    
    /// An IBOutlet for handling the profile name label of the cell
    @IBOutlet private weak var profileNameLabel: UILabel!
    /// An IBOutlet for handling the the post details label of the cell
    @IBOutlet private weak var postInfoLabel: UILabel!
    /// An IBOutlet for handling the the post type, tweet, status, video etc of the cell
    @IBOutlet private weak var postTypeLabel: UILabel!
    
    /// An IBOutlet for handling the message of the post of the cell
    @IBOutlet private weak var messageTextView: UITextView!
    
    // MARK: - Set up cell
    
    /**
     Sets up a social feed cell according to our needs
     
     - parameter cell: The cell to set up
     - parameter indexPath: The index path of the currect cell
     - parameter posts: The post to display in this cell
     
     - returns: A formatted social feed cell of type SocialFeedCollectionViewCell
     */
    class func setUpCell(cell: SocialFeedCollectionViewCell, indexPath: IndexPath, posts: Any) -> SocialFeedCollectionViewCell {
        
        // Check if the post to show is from facebook
        if posts is HATFacebookSocialFeedObject {
            
            // convert the post to FacebookSocialFeedObject
            guard let post = posts as? HATFacebookSocialFeedObject else {
                
                return cell
            }
            
            if let date = post.data.posts.updatedTime {
                
                cell.postInfoLabel.text = "Posted on " + FormatterHelper.formatDateStringToUsersDefinedDate(date: date, dateStyle: .short, timeStyle: .short) + ", privacy set to " + post.data.posts.privacy.value.replacingOccurrences(of: "_", with: " ")
            }
            
            // If the post is a photo, download it to the imageview
            if post.data.posts.type == "photo" {
                
                if let url = URL(string: post.data.posts.fullPicture) {
                    
                    cell.socialNetworkImage.downloadedFrom(url: url, userToken: userToken, progressUpdater: nil, completion: nil)
                }
            }
            
            // assign the values
            cell.profileNameLabel.text = post.data.posts.from.name
            cell.postTypeLabel.text = post.data.posts.type
            cell.messageTextView = self.constructMessageLabelFrom(data: post.data.posts, for: cell.messageTextView)
            
            cell.messageTextView.sizeToFit()
            
            return cell
        // else if the post is from twitter
        } else {
            
            // convert the post to TwitterSocialFeedObject
            guard let post = posts as? HATTwitterSocialFeedObject else {
                
                return cell
            }
            
            // assign the post values to cell values
            cell.profileNameLabel.text = post.data.tweets.user.name
            cell.messageTextView.text = post.data.tweets.text
            cell.postTypeLabel.text = "tweet"
            
            // if the post has a date create the info string label
            if post.data.tweets.createdAt != nil {
                
                cell.postInfoLabel.text = "Posted on " + FormatterHelper.formatDateStringToUsersDefinedDate(date: post.data.tweets.createdAt!, dateStyle: .short, timeStyle: .short)
            }
            
            // assign the twitter image as profile image
            cell.profileImage.image = UIImage(named: Constants.ImageNames.twitterImage)
                        
            return cell
        }
    }
    
    // MARK: - Construct message label
    
    /**
     Sets up a text view according to the data we have
     
     - parameter data: A FacebookDataPostsSocialFeedObject object that contains the data we need
     - parameter textView: The textview to setup
     
     - returns: An already set up textview
     */
    private class func constructMessageLabelFrom(data: HATFacebookDataPostsSocialFeedObject, for textView: UITextView) -> UITextView {
        
        textView.text = data.message
        
        if data.type == "link" {
            
            textView.attributedText = NSAttributedString(string: data.description + "\n" + data.link)
        }
        
        // if nothing of above try to story and description
        if textView.text == "" {
            
            textView.text = data.story
        }
        
        if textView.text == "" {
            
            textView.text = data.description
        }
        
        return textView
    }
    
    // MARK: Set image
    
    /**
     Sets an image to profileImage UIImageView
     
     - parameter image: The image to show in the profileImage UIImageView
     */
    func setCellImage(image: UIImage?) {
        
        self.profileImage.image = image
    }
}
