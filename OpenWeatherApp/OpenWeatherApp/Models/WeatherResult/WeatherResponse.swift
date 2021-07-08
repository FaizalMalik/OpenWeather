//
//	WeatherResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
//MARK: WeatheResponse
struct WeatherResponse : Codable {

	let cod : Int?
	let dt : Double
	let id : Int?
	let main : Main
	let name : String?
	let sys : Sy
	let timezone : Int?
	let visibility : Int?
	let weather : [Weather]?
	let wind : Wind

}
//MARK: Sy
struct Sy : Codable {
    let country : String?
    let id : Int?
    let message : Float?
    let sunrise : Double
    let sunset : Double
    let type : Int?
}
//MARK: Wind
struct Wind : Codable {
    let deg : Int?
    let speed : Float
}

//MARK: WeatherHomeModel
struct WeatherHomeModel:WeatherFormatable {
    var name:String
    var descriptionWeather:String
    var weatherCurrent:String
    var date:String
    var wind:String
    var humidity:String
    var tempFeel:String
    var sunRise:String
    var sunSet:String
}

extension WeatherHomeModel {
    static var empty: WeatherHomeModel {
        return WeatherHomeModel(name: "", descriptionWeather: "", weatherCurrent: "", date: "", wind: "", humidity: "", tempFeel: "", sunRise: "", sunSet: "")
    }
}
