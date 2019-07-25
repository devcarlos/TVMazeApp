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
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .shows, .show, .showsBy, .search:
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
//        case .search(let query):
//            return "/search/shows?q=\(query)"
        case .search:
            return "/search/shows"
        case .show(let id):
            return "/show/\(id)"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .shows, .show:
            return nil
        case .showsBy(let page):
            return ["page" : page]
        case .search(let query):
            return ["q" : query]
        }
    }
    
    private func createURL(baseURL: String, parameters: Parameters?, path: String) -> URL {
        
        var components = URLComponents(string: baseURL)!
        components.path = path
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
//        let url = createURL(baseURL: Constants.Server.baseURL, parameters: parameters, path: path)
        
        let url = try Constants.Server.baseURL.asURL().appendingPathComponent(path)
        
        print(url)
        
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
