//
//  APIClient.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Alamofire

class APIClient {
    @discardableResult
    class func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    @discardableResult
    class func performRequestAuth<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route).authenticate(username: Constants.APIParameterKey.email, password: Constants.APIParameterKey.password).responseDecodable (decoder: decoder) { (response: DataResponse<T>) in            
            completion(response.result)
        }
    }
}

