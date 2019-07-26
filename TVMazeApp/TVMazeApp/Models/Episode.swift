//
//  Episode.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct Episode: Codable {
    var id: Int
    var url: String?
    var name: String
    var season: Int?
    var number: Int?
    var airdate: Date?
    var airtime: String?
    var airstamp: String?
    var runtime: Int?
    var image: ShowImage?
    var summary: String?
    var _links: ShowLinks?
}
