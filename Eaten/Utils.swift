//
//  Utils.swift
//  Eaten
//
//  Created by Vincent Wijaya on 3/6/2023.
//

import Foundation
import UIKit

func displayMessageWithDismiss(title: String, message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    viewController.present(alertController, animated: true, completion: nil)
}
