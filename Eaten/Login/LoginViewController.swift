//
//  LoginViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 26/4/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        emailField.text = ""
        passwordField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            Task {
                if let user = auth.currentUser {
                    let currentUser = User()
                    currentUser.id = user.uid
                    self.databaseController?.currentUser = currentUser
                    
                    await (self.databaseController as! FirebaseController).fetchUserDetails()
                    (self.databaseController as! FirebaseController).setupUserReviewListener()
                    
                    let tabBarController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController")
                    self.navigationController?.pushViewController(tabBarController!, animated: false)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        var isValid = true
        
        guard let email = emailField.text?.lowercased(), isValidEmail(email) else {
            displayMessage(title: "Empty Email", message: "Please enter a valid email")
            return
        }
        
        guard let password = passwordField.text else {
            displayMessage(title: "Empty Password", message: "Please enter a password")
            return
        }
        
        let _ = databaseController?.signIn(email: email, password: password)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK - Miscellaneous
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
