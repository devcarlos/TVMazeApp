//
//  PersonAPI.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Alamofire

class PersonAPI: APIClient {
    
    class func searchPersons(query: String, completion:@escaping (AFResult<[ResultPerson]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: PersonRouter.search(query: query), decoder: jsonDecoder, completion: completion)
    }
    
    class func getPersonShows(personId: Int, completion:@escaping (AFResult<[CastResult]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        APIClient.performRequestAuth(route: PersonRouter.shows(id: personId), decoder: jsonDecoder, completion: completion)
    }
}


