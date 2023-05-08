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
    
    var currentUser: Firebase.User?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        reviewList = [Review]()
        
        usersRef = database.collection("users")
        reviewsRef = database.collection("reviews")
    }
    
    func cleanUp() {
        // Do nothing
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .user || listener.listenerType == .all {
//            listener.onUserChange(change: .update, user: user)
        }
        if listener.listenerType == .reviews || listener.listenerType == .all {
            listener.onReviewChange(change: .update, reviewList: reviewList)
        }
    }
    
    func setupUserListener() {
        guard let userId = currentUser?.uid else {
            return
        }
        
        usersRef?.document(userId).addSnapshotListener { (documentSnapshot, error) in
            
            if error != nil {
                print("Error encountered retrieving user: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let userSnapshot = documentSnapshot else {
                print("Error fetching users: \(String(describing: error))")
                return
            }
            
            self.parseUserSnapshot(snapshot: userSnapshot)
            
        }
    }
    
    func parseUserSnapshot(snapshot: DocumentSnapshot) {
        var parsedUser = User()
//        user = User()
        
        guard let data = snapshot.data(),
              let givenName = data["givenName"] as? String,
              let familyName = data["familyName"] as? String,
              let username = data["username"] as? String,
              let email = data["email"] as? String else {
            return
        }
        
        parsedUser.givenName = givenName
        parsedUser.familyName = familyName
        parsedUser.username = username
        parsedUser.email = email
        
        user = parsedUser
    }
    
    func setupReviewListener() {
        guard let authorId = currentUser?.uid else {
            print("uid doesn't exist for some reason")
            return
        }
        
        reviewsRef?.whereField("authorId", isEqualTo: authorId).addSnapshotListener {
            (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                print("Error fetching reviews: \(String(describing: error))")
                return
            }
            
            let reviewsSnapshot = querySnapshot.documents
            self.parseReviewsSnapshot(snapshot: reviewsSnapshot)
            
//            self.setupUserListener()
            
        }
    }
    
    func parseReviewsSnapshot(snapshot: [QueryDocumentSnapshot]) {
        
//        snapshot.forEach( (change) in
//                          var parsedReview: Review?
//                          
//                          do {
//            parsedReview = try change.
//        }
//                          
//        if let reviewsRef = snapshot.data()["reviews"] as? [DocumentReference] {
//            for reference in reviewsRef {
//                
//                reviewList.append(review)
//                
//                
//            }
//            
////            listeners.invoke { (listener) in
////                if listener.listenerType == ListenerType.reviews || listener.listenerType == ListenerType.all {
////                    listener.onTeamChange(change: .update, teamHeroes: .heroes)
////                }
////            }
//        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String) -> Bool {
        var result = false
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            let strongSelf = self
            
            if error != nil {
                print(error!)
                return
            }
            
            if let user = authResult?.user, let usersRef = strongSelf.usersRef {
                strongSelf.currentUser = user
                
                print(usersRef)
                usersRef.document(user.uid).setData(
                    [
                        "givenName" : givenName,
                        "familyName" : familyName,
                        "username" : username,
                        "email" : email,
                        "reviews" : []
                    ])
                
                result = true
            }
        }
        
        return result
    }
    
    
    func signIn(email: String, password: String) -> Bool {
        var result = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print(error!)
            }
        
            if let user = authResult?.user {
                strongSelf.currentUser = user
                result = true
            }
            
        }
        
        return result
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
