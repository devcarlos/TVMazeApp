//
//  User.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String
    var pin: Int
    var touchBarEnabled: Bool = false
}
