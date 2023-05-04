//
//  MapViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import GooglePlaces
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var placesClient: GMSPlacesClient!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
//    let mapView = MKMapView(frame: view.bounds)
//    view.addSubview(mapView)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        
        let authorisationStatus = locationManager.authorizationStatus
        if authorisationStatus != .authorizedWhenInUse {
            if authorisationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
//        let location = // User's location
//        let filter = GMSPlaceFilter()
//        filter.type = .restaurant // Specify the type of places you want to retrieve
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(with: filter) { (likelihoodList, error) in
//          if let error = error {
//            print("Error retrieving nearby places: \(error.localizedDescription)")
//            return
//          }
//          if let likelihoodList = likelihoodList {
//            for likelihood in likelihoodList {
//              let place = likelihood.place
//              // Do something with the retrieved place data
//            }
//          }
//        }
//
//        let placeFields: GMSPlaceField = [.name, .formattedAddress]
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
//            guard let strongSelf = self else {
//                return
//            }
//
//            guard error == nil else {
//                print("Current place error :\(error?.localizedDescription ?? "")")
//                return
//            }
//
//            guard let place = placeLikelihoods?.first?.place else {
//                print("no current place")
//                return
//            }
//
//            print("\(place.name) | \(place.formattedAddress)")
//        }
    

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
    
//    func useCurrentLocation() {
//        if let currentLocation = currentLocation {
//
//        }
//    }
    

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
}
