//
//	WeatheResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
//MARK: WeatheResponse
struct WeatheResponse : Codable {

	let base : String?
	let clouds : Cloud?
	let cod : Int?
	let coord : Coord?
	let dt : Int?
	let id : Int?
	let main : Main?
	let name : String?
	let sys : Sy?
	let timezone : Int?
	let visibility : Int?
	let weather : [Weather]?
	let wind : Wind?

}

//MARK: Coord
struct Coord : Codable {
    let lat : Float?
    let lon : Float?
}

//MARK: Cloud
struct Cloud : Codable {
    let all : Int?
}

//MARK: Sy
struct Sy : Codable {
    let country : String?
    let id : Int?
    let message : Float?
    let sunrise : Int?
    let sunset : Int?
    let type : Int?
}
//MARK: Wind
struct Wind : Codable {
    let deg : Int?
    let speed : Float?
}
