//
//  CreateAccountViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 26/4/2023.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    var handle: AuthStateDidChangeListenerHandle?
    

    @IBOutlet weak var givenNameField: UITextField!
    
    @IBOutlet weak var familyNameField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let USERNAME_CHARACTER_LIMIT = 15
        
        // Given name is optional
        guard let givenName = givenNameField.text else {
            return
        }
        
        // Validate family name input
        guard let familyName = familyNameField.text, familyName.count > 0 else {
            displayMessageWithDismiss(title: "Missing family name", message: "Please enter your family name", viewController: self)
            return
        }
        
        // Validate username input
        guard let username = usernameField.text, username.count > 0 else {
            displayMessageWithDismiss(title: "Missing username", message: "Please enter a username", viewController: self)
            return
        }
        
        guard username.count <= USERNAME_CHARACTER_LIMIT else {
            displayMessageWithDismiss(title: "Username too long", message: "Please enter a username with \(USERNAME_CHARACTER_LIMIT) characters or less", viewController: self)
            return
        }
        
        Task {
            if let _ = await databaseController?.checkUsernameExists(username: username) {
                displayMessageWithDismiss(title: "Username taken", message: "Please enter a different username", viewController: self)
            }
        }
        
        // Validate email input
        guard let email = emailField.text?.lowercased(), email.count > 0, isValidEmail(email) else {
            displayMessageWithDismiss(title: "Missing email", message: "Please enter your email address", viewController: self)
            return
        }
        
        // Check if email is associated to an account
        Task {
            if let _ = await databaseController?.checkEmailExists(email: email) {
                displayMessageWithDismiss(title: "Account with the email exists", message: "Account with the email already exists.", viewController: self)
                return
            }
        }
        
        // Validate password
        guard let password = passwordField.text else {
            displayMessageWithDismiss(title: "Empty Password", message: "Please enter a password", viewController: self)
            return
        }
        
        guard let confirmPassword = confirmPasswordField.text else {
            displayMessageWithDismiss(title: "Empty Password Confirmation", message: "Please confirm your password", viewController: self)
            return
        }
        
        guard password == confirmPassword else {
            displayMessageWithDismiss(title: "Passwords do not match", message: "Confirmation password does not match your password", viewController: self)
            return
        }
        
        
        let success = databaseController!.createAccount(givenName: givenName, familyName: familyName, username: username, email: email, password: password)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { [self] auth, user in
            
            if user != nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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
