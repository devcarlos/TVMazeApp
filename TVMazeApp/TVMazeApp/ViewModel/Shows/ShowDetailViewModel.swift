//
//  ShowDetailViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct ShowDetailViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Season>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Season>?) {
        self.dataSource = dataSource
    }
    
    func fetchEpisodes(showId: Int, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.getEpisodes(showId: showId) { result in
            switch result {
            case .success(let episodes):
                
                let seasonsValues = Array(Set((episodes.map { $0.season! }))).sorted(by: {$0 < $1})
                
                var seasons: [Season] = []
                for season in seasonsValues {
                    seasons.append(Season(season: season, episodes: (episodes.filter { $0.season == season})))
                }
                
                self.dataSource?.data = seasons
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Show Episodes"))
            }
        }
    }
}
