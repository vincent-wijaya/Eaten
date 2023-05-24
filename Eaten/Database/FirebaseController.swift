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
    var reviewList: [Review]
    
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var reviewsRef: CollectionReference?
    
    var currentUser: User = User()
    
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
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: Authentication
    
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String) {
        var result = false
        
        print("Creating user")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            let strongSelf = self
            
            if error != nil {
                print(error!)
                return
            }
            
            if let id = authResult?.user.uid {
                guard let _ = strongSelf.insertUser(id: id, givenName: givenName, familyName: familyName, username: username, email: email) else {
                    
                    return
                }
                
//                strongSelf.setupUserListener()
            }
        }
    }
    
    
    func signIn(email: String, password: String) -> Bool {
        var result = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error != nil {
                print(error!)
                return
            }
            
//            strongSelf.setupUserListener()
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
    
    // MARK: Users
    
    func insertUser(id: String, givenName: String, familyName: String, username: String, email: String) -> User? {
        
        let user = User()
        user.givenName = givenName
        user.familyName = familyName
        user.fullName = "\(givenName) \(familyName)"
        user.username = username
        user.email = email
        
        guard let usersRef = usersRef else {
            return nil
        }
        
        do {
            try usersRef.document(id).setData(from: user)
        }
        catch {
            print("Failed to serialise user")
        }
        
        return user
    }
    
    func setupUserListener() {
        guard let userId = currentUser.id else {
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
            
            self.parseLoggedInUserSnapshot(snapshot: userSnapshot)
            
        }
    }
    
    func parseLoggedInUserSnapshot(snapshot: DocumentSnapshot) {
        let parsedUser = User()
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
        
        currentUser = parsedUser
    }
    
    // MARK: Reviews
    
    func insertReview(restaurantId: String, restaurantName: String, foodName: String, rating: Int, dateOrdered: Date, notes: String) -> Bool {
        let review = Review()
        review.restaurantId = restaurantId
        review.restaurantName = restaurantName
        review.foodName = foodName
        review.rating = rating
        review.dateOrdered = dateOrdered
        review.notes = notes
        review.dateCreated = Date()
        review.lastUpdated = nil
        
        do {
            if let reviewRef = try reviewsRef?.addDocument(from: review) {
                review.id = reviewRef.documentID
                return true
            }
        }
        catch {
            print("Failed to serialise review")
            return false
        }
        
        return false
    }
    
    func setupUserReviewListener() {
        guard let authorId = currentUser.id else {
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
    
    
    func fetchUserReviews() {
        
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
    
    
}
