//
//  WeatherService.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
protocol WeatherServiceProtocol: AnyObject {
    func fetchWeather(ofCity city: String, _ completion: @escaping ((Result<WeatherResponse, ErrorResult>) -> Void))
    func fetchCityList(query: String, _ completion: @escaping ((Result<[City], ErrorResult>) -> Void))
}

final class WeatherService: ResponseHandler, WeatherServiceProtocol {
    static let shared = WeatherService()
    var task: URLSessionTask?

    func fetchWeather(ofCity city: String, _ completion: @escaping ((Result<WeatherResponse, ErrorResult>) -> Void)) {
        let params: [String: String] = ["q": city,
                                        "units": App.unit,
                                        "APPID": App.appId]

        let endpoint = App.baseURL + ApiCalls.cityWeather
        task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint, params: params, completion: networkResponse(completion: completion))
    }

    func fetchCityList(query: String, _ completion: @escaping ((Result<[City], ErrorResult>) -> Void)) {
        let params: [String: String] = ["q": query,
                                        "limit": "5",
                                        "APPID": App.appId]

        let endpoint = App.baseURL + ApiCalls.cityList
        task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint, params: params, completion: networkResponse(completion: completion))
    }
}
