import Alamofire

enum APIRouter: URLRequestConvertible {
    case shows
    case showsByPage(page: Int)
    case show(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
//        case .login:
//            return .post
        case .shows, .show, .showsByPage:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
//        case .login:
//            return "/login"
        case .shows:
            return "/shows"
        case .showsByPage(let page):
            return "/shows?page=\(page)"
        case .show(let id):
            return "/show/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
//        case .login(let email, let password):
//            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .shows, .show, .showsByPage:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.Server.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

