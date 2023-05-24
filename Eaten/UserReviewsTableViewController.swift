//
//  ReviewsTableViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 24/4/2023.
//

import UIKit

class UserReviewsTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    var listenerType = ListenerType.reviews
    weak var databaseController: DatabaseProtocol?
    
    let SECTION_REVIEW = 0
    let SECTION_INFO = 1
    
    let CELL_REVIEW = "reviewCell"
    let CELL_INFO = "infoCell"
    
    var allUserReviews: [Review] = []
    var filteredReviews: [Review] = []
    
    
    func updateSearchResults(for searchController: UISearchController) {
        // Do something
    }
    
    func onUserChange(change: DatabaseChange, user: User) {
        // Do something
    }
    
    func onReviewChange(change: DatabaseChange, reviewList: [Review]) {
        // Do something
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        filteredReviews = allUserReviews
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reviews"
        navigationItem.searchController = searchController
        
        view.addSubview(addReviewButton)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addReviewButton.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 100, width: 60, height: 60)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_REVIEW {
            return filteredReviews.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_REVIEW {
            // Configure and return a hero cell
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: CELL_REVIEW, for: indexPath)
            
//            var content = reviewCell.defaultContentConfiguration()
//            let review = filteredReviews[indexPath.row]
//            content.text = review.author!.name
//            content.secondaryText = review.description
//            reviewCell.contentConfiguration = content
            
            return reviewCell
        }
        else if indexPath.section == SECTION_INFO {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for:
                                                            indexPath) as! ReviewCountTableViewCell
            
            infoCell.totalLabel?.text = "\(filteredReviews.count) reviews"
            
            return infoCell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addReviewCell", for: indexPath)
            return cell
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
