//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct City: Codable {
    var country: String?
    var name: String?
    var state: String?
    var isFav: Bool? = false
    init() {}
}

extension City {
    var isSelected: City {
        var _self = self
        _self.isFav = true
        return _self
    }
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return (lhs.name == rhs.name) && (lhs.country == rhs.country)
    }
}
