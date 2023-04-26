//
//  MapViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 20/4/2023.
//

import UIKit
import GooglePlaces

class MapViewController: UIViewController {

//    @IBOutlet weak var mapView: MapVi!
    
    private var placesClient: GMSPlacesClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        
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
    
//    func focusOn(annotation: MKAnnotation) {
//        mapView.selectAnnotation(annotation, animated: true)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
