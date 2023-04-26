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
    var author: User?
    var reviewText: String?
    var notes: String?
    var rating: Int?
    var date: Date?
    var restaurantId: String?
    var dishName: String?
}
