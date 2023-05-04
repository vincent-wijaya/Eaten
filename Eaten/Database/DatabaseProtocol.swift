//
//  DatabaseProtocol.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import Foundation

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
    func onReviewChange(change: DatabaseChange, reviewList: [Review])
}

protocol DatabaseProtocol: AnyObject {
    func cleanUp()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
//    func addReview()
    
    func signIn(email: String, password: String) -> Bool
    func createAccount(givenName: String, familyName: String, username: String, email: String, password: String) -> Bool
    func signOut()
}
