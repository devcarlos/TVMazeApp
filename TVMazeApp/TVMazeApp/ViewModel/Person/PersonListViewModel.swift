//
//  PersonListViewModel.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation

struct PersonListViewModel {
    
    typealias FetchComplete = ()->()
    
    weak var dataSource : GenericDataSource<Person>?
    
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    init(dataSource : GenericDataSource<Person>?) {
        self.dataSource = dataSource
    }
    
    func searchPersonsBy(query: String, completion: @escaping FetchComplete) {
        // API fetch shows
        PersonAPI.searchPersons(query: query) { result in
            switch result {
            case .success(let result):
                
                //HACK: due to mixed JSON score/person we need to map persons
                //https://www.tvmaze.com/api#people-search
                self.dataSource?.data = result.map { $0.person }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.onErrorHandling?(.network(string: "Unable to Search for Shows"))
                completion()
            }
        }
    }
}
