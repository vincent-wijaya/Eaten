//
//  Restaurant.swift
//  Eaten
//
//  Created by Vincent Wijaya on 29/5/2023.
//

import Foundation
import GooglePlaces

class Restaurant: NSObject {
    var id: String?
    var name: String?
    var cuisine: String?
    var restaurantDescription: String?
    var address: String?
    var types: [String]?
    var openingHours: GMSOpeningHours?
    var phoneNumber: String?
    
    init(_ place: GMSPlace) {
        id = place.placeID
        name = place.name
//            cuisine = place.
        restaurantDescription = place.description
        address = place.formattedAddress
        types = place.types
        openingHours = place.openingHours
        phoneNumber = place.phoneNumber
    }
    
//        var coordinate: CLLocationCoordinate2D
//
//        init(id: String, name: String, cuisine: String, description: String, address: String, lat: Double, long: Double) {
//            self.id = id
//            self.name = name
//            self.cuisine = cuisine
//            self.description = description
//            self.address =
//            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        }
}
