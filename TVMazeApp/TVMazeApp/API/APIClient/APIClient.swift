
import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                
                print("----------RESULT---------")
                print(response.result)
                
                completion(response.result)
        }
    }
    
    private static func performRequestAuth<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route).authenticate(username: Constants.APIParameterKey.email, password: Constants.APIParameterKey.password).responseDecodable (decoder: decoder) { (response: DataResponse<T>) in
            
            print("----------RESULT---------")
            print(response.result)

            completion(response.result)
        }
    }
    
//    static func login(email: String, password: String, completion:@escaping (AFResult<User>)->Void) {
//        performRequest(route: APIRouter.login(email: email, password: password), completion: completion)
//    }
    
    static func getShows(completion:@escaping (AFResult<[Show]>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.showsDateFormatter)
        _ = performRequestAuth(route: APIRouter.shows, decoder: jsonDecoder, completion: completion)
    }
}

