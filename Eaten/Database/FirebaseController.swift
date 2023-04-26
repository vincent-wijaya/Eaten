//
//  FirebaseController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var user: User?
    var reviewList: [Review]
    
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var reviewsRef: CollectionReference?
    
    var currentUser: FirebaseAuth.User?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        reviewList = [Review]()
    }
    
    func cleanUp() {
        // Do nothing
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
//        if listener.listenerType == .user || listener.listenerType == .all {
//            listener.onUserChange(change: .update, user: <#T##User#>)
//        }
//        if listener.listenerType == .review || listener.listenerType == .all {
//            listener.onReviewChange(change: .update, reviewList: <#T##[Review]#>)
//        }
    }
    
    func setupUserListener() {
        usersRef = database.collection("users")
        
        guard let userId = currentUser?.uid else {
            return
        }
    }
    
    func setupReviewListener() {
        reviewsRef = database.collection("reviews")
        
        
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String) -> Bool {
        var result = false
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error)
                return
            }
            
            if let user = authResult?.user {
                self.currentUser = user
                
                
            }
        }
        
        return result
    }
    
    func signIn(email: String, password: String) -> Bool {
        <#code#>
    }
    
    func signOut() {
        <#code#>
    }
}
