//
//  File.swift
//  OpenWeatherApp
//
//  Created by Faizal on 09/07/2021.
//

import CoreData
import Foundation
extension NSManagedObject {
    func saveWeatherInfo(_ weather: WeatherHomeModel) {
        setValue(weather.date, forKeyPath: "date")
        setValue(weather.descriptionWeather, forKeyPath: "descriptionWeather")
        setValue(weather.humidity, forKeyPath: "humidity")
        setValue(weather.name, forKeyPath: "name")
        setValue(weather.sunRise, forKeyPath: "sunRise")
        setValue(weather.sunSet, forKeyPath: "sunSet")
        setValue(weather.tempFeel, forKeyPath: "tempFeel")
        setValue(weather.weatherCurrent, forKeyPath: "weatherCurrent")
        setValue(weather.wind, forKeyPath: "wind")
    }

    func getWeatherInfo() -> WeatherHomeModel {
        var cityWeather = WeatherHomeModel.empty
        cityWeather.date = value(forKeyPath: "date") as? String ?? ""
        cityWeather.descriptionWeather = value(forKeyPath: "descriptionWeather") as? String ?? ""
        cityWeather.humidity = value(forKeyPath: "humidity") as? String ?? ""
        cityWeather.name = value(forKeyPath: "name") as? String ?? ""
        cityWeather.sunRise = value(forKeyPath: "sunRise") as? String ?? ""
        cityWeather.sunSet = value(forKeyPath: "sunSet") as? String ?? ""
        cityWeather.tempFeel = value(forKeyPath: "tempFeel") as? String ?? ""
        cityWeather.weatherCurrent = value(forKeyPath: "weatherCurrent") as? String ?? ""
        cityWeather.wind = value(forKeyPath: "wind") as? String ?? ""
        return cityWeather
    }

    func saveCity(_ city: City) {
        setValue(city.name, forKeyPath: "name")
        setValue(city.country ?? "", forKeyPath: "country")
        setValue(city.state ?? "", forKeyPath: "state")
    }

    func fetchCity() -> City {
        var cityObj = City()
        cityObj.name = value(forKeyPath: "name") as? String
        cityObj.country = value(forKeyPath: "country") as? String
        cityObj.state = value(forKeyPath: "state") as? String
        cityObj.isFav = true
        return cityObj
    }
}
