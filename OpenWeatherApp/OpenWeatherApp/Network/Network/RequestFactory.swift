//
//  RequestFactory.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//


import Foundation

final class RequestFactory{
    
    enum Method : String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method : Method, url : URL) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
