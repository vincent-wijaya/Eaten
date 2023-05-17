//
//  CreateAccountViewController.swift
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            (self.databaseController as! FirebaseController).currentUser = user
            
            if user != nil {
                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func loginAccount(_ sender: Any) {
        guard let email = emailField.text, isValidEmail(email) else {
            return
        }
        
        guard let _ = passwordField.text else {
            return
        }
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailField.text, isValidEmail(email) else {
            return
        }
        
        guard let password = passwordField.text, isValidPassword(password) else {
            return
        }
        
        let result = databaseController!.createAccount(email: email, password: password)
        
//        if result {
//            performSegue(withIdentifier: "loggedInSegue", sender: self)
//        }
    }
    
    /**
            From https://stackoverflow.com/a/25471164
     */
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
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
