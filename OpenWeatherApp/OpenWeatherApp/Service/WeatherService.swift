//
//  WeatherService.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
protocol WeatherServiceProtocol : class{
    
    func fetchWeather(ofCity city : String, _ completion: @escaping ((Result<WeatherResponse, ErrorResult>) -> Void))
}

final class WeatherService : ResponseHandler, WeatherServiceProtocol{

    static let shared = WeatherService()
    var task : URLSessionTask?
    
    func fetchWeather(ofCity city : String, _ completion: @escaping ((Result<WeatherResponse, ErrorResult>) -> Void)) {
        
        let params: [String: String] = ["q": city,
                                        "units": App.unit,
                                         "APPID": App.appId]
      
        let endpoint = App.baseURL + ApiCalls.cityWeather
        task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint,params: params, completion: self.networkResponse(completion: completion))
        
    }

}
