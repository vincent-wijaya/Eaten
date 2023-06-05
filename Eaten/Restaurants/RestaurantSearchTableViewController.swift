//
//  RestaurantsTableViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import CoreLocation
import GooglePlaces
import MapKit

class RestaurantSearchTableViewController: UITableViewController, CLLocationManagerDelegate, GMSAutocompleteFetcherDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    weak var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    let locationManager: CLLocationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var fetcher: GMSAutocompleteFetcher?
    var searchPredictions = [GMSAutocompletePrediction]()
    
    let CELL_RESTAURANT = "restaurantCell"
    
    var currentLocation: CLLocationCoordinate2D?
    
    let PLACES_API_KEY = "AIzaSyCq_WMJfKUFjDOO13OhDQJwX2KLXc38FxQ"
    
    var restaurants = [Restaurant]()
    
    weak var searchRestaurantDelegate: SearchRestaurantDelegate?
    
    
    @IBAction func reloadRestaurants(_ sender: Any) {
        Task {
            guard let currentLocation = currentLocation else {
                // Display alert which says "Location cannot be determined"
                
                return
            }
//            await fetchRestaurants(coordinate: currentLocation)
            
            if let searchRestaurantDelegate = searchRestaurantDelegate {
                restaurants = searchRestaurantDelegate.searchNearbyRestaurants(location: currentLocation)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchRestaurantDelegate = RestaurantSearchController()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        
        let authorisationStatus = locationManager.authorizationStatus
        if authorisationStatus != .authorizedWhenInUse {
            if authorisationStatus == .notDetermined {
                // Request location authorization
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            // Start updating location if already authorized
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
//    func createAutocompleteFetcher() -> GMSAutocompleteFetcher {
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
//
//        fetcher = GMSAutocompleteFetcher(filter: filter)
//        fetcher?.delegate = self
//
//        return fetcher!
//    }
    
    func fetchRestaurants(coordinate: CLLocationCoordinate2D) async {
        
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
                        self.createMapAnnotation(title: place.name!, subtitle: place.formattedAddress!, coordinate: place.coordinate)
                        let restaurant = Restaurant(place)
                        self.restaurants.append(restaurant)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            })
        
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: <#T##GMSPlaceField#>, callback: <#T##GMSPlaceLikelihoodsCallback##GMSPlaceLikelihoodsCallback##([GMSPlaceLikelihood]?, Error?) -> Void#>)
        
//        let locationManager = CLLocationManager()
//        locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }

        var requestURLComponents = URLComponents()
        requestURLComponents.scheme = "https"
        requestURLComponents.host = "www.maps.googleapis.com"
        requestURLComponents.path = "/maps/api/place/nearbysearch/json"
        requestURLComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "type", value: "restaurant"),
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
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        var restaurants: [GMSAutocompletePrediction] = []
        for prediction in predictions {
            if prediction.types.contains("restaurant") {
                restaurants.append(prediction)
            }
        }
        searchPredictions = restaurants
        
        print(searchPredictions.count)
        self.tableView.reloadData()    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error)
    }
    
    
    func fetchRestaurantDetails(placeId: String) {
        placesClient.lookUpPlaceID(placeId) {
            [self] (restaurant, error) in
            if error != nil {
                print("Error fetching: \(error)")
                return
            }
            
            
        }
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse:
            // Start updating location when authorized
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied or restricted authorization status
            // Display an alert to inform the user or take appropriate action
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            print("location: \(location)")
            
            guard let location = locations.last else { return }
            
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            currentLocation = coordinate
            moveFocus(coordinate: coordinate)
        }
    }
//
//    func getRestaurants(coordinate: CLLocationCoordinate2D) async {
//
//        var requestURLComponents = URLComponents()
//        requestURLComponents.scheme = "https"
//        requestURLComponents.host = "www.maps.googleapis.com"
//        requestURLComponents.path = "/maps/api/place/search/json"
//        requestURLComponents.queryItems = [
//            URLQueryItem(name: "location", value: "\(coordinate.longitude),\(coordinate.latitude)"),
//            URLQueryItem(name: "types", value: "food"),
//            URLQueryItem(name: "key", value: PLACES_API_KEY)
//        ]
//
//        guard let requestURL = requestURLComponents.url else {
//            print("Invalid URL.")
//            return
//        }
//
//        print(requestURL)
//        let urlRequest = URLRequest(url: requestURL)
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                return
//            }
//
//            let decoder = JSONDecoder()
//            let volmeData = try decoder.decode(VolumeData.self, from: data)
//
//
//        }
//        catch let error {
//            print(error)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RESTAURANT, for: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
    
        content.text = restaurant.name
        content.secondaryText = restaurant.address
        cell.contentConfiguration = content

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mapViewController?.mapView?.removeAnnotation(locationList[indexPath.row])
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapViewController?.focusOn(annotation: locationList[indexPath.row])
        splitViewController?.show(.secondary)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated:true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func moveFocus(coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(zoomRegion, animated: false)
    }
    
    func createMapAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
//        let annotation = LocationAnnotation(title: title, subtitle: subtitle, lat: coordinate.latitude, long: coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
}
