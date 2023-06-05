//
//  AddFriendViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 2/6/2023.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    /// Send a user a friend request
    /// - Parameter sender: button
    @IBAction func sendFriendRequest(_ sender: Any) {
        guard let username = usernameField.text, username.count > 0 else {
            displayMessageWithDismiss(title: "Missing username", message: "Please enter a username", viewController: self)
            return
        }
        
        // Check if username is current user's own username
        if username == databaseController?.currentUser?.username {
            displayMessageWithDismiss(title: "Cannot send friend request", message: "You cannot send yourself a friend request", viewController: self)
            return
        }
        
        Task {
            // Check if user exists
            if let userId = await databaseController?.checkUsernameExists(username: username) {
                // User exists
                
                // Check if current user has sent this friend request before
                databaseController?.checkSentRequestExists(otherUserId: userId) { exists in
                    guard let exists = exists else {
                        print("Error checking if friend request exists")
                        return
                    }
                    
                    if exists {
                        // Current user has sent the other user a friend request before, therefore this new request is canceled
                        displayMessageWithDismiss(title: "Friend request already sent", message: "You have already sent this user a friend request", viewController: self)
                        return
                    }
                }
                
                databaseController?.sendFriendRequest(otherUserId: userId)
                displayMessageWithDismiss(title: "Friend request sent", message: "Friend request to \(username) successfully sent", viewController: self)
            }
            else {
                displayMessageWithDismiss(title: "User not found", message: "User with username not found", viewController: self)
                return
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
