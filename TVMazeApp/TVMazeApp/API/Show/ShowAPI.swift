//
//  ShowAPI.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Alamofire

class ShowAPI: APIClient {
    
    //MARK: - Shows API Callbacks
    class func getShows(completion:@escaping (AFResult<[Show]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: ShowRouter.shows, decoder: jsonDecoder, completion: completion)
    }
    
    class func getShowsBy(page:Int, completion:@escaping (AFResult<[Show]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: ShowRouter.showsBy(page: page), decoder: jsonDecoder, completion: completion)
    }
    
    class func searchShowsBy(query: String, completion:@escaping (AFResult<[ResultShow]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: ShowRouter.search(query: query), decoder: jsonDecoder, completion: completion)
    }
    
    class func getEpisodes(showId: Int, completion:@escaping (AFResult<[Episode]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: ShowRouter.episodes(id: showId), decoder: jsonDecoder, completion: completion)
    }
}

