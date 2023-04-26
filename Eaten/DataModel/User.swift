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
    var name: String?
    var reviewList: [Review]?
}
