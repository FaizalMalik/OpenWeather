//
//  ParserHelper.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//


import Foundation

final class ParserHelper {
    
    static func parse<T:Codable>(data: Data, completion : (Result<T, ErrorResult>) -> Void) {
        let decoder = JSONDecoder()
        if let response = try? decoder.decode(T.self, from: data) {
            completion(.success(response))
        }else{
            completion(.failure(.parser(string: "Error while parsing json data")))

        }

    }
}
