//
//  PersonViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct PersonViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Show>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Show>?) {
        self.dataSource = dataSource
    }
    
    func fetchPersonShows(personId: Int, completion: @escaping FetchComplete) {
        // API fetch shows
        PersonAPI.getPersonShows(personId: personId) { result in
            switch result {
            case .success(let result):
                let shows: [Show] = result.map { $0.embedded.show }
                
                self.dataSource?.data = shows
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Fetch Person Episodes"))
                completion()
            }
        }
    }
}

