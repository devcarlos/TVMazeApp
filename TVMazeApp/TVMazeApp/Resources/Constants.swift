//
//  Constants.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/24/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Server {
        static let baseURL = "http://api.tvmaze.com"
        static let showsURL = "/shows?page=1"
    }
    
    struct APIParameterKey {
        static let password = "0H5GYwWXsRmjhg4BORwPi9kjxXf9647G"
        static let email = "carlos.alcala@me.com"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

