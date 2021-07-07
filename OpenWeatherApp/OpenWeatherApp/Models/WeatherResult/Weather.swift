//
//	Weather.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Weather : Codable {

	let descriptionField : String?
	let icon : String?
	let id : Int?
	let main : String?

	enum CodingKeys: String, CodingKey {
		case descriptionField = "description"
		case icon
		case id
		case main 
	}
}
