//
//  RestaurantSearchController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/5/2023.
//

import Foundation

import GooglePlaces

class RestaurantSearchController: SearchRestaurantDelegate {
    
    let PLACES_API_KEY = "AIzaSyCq_WMJfKUFjDOO13OhDQJwX2KLXc38FxQ"
    
    func searchNearbyRestaurants(_ coordinate: CLLocationCoordinate2D) {
        
        let placesClient = GMSPlacesClient.shared()
        
        let location = "\(coordinate.latitude),\(coordinate.longitude)"
        
////        var params = {
//            'locationbias': f'circle:500@{current_location}',
//            'input': 'restaurant',
//            'inputtype': 'textquery',
//            'key': API_KEY
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error ) in
            if let error = error {
                print("Error fetching: \(error)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                
                    if place.types!.contains("restaurant") {
                        // Found a nearby restaurant
//                        self.createMapAnnotation(title: place.name!, subtitle: place.formattedAddress!, coordinate: place.coordinate)
//                        let restaurant = Restaurant(place)
//                        self.restaurantList.append(restaurant)
                    }
                }
            }
            })
        
    }
    
    func searchNearbyRestaurants(location: CLLocationCoordinate2D) -> [Restaurant] {
        let placesClient = GMSPlacesClient.shared()
        var restaurants: [Restaurant] = [Restaurant]()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
//        let bounds = GMSCoordinateBounds(coordinate: location, radius: 500)
        
        let fields = GMSPlaceField.all
//        let options = GMSFindPlac
        
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { (placeLikelihoods, error) in
            if let error = error {
                print("Error fetching nearby restaurants: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                for likelihood in placeLikelihoods {
                    let place = likelihood.place
                    let name = place.name
                    
                    print(name)
                }
            }
            
            
        }
        
        

        
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error ) in
//            if let error = error {
//                print("Error fetching: \(error)")
//                return
//            }
//
//            if let placeLikelihoodList = placeLikelihoodList {
//                for likelihood in placeLikelihoodList.likelihoods {
//                    let place = likelihood.place
//
//                    if place.types!.contains("restaurant") {
//                        let restaurant = Restaurant(place)
//                        restaurants.append(restaurant)
//                        // Found a nearby restaurant
////                        self.createMapAnnotation(title: place.name!, subtitle: place.formattedAddress!, coordinate: place.coordinate)
//                    }
//                }
//            }
//        })
        
        return restaurants
    }
    
    
    func searchRestaurantsBy(_ query: String) {
        
        var requestURLComponents = URLComponents()
        requestURLComponents.scheme = "https"
        requestURLComponents.host = "www.maps.googleapis.com"
        requestURLComponents.path = "/maps/api/place/textsearch/output?parameters"
        requestURLComponents.queryItems = [
            URLQueryItem(name: "query", value: "restaurants \(query)"),
//            URLQueryItem(name: "radius", value: 500)
            URLQueryItem(name: "key", value: PLACES_API_KEY)
        ]
//    https://maps.googleapis.com/maps/api/place/findplacefromtext/json
//      ?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry
//      &input=Museum%20of%20Contemporary%20Art%20Australia
//      &inputtype=textquery
//      &key=YOUR_API_KE
        
//        guard let requestURL = requestURLComponents.url else {
//            print("Invalid URL.")
//            return
//        }
//
//        print(requestURL)
//
//        let urlRequest = URLRequest(url: requestURL)
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                return
//            }
//
//            print(data)
//        }
//        catch let error {
//            print(error)
//        }
    }
}
