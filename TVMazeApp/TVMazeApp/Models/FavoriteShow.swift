//
//  FavoriteShow.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/29/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import CoreData

class FavoriteShow: NSManagedObject {

    // MARK: - Core Data Managed Object
    
    @NSManaged var showID: Int
    @NSManaged var name: String
    @NSManaged var genres: [String]?
    @NSManaged var time: String?
    @NSManaged var days: [String]?
    @NSManaged var rating: NSNumber?
    @NSManaged var image: String?
    @NSManaged var summary: String?
    
}
