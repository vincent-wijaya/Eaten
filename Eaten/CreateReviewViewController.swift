//
//  CreateReviewViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 26/4/2023.
//

import UIKit

class CreateReviewViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var restaurantField: UITextField!
    
//    @IBOutlet weak var dishDropdown: UIButton!
    
    @IBOutlet weak var foodField: UITextField!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    @IBOutlet weak var dateOrderedPicker: UIDatePicker!
    
    @IBOutlet weak var notesField: UITextField!
    
    @IBAction func createReview(_ sender: Any) {
        guard let restaurantName = restaurantField.text else {
            return
        }
        
        guard let foodName = foodField.text else {
            return
        }
        
        let rating = Int(ratingView.rating)
        
        let dateOrdered = dateOrderedPicker.date
        
        guard let notes = notesField.text else {
            return
        }
        
        
        let success = databaseController?.insertReview(restaurantId: "Sample", restaurantName: restaurantName, foodName: foodName, rating: rating, dateOrdered: dateOrdered, notes: notes)
        
        if success! {
            print("Review added successfully")
            navigationController?.popViewController(animated: true)
        }
        else {
            print("Failed to add review")
        }
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
