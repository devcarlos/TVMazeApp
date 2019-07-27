//
//  ShowRouter.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/25/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Alamofire

 enum ShowRouter: APIRouter {

    case shows
    case show(id: Int)
    case showsBy(page: Int)
    case search(query: String)
    case episodes(id: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .shows, .show, .showsBy, .search, .episodes:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .shows:
            return "/shows"
        case .showsBy:
            return "/shows"
        case .search:
            return "/search/shows"
        case .show(let id):
            return "/show/\(id)"
        case .episodes(let id):
            return "/shows/\(id)/episodes"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .shows, .show, .episodes:
            return nil
        case .showsBy(let page):
            return ["page" : page]
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
//                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
