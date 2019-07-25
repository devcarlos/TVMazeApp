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

struct Country: Codable {
    var name: String
    var code: String
    var timezone: String
}

struct ShowNetwork: Codable {
    var id: Int
    var name: String
    var country: Country
}

struct ShowExternal: Codable {
    var tvrage: Int?
    var thetvdb: Int?
    var imdb: String?
}

struct WebChannel: Codable {
    var id: Int
    var name: String
    var country: Country?
}

struct ShowImage: Codable {
    var medium: String
    var original: String
}

struct ShowURL: Codable {
    var href: String
}

struct ShowLinks: Codable {
    var url: ShowURL?
    var previousepisode: ShowURL?
    var nextepisode: ShowURL?
    
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
    var image: ShowImage?
    var summary: String?
    var updated: Int?
    var _links: ShowLinks?
}

struct ResultShow: Codable {
    var score: Float
    var show: Show
}
