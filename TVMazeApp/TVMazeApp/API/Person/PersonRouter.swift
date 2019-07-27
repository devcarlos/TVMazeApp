//
//  PersonRouter.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/27/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Alamofire

enum PersonRouter: APIRouter {
    
    case search(query: String)
    case shows(id: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .shows, .search:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .search:
            return "/search/people"
        case .shows(let id):
            return "/people/\(id)/castcredits"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .shows:
            return ["embed": "show"]
        case .search(let query):
            return ["q" : query]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.Server.baseURL.asURL().appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 100)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

