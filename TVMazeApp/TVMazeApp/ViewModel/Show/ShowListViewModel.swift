//
//  ShowListViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

class Pagination {
    var currentPage:Int
    
    init() {
        currentPage = 0
    }
}

struct ShowListViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Show>?
    
    var pagination:Pagination = Pagination()
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Show>?) {
        self.dataSource = dataSource
    }
    
    func fetchShows(completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.getShows{ result in
            switch result {
            case .success(let shows):
                self.dataSource?.data = shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Shows"))
                completion()
            }
        }
    }
    
    func fetchShowsBy(page: Int, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.getShowsBy(page: page) { result in
            switch result {
            case .success(let shows):
                self.dataSource?.data = shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Shows"))
                completion()
            }
        }
    }
    
    func nextPageShows(completion: @escaping FetchComplete) {
        
        pagination.currentPage += 1
        
        // API fetch shows
        ShowAPI.getShowsBy(page: pagination.currentPage) { result in
            switch result {
            case .success(let shows):
                //append pagination shows to current data
                self.dataSource?.data += shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to fetch more shows with pagination"))
                completion()
            }
        }
    }
    
    func searchShowsBy(query: String, completion: @escaping FetchComplete) {
        // API fetch shows
        ShowAPI.searchShowsBy(query: query) { result in
            switch result {
            case .success(let resultShows):
                //HACK: due to mixed JSON score/show in result we need to map show results only
                //https://www.tvmaze.com/api#show-search
                self.dataSource?.data = resultShows.map { $0.show }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Search for Shows"))
                completion()
            }
        }
    }
}
