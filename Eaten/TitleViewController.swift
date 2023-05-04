//
//  TitleViewController.swift
//  Eaten
//
//  Created by Vincent Wijaya on 29/4/2023.
//

import UIKit

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createAccountSegue" {
            let destination = segue.destination as! CreateAccountViewController
            destination.delegate = self
        }
    }
    

}
