//
//  Person.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct CastLinks: Codable {
    var show: MazeURL?
    var character: MazeURL?
}

struct CastEmbedded: Codable {
    var show: Show
}

struct Person: Codable {
    var id: Int
    var url: String?
    var name: String
    var country: MazeCountry?
    var birthday: Date?
    var deathday: Date?
    var gender: String?
    var image: MazeImage?
    var _links: MazeLinks?
}
        
struct ResultPerson: Codable {
    var score: Float
    var person: Person
}

struct CastResult: Codable {
    var links: CastLinks
    var embedded: CastEmbedded
    
    private enum CodingKeys : String, CodingKey {
        case links = "_links"
        case embedded = "_embedded"
    }
}
