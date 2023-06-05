//
//  UserReviewsTableViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 24/4/2023.
//

import UIKit

class UserReviewsTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    var listenerType = ListenerType.reviews
    weak var databaseController: DatabaseProtocol?
    
//    let SECTION_REVIEW = 0
//    let SECTION_INFO = 1
    var SECTION_INFO: Int = 0
    
    let CELL_REVIEW = "reviewCell"
    let CELL_INFO = "infoCell"
    
    var restaurantCategorisedReviews: [String: [Review]] = [String: [Review]]()
    var allUserReviews: [Review] = []
    var filteredReviews: [Review] = []
    
    var ratingsArray = [Int: Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        filteredReviews = allUserReviews
        
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Reviews"
//        navigationItem.searchController = searchController
        
        view.addSubview(addReviewButton)
        
        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addReviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addReviewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addReviewButton.widthAnchor.constraint(equalToConstant: 60),
            addReviewButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /* Parts of code taken from iOS Academy YouTube channel.
     Swift: Create Floating Button (2021, Xcode 12, Swift 5) - iOS Development https://www.youtube.com/watch?v=oobm2y-d17E
     
     */
    private let addReviewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemOrange
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.7
        
        button.layer.cornerRadius = 30
        
        return button
    }()
    
//    @objc private func didTapButton() {
//        let alert
//    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
////        addReviewButton.frame = CGRect(x: view.frame.size.width - 100, y: view.frame.size.height - 320, width: 60, height: 60)
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        // Do something
    }
    
    func onUserChange(change: DatabaseChange, user: User) {
        // Do something
    }
    
    func onUserReviewsChange(change: DatabaseChange, reviewList: [Review]) {
        print("Fetching reviews")
        allUserReviews = reviewList
        print("\(allUserReviews.count) review fetched")
        
        restaurantCategorisedReviews = categoriseReviewsByRestaurants(allReviews: reviewList)
        SECTION_INFO = restaurantCategorisedReviews.count
        
        tableView.reloadData()
        
//        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func categoriseReviewsByRestaurants(allReviews: [Review]) -> [String: [Review]] {
        print("categorising reviews")
        var categorised = [String: [Review]]()
        for review in allReviews {
            if let restaurantName = review.restaurantName {
                
                if let reviews = categorised[restaurantName] {
                    // Restaurant already exists, so append review to the existing array
//                    restaurantCategorisedReviews[restaurantName]?.append(review)
                    categorised[restaurantName]?.append(review)
                }
                else {
                    // Restaurant doesn't exist, create new array with the review
//                    restaurantCategorisedReviews[restaurantName] = [review]
                    categorised[restaurantName] = [review]
                }
            }
        }
        
//        let sortedKeys = categorised.keys.sorted()
//        print(sortedKeys)
//
//        var sorted = [String: [Review]]()
//        for key in sortedKeys {
//            sorted[key] = categorised[key]
//        }
//        print(sorted)
        // Code from ChatGPT and https://stackoverflow.com/a/32383517
        let sorted = Dictionary(uniqueKeysWithValues: categorised.sorted { $0.0 < $1.0 })

        
        return sorted
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("Number of sections: \(restaurantCategorisedReviews.count + 1)")
        return restaurantCategorisedReviews.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != SECTION_INFO {
            let sectionValues = Array(restaurantCategorisedReviews.values)
            let reviews = sectionValues[section]
            return reviews.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("displaying reviews")
        if indexPath.section != SECTION_INFO {
            // Configure and return a hero cell
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: CELL_REVIEW, for: indexPath) as! ReviewTableViewCell
            
            
            
            let sectionIndex = indexPath.section
            let sectionKeys = Array(restaurantCategorisedReviews.keys)
            let restaurantName = sectionKeys[sectionIndex]
            let restaurantReviews = restaurantCategorisedReviews[restaurantName] ?? []
            let review = restaurantReviews[indexPath.row]
            
            reviewCell.titleLabel.adjustsFontSizeToFitWidth = true
            reviewCell.titleLabel.minimumScaleFactor = 0.5
            reviewCell.titleLabel.text = review.foodName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            reviewCell.subtitleLabel.text = "Created on: \(dateFormatter.string(from: review.dateCreated!))"
            
            reviewCell.ratingView.rating = Double(review.rating!)
//            reviewCell.ratingView.settings.updateOnTouch = false
            
            
            return reviewCell
        }
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for:
                                                            indexPath) as! ReviewCountTableViewCell
            
//            infoCell.totalLabel?.text = "\(filteredReviews.count) reviews"
            infoCell.totalLabel?.text = "\(allUserReviews.count) reviews"
            
            return infoCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != SECTION_INFO {
            let sectionKeys = Array(restaurantCategorisedReviews.keys)
            let restaurantName = sectionKeys[section]
            return restaurantName
        }
        else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != SECTION_INFO {
            return 70
        }
        else {
            return 38
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
