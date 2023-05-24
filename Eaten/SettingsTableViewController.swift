//
//  SettingsTableViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 29/4/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let FIRST_CELL = "firstCell"
    
    let LOGIN_SECTION = 0
    
    struct Setting {
        let title: String?
        let handler: (() -> Void)
    }
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if databaseController?.currentUser == nil {
            return 1
        }
        else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FIRST_CELL, for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if indexPath.row == 0 {
            if let currentUser = databaseController?.currentUser {
                content.text = currentUser.username
            }
        }
        else if indexPath.row == 1 {
//            if databaseController?.currentUser != nil {
                content.text = "Log out"
                content.textProperties.color = .systemRed
//            }
        }
            
        cell.contentConfiguration = content

        // Configure the cell...

        return cell
    }

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == LOGIN_SECTION {
            if indexPath.row == 0 {
                if databaseController?.currentUser == nil {
                    performSegue(withIdentifier: "loginSegue", sender: self)
                }
                else {
                    // Display user information
                }
            }
            else if indexPath.row == 1 {
                if databaseController?.currentUser != nil {
                    databaseController?.signOut()
                    
                    navigationController?.popViewController(animated: true)
                }
            }
        }
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

}
