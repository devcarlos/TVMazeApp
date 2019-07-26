//
//  Storyboard+Utils.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboardable: class {
    static var mainStoryboard: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var mainStoryboard: String {
        return "Main"//String(describing: self)
    }
    
    static func storyboardViewController() -> Self {
        let storyboard = UIStoryboard(name: mainStoryboard, bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: Self.reuseID) as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(mainStoryboard)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboardable { }
