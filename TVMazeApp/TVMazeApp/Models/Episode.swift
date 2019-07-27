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
    var airdate: String?
    var airtime: String?
    var airstamp: String?
    var runtime: Int?
    var image: MazeImage?
    var summary: String?
    var _links: MazeLinks?
    
    func numberFormatted() -> String {
        guard let number = self.number else {
            return ""
        }
        
        return "Episode \(number)"
    }
    
    func seasonFormatted() -> String {
        guard let season = self.season else {
            return ""
        }
        
        return "Season \(season)"
    }
}

struct Season: Codable {
    var season: Int
    var episodes: [Episode]
}
