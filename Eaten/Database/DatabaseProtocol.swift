//
//  DatabaseProtocol.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import Foundation
import Firebase

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case user
    case reviews
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange, user: User)
    func onUserReviewsChange(change: DatabaseChange, reviewList: [Review])
}

protocol DatabaseProtocol: AnyObject {
    var currentUser: User? {get set}
    
    func cleanUp()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func checkUsernameExists(username: String) async -> String?
    func checkEmailExists(email: String) async -> String?
    func insertReview(restaurantId: String, restaurantName: String, foodName: String, rating: Int, dateOrdered: Date, notes: String) -> Bool
    
    func signIn(email: String, password: String) -> Bool
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String)
    func signOut()
    
    func checkSentRequestExists(otherUserId: String, completion: @escaping (Bool?) -> Void)
    func sendFriendRequest(otherUserId: String)

}
