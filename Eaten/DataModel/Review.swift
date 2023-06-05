//
//  Review.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class Review: NSObject, Codable {

    @DocumentID var id: String?
    var authorId: String?
    var restaurantId: String?
    var restaurantName: String?
    var rating: Int?
    var foodName: String?
    var dateOrdered: Date?
    var notes: String?
    var dateCreated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorId
        case restaurantId
        case restaurantName
        case rating
        case foodName
        case dateOrdered
        case notes
        case dateCreated
    }
}
