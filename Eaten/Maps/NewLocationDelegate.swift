//
//  NewLocationDelegate.swift
//  Eaten
//
//  Created by Vincent Wijaya on 2/5/2023.
//

import Foundation

protocol NewLocationDelegate: NSObject {
    func annotaionAdded(annotation: LocationAnnotation)
}
