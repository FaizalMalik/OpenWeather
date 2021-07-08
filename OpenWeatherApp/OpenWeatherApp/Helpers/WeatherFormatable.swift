//
//  WeatherFormatable.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
import Foundation

protocol WeatherFormatable {
    func convertUnixToDayAndTime(value:Double) ->  String
    func convertUnixTo24HDateString(value:Double) ->  String
    func addUnit(_ unitName: String, toNumber: Float) -> String
    func addDegreeSign(toNumber: Double)-> String
    
}

extension WeatherFormatable {
    func convertUnixToDayAndTime(value:Double) -> String {
        return value.convertUnixToDateString()
    }
    func convertUnixTo24HDateString(value:Double) -> String {
        return value.convertUnixTo24HDateString()
    }
    func addUnit<T>(_ unitName: String, toNumber: T) -> String {
        return "\(toNumber) \(unitName)"
    }
    
    func addDegreeSign<T>(toNumber: T)-> String {
        return "\(toNumber)°C"
    }
    
}
