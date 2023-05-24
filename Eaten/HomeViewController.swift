//
//  HomeViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 11/5/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { [self] auth, user in
//            let strongSelf = self
//            
//            if let user = auth.currentUser {
//                let currentUser = User()
//                currentUser.id = user.uid
//                strongSelf.databaseController?.currentUser = currentUser
//            }
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
