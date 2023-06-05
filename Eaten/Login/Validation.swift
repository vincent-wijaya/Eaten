//
//  Validation.swift
//  Eaten
//
//  Created by Vincent Wijaya on 5/6/2023.
//

import Foundation

/**
        From https://stackoverflow.com/a/25471164
 */
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    return password.count >= 8
}
