//
//  NSObject+Utils.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import UIKit

extension NSObject {
    static var reuseID: String {
        return String(describing: self)
    }
}


