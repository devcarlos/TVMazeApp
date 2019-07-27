//
//  EpisodeViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct EpisodeViewModel {
    
    var dataSource: EpisodeDataSource?
    
    init(dataSource : EpisodeDataSource?) {
        self.dataSource = dataSource
    }
}
