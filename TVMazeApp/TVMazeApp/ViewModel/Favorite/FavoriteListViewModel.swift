//
//  FavoriteListViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/29/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct FavoriteListViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Show>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Show>?) {
        self.dataSource = dataSource
    }
    
    func fetchShows(completion: @escaping FetchComplete) {
        
        // CoreDate Fetch shows
        FavoriteManager.shared.fetchFavoriteShows { result in
            switch result {
            case .success(let shows):
                self.dataSource?.data = shows ?? []
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.custom(string: "Unable to Fetch Favorite Shows from CoreData"))
                completion()
            }
        }
    }
}
