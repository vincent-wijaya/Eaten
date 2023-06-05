//
//  CreateReviewViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 26/4/2023.
//

import UIKit

class CreateReviewViewController: UIViewController, UITextFieldDelegate {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var restaurantField: UITextField!
    
//    @IBOutlet weak var dishDropdown: UIButton!
    
    @IBOutlet weak var foodField: UITextField!
    
    /**
     Rating functionality is from https://github.com/evgenyneu/Cosmos
     */
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var dateOrderedPicker: UIDatePicker!
    
    @IBOutlet weak var notesField: UITextView!
    
    @IBAction func createReview(_ sender: Any) {
        let CHARACTER_LIMIT = 25
        guard let restaurantName = restaurantField.text, restaurantName.count > 0 else {
            displayMessageWithDismiss(title: "Missing restaurant name", message: "Please the restaurant name", viewController: self)
            return
        }
        
        guard restaurantName.count <= CHARACTER_LIMIT else {
            displayMessageWithDismiss(title: "Restaurant name too long", message: "Please enter the restaurant name in \(CHARACTER_LIMIT) characters or less", viewController: self)
            return
        }
        
        guard let foodName = foodField.text, foodName.count > 0 else {
            displayMessageWithDismiss(title: "Missing food name", message: "Please enter the name of the food", viewController: self)
            return
        }
        
        guard foodName.count <= CHARACTER_LIMIT else {
            displayMessageWithDismiss(title: "Food name too long", message: "Please enter the food name in \(CHARACTER_LIMIT) characters or less", viewController: self)
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
            displayMessageWithDismiss(title: "Error", message: "Failed to add review", viewController: self)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        
        let maxLength = 5
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
//        dateOrderedPicker.datePickerMode = .date
        dateOrderedPicker.maximumDate = Date()
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
