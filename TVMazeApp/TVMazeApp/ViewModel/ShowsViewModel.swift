//
//  ShowsViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct ShowsViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Show>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Show>?) {
        self.dataSource = dataSource
    }
    
    func fetchShows(completion: @escaping FetchComplete) {
        // API fetch shows
//        ShowAPI.getShows{ result in
//            switch result {
//            case .success(let shows):
//                print("_____________________________")
//                print(shows)
//                self.dataSource?.data = shows
//                completion()
//            case .failure(let error):
//                print(error.localizedDescription)
//                self.onErrorHandling?(.network(string: "Unable to Fetch Shows"))
//            }
//        }
        
        ShowAPI.getShowsBy(page: 0) { result in
            switch result {
            case .success(let shows):
                print("_____________________________")
                print(shows)
                self.dataSource?.data = shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Shows"))
            }
        }

    }
    
    func fetchShowsBy(page: Int, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.getShowsBy(page: page) { result in
            switch result {
            case .success(let shows):
                print("_____________________________")
                print(shows)
                self.dataSource?.data = shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Shows"))
            }
        }
    }
    
    func searchShowsBy(query: String, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.searchShowsBy(query: query) { result in
            switch result {
            case .success(let resultShows):
                print("_____________________________")
                print(resultShows)
                //HACK: due to mixed JSON score/show in result we need to map show results only
                //https://www.tvmaze.com/api#show-search
                self.dataSource?.data = resultShows.map { $0.show }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Search for Shows"))
            }
        }
    }
}
