//
//	Main.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Main : Codable {

	let feelsLike : Double
	let humidity : Int
	let pressure : Int?
	let temp : Double
	let tempMax : Double?
	let tempMin : Double?

	enum CodingKeys: String, CodingKey {
		case feelsLike = "feels_like"
		case humidity
		case pressure
		case temp
		case tempMax = "temp_max"
		case tempMin = "temp_min"
	}

}
