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
        APIClient.getShows{ result in
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
}
