//
//  SearchRestaurantDelegate.swift
//  Eaten
//
//  Created by Vincent Wijaya on 29/5/2023.
//

import Foundation
import MapKit

protocol SearchRestaurantDelegate: AnyObject {
    func searchNearbyRestaurants(location: CLLocationCoordinate2D) -> [Restaurant]
}
