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
    
    weak var dataSource : GenericDataSource<Episode>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Episode>?) {
        self.dataSource = dataSource
    }
    
    func fetchEpisodes(showId: Int, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.getEpisodes(showId: showId) { result in
            switch result {
            case .success(let episodes):
                print("_____________EPISODES________________")
                print(episodes)
                self.dataSource?.data = episodes
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Show Episodes"))
            }
        }
    }
}
