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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        print("Tapped Create Account")
        
        guard let givenName = givenNameField.text else {
            return
        }
        
        guard let familyName = familyNameField.text else {
            
            return
        }
        
        guard let username = usernameField.text else {
            return
        }
        
        guard let email = emailField.text else {
            return
        }
        
        guard let password = passwordField.text, password == confirmPasswordField.text else {
            return
        }
        
        let result = databaseController!.createAccount(givenName: givenName, familyName: familyName, username: username, email: email, password: password)
    }

    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { [self] auth, user in
            
            self.navigationController?.popViewController(animated: true)
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
