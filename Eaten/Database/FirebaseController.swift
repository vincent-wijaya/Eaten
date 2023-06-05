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
    var friendsRef: CollectionReference?
    var reviewsRef: CollectionReference?
    
    var currentUser: User?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        currentUser = User()
        reviewList = [Review]()
        
        usersRef = database.collection("users")
        friendsRef = database.collection("friends")
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
            listener.onUserReviewsChange(change: .update, reviewList: reviewList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: Authentication
    
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String) {
        var result = false
        
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
            }
        }
    }
    
    
    func signIn(email: String, password: String) -> Bool {
        var result = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            Task {
                guard let strongSelf = self else { return }
                
                if error != nil {
                    print(error!)
                    return
                }
                
                //            strongSelf.setupUserListener()
                
                strongSelf.reviewList = [Review]()
            }
        }
        
        return result
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Users
    
    /// Checks firebase database if a user with the username exists.
    /// - Parameter username: username to check
    /// - Returns: User ID associated with username if exists, otherwise nil
    func checkUsernameExists(username: String) async -> String? {do {
            let querySnapshot = try await usersRef?.whereField("username", isEqualTo: username).getDocuments()
            
            guard let querySnapshot = querySnapshot else {
                print("Error fetching users")
                return nil
            }
            
            let userDocuments = querySnapshot.documents
            
            if let userId = userDocuments.first?.documentID {
                // Username exists
                return userId
            }
        }
        catch {
            print("Error fetching documents: \(error.localizedDescription)")
            return nil
        }
        
        return nil
    }
    
    /// Checks firebase database if a user with the email exists.
    /// - Parameter email: email to check
    /// - Returns: User ID associated with email if exists, otherwise nil
    func checkEmailExists(email: String) async -> String? {
        do {
            let querySnapshot = try await usersRef?.whereField("email", isEqualTo: email).getDocuments()
            
            guard let querySnapshot = querySnapshot else {
                print("Error fetching users")
                return nil
            }
            
            let userDocuments = querySnapshot.documents
            
            if let userId = userDocuments.first?.documentID {
                // Email exists
                return userId
            }
        }
        catch {
            print("Error fetching documents: \(error.localizedDescription)")
            return nil
        }
        
        return nil
    }
    
//    // Remove redundancy
//    func getUserIdFromEmail(email: String) async -> String? {
//        do {
//            let querySnapshot = try await usersRef?.whereField("email", isEqualTo: email).getDocuments()
//            
//            guard let querySnapshot = querySnapshot else {
//                print("Error fetching users")
//                return nil
//            }
//            
//            if let userDocuments = querySnapshot.documents {
//                let userId = userDocuments.
//            }
//        }
//        catch {
//            print("Error fetching documents: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    func insertUser(id: String, givenName: String, familyName: String, username: String, email: String) -> User? {
        
        let user = User()
        user.givenName = givenName
        user.familyName = familyName
        user.fullName = "\(givenName) \(familyName)"
        user.username = username
        user.email = email
        
        createFriendsRefDocument(id: id)
        
        user.friends = database.document("friends/" + id)
        
        do {
            try usersRef?.document(id).setData(from: user)
        }
        catch {
            print("Failed to serialise user")
            return nil
        }
        
        return user
    }
    
    func createFriendsRefDocument(id: String) {
        friendsRef?.document(id).setData(["friends": [], "sentRequests": [], "receivedRequests": []])
        print("Created friends document")
    }
    
    func fetchUserDetails() async {
        guard let currentUser = currentUser, let userId = currentUser.id else {
            return
        }
        
        do {
            let querySnapshot = try await usersRef?.document(userId).getDocument()
            
            guard let data = querySnapshot?.data(),
                  let givenName = data["givenName"] as? String,
                  let familyName = data["familyName"] as? String,
                  let fullName = data["fullName"] as? String,
                  let username = data["username"] as? String,
                  let email = data["email"] as? String else {
                return
            }
            
            currentUser.givenName = givenName
            currentUser.familyName = familyName
            currentUser.fullName = fullName
            currentUser.username = username
            currentUser.email = email
        }
        catch {
            print("Error fetching user: \(error.localizedDescription)")
            return
        }
    }
    
//    func setupUserListener() {
//        guard let currentUser = currentUser, let userId = currentUser.id else {
//            return
//        }
//
//        usersRef?.document(userId).addSnapshotListener { (documentSnapshot, error) in
//
//            if error != nil {
//                print("Error encountered retrieving user: \(String(describing: error?.localizedDescription))")
//                return
//            }
//
//            guard let userSnapshot = documentSnapshot else {
//                print("Error fetching users: \(String(describing: error))")
//                return
//            }
//
//            self.parseLoggedInUserSnapshot(snapshot: userSnapshot)
//
//        }
//    }
    
    func parseLoggedInUserSnapshot(snapshot: DocumentSnapshot) {
//        user = User()
        
        guard let data = snapshot.data(),
              let givenName = data["givenName"] as? String,
              let familyName = data["familyName"] as? String,
              let username = data["username"] as? String,
              let email = data["email"] as? String, let reviews = data["reviews"] as? [DocumentReference] else {
            return
        }
        
        guard let currentUser = currentUser else {
            print("currentUser doesn't exist")
            return
        }
        
        currentUser.givenName = givenName
        currentUser.familyName = familyName
        currentUser.username = username
        currentUser.email = email
        
        
        
//        currentUser.reviewList =
    }
    
    // MARK: Reviews
    
    func insertReview(restaurantId: String, restaurantName: String, foodName: String, rating: Int, dateOrdered: Date, notes: String) -> Bool {
        let review = Review()
        review.authorId = currentUser?.id
        review.restaurantId = restaurantId
        review.restaurantName = restaurantName
        review.foodName = foodName
        review.rating = rating
        review.dateOrdered = dateOrdered
        review.notes = notes
        review.dateCreated = Date()
        
        do {
            if let reviewRef = try reviewsRef?.addDocument(from: review), let currentUser = currentUser {
                review.id = reviewRef.documentID
                
                addReviewToUser(newReviewRef: reviewRef, authorId: currentUser.id!)
                
                return true
            }
        }
        catch {
            print("Failed to serialise review")
            return false
        }
        
        return false
    }
    
    func addReviewToUser(newReviewRef: DocumentReference, authorId: String) {
        
        usersRef?.document(authorId).updateData(
                        ["reviews" : FieldValue.arrayUnion([newReviewRef])]
                    )

    }
    
    func setupUserReviewListener() {
        reviewList = [Review]()
        
        guard let currentUser = currentUser, let authorId = currentUser.id else {
            print("uid doesn't exist for some reason")
            return
        }

        reviewsRef?.whereField("authorId", isEqualTo: authorId).addSnapshotListener {
            (querySnapshot, error) in

            guard let querySnapshot = querySnapshot else {
                print("Error fetching reviews: \(String(describing: error))")
                return
            }

//            let reviewsSnapshot = querySnapshot.documents
            self.parseUserReviews(snapshot: querySnapshot)
            
//            self.setupUserListener()
            
        }
    }
    
    
    func fetchUserReviews() {
//        if let reviews = currentUser?.reviewList {
//            for review in reviews {
//                reviewsRef.
//            }
//        }
    }
    
    func parseUserReviews(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parsedReview: Review?
            
            do {
                parsedReview = try change.document.data(as: Review.self)
            }
            catch {
                print("Unable to decode review.")
                return
            }
            
            guard let review = parsedReview else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                reviewList.insert(review, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                reviewList[Int(change.newIndex)] = review
            }
            else if change.type == .removed {
                reviewList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.reviews || listener.listenerType == ListenerType.all {
                print("invoking listeners")
                listener.onUserReviewsChange(change: .update, reviewList: reviewList)
            }
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
    
    // - MARK: Friends
    
    func checkSentRequestExists(otherUserId: String, completion: @escaping (Bool?) -> Void) {
        guard let currentUser = currentUser, let currentUserId = currentUser.id else {
            print("Unable to retrieve current user's id")
            completion(nil)
            return
        }
        
        let currentUserRef = friendsRef?.document(currentUserId)
        
        Task {
            currentUserRef?.getDocument { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {
                    print("Current user friends document does not exist")
                    return
                }
                
                if let sentRequests = querySnapshot.data()?["sentRequests"] as? [String] {
                    if let _ = sentRequests.firstIndex(of: otherUserId) {
                        // Friend request already sent before
                        completion(true)
                        return
                    }
                }
            }
        }
        completion(false)
    }
    
    func sendFriendRequest(otherUserId: String) {
        guard let currentUser = currentUser, let currentUserId = currentUser.id else {
            print("Unable to retrieve current user's id")
            return
        }
        
        let currentUserRef = friendsRef?.document(currentUserId)
        let otherUserRef = friendsRef?.document(otherUserId)
        
        Task {
            currentUserRef?.getDocument { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot, querySnapshot.exists else {
                    print("Current user friends document does not exist")
                    return
                }
                
                // Retrieve current user's received friend requests list
                if let receivedRequests = querySnapshot.data()?["receivedRequests"] as? [String] {
                    if let _ = receivedRequests.firstIndex(of: otherUserId) {
                        // Friend request from other user found
                        
                        // Remove other user from the current user's receivedRequests list in the DB
                        currentUserRef?.updateData( ["receivedRequests" : FieldValue.arrayRemove([otherUserId])] )
                        // Remove current user from the other user's sentRequests list in the DB
                        otherUserRef?.updateData( ["sentRequests" : FieldValue.arrayRemove([currentUserId])] )
                        
                        // Add other user to current user's friends list in the DB
                        currentUserRef?.updateData( ["friends" : FieldValue.arrayUnion([otherUserId])] )
                        // Add current user to other user's friends list in the DB
                        otherUserRef?.updateData( ["friends" : FieldValue.arrayUnion([currentUserId])] )
                    }
                    else {
                        // Current user does not have an existing friend request from the other user
                        
                        // Add other user to current user's sentRequests list in the DB
                        currentUserRef?.updateData( ["sentRequests" : FieldValue.arrayUnion([otherUserId])] )
                        // Add current user to other user's sentRequests list in the DB
                        otherUserRef?.updateData( ["receivedRequests" : FieldValue.arrayUnion([currentUserId])] )
                    }
                }
            }
        }
    }
}
