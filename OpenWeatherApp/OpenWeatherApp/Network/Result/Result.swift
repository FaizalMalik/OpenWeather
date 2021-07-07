//
//  Result.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//  Copyright © 2018 Faizal. All rights reserved.
//

import Foundation

enum Result<T, E : Error>{
    case success(T)
    case failure(E)
}
