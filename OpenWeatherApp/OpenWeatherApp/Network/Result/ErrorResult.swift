//
//  Error.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//

import Foundation

enum ErrorResult : Error {
    case network(string : String)
    case parser(string:String)
    case custom(string:String)
}
