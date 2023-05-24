//
//  User.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class User: NSObject, Codable {

    @DocumentID var id: String?
    var givenName: String?
    var familyName: String?
    var fullName: String?
    var username: String?
    var email: String?
    var reviewList: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case givenName
        case familyName
        case fullName
        case username
        case email
        case reviewList
    }
}
