//
//  App.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
// Here we will define the constants of app
struct App {
    static let appId = "504f2c7a9dfb496a1c2042d2fc1a46ca"
    static let baseURL = "https://api.openweathermap.org/"
    static let unit = "metric"
    static let backgroundVideo = "sky"
    static let cityEntity = "CityDB"
    static let weatherEntity = "WeatherDB"
}

enum ApiCalls {
    static let cityWeather = "data/2.5/weather"
    static let cityList = "geo/1.0/direct"
}
