//
//  Extensions.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation

extension Date{
    func toStringWithDayAndTime() -> String {
        return "\(self.getHumanReadableDayString()), \(self.timeInHourFormat())"
    }
    
    func timeInHourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
}

extension Double{
    func convertUnixTo24HDateString() -> String{
        let date = Date(timeIntervalSince1970: self)
        return date.timeInHourFormat()
        
    }
    func convertUnixToDateString() -> String{
        let date = Date(timeIntervalSince1970: self)
        return date.toStringWithDayAndTime()
        
    }
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    func round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
