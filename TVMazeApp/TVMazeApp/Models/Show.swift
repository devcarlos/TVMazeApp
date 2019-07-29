//
//  Show.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct Schedule: Codable {
    var time: String
    var days: [String]
}

struct Rating: Codable {
    var average: Float?
}

struct MazeCountry: Codable {
    var name: String
    var code: String
    var timezone: String
}

struct ShowNetwork: Codable {
    var id: Int
    var name: String
    var country: MazeCountry
}

struct ShowExternal: Codable {
    var tvrage: Int?
    var thetvdb: Int?
    var imdb: String?
}

struct WebChannel: Codable {
    var id: Int
    var name: String
    var country: MazeCountry?
}

struct MazeImage: Codable {
    var medium: String
    var original: String
}

struct MazeURL: Codable {
    var href: String
}

struct MazeLinks: Codable {
    var url: MazeURL?
    var previousepisode: MazeURL?
    var nextepisode: MazeURL?
    
    private enum CodingKeys : String, CodingKey {
        case url = "self"
        case previousepisode
        case nextepisode
    }
}

struct Show: Codable {
    var id: Int
    var url: String?
    var name: String
    var type: String?
    var language: String?
    var genres: [String]?
    var status: String?
    var runtime: Int?
    var premiered: Date?
    var officialSite: String?
    var schedule: Schedule?
    var rating: Rating?
    var weight: Int?
    var network: ShowNetwork?
    var webChannel: WebChannel?
    var externals: ShowExternal?
    var image: MazeImage?
    var summary: String?
    var updated: Int?
    var _links: MazeLinks?
    
    func scheduleFormatted() -> String {
        guard let schedule = self.schedule else {
            return ""
        }
        
        return (schedule.days.map { "\($0) at \(schedule.time)" }).joined(separator: "\n")
    }
    
    func genresFormatted() -> String {
        guard let genres = self.genres else {
            return ""
        }
        
        return genres.joined(separator: " | ")
    }
    
    func ratingFormatted() -> String {
        guard let rating = self.rating?.average else {
            return "-"
        }
        
        return String(describing: rating)
    }
    
    func isFavorite(handler: @escaping (Bool) -> Void) {
        FavoriteManager.shared.findFavorite(show: self) { result in
            switch result {
            case .success:
                handler(true)
            case .failure:
                handler(false)
            }
        }
    }
}

struct ResultShow: Codable {
    var score: Float
    var show: Show
}
