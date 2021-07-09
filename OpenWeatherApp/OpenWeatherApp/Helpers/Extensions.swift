//
//  Extensions.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
import UIKit
extension Date {
    func toStringWithDayAndTime() -> String {
        return "\(getHumanReadableDayString()), \(timeInHourFormat())"
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
            "Saturday",
        ]

        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
}

extension Double {
    func convertUnixTo24HDateString() -> String {
        let date = Date(timeIntervalSince1970: self)
        return date.timeInHourFormat()
    }

    func convertUnixToDateString() -> String {
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
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

    func round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: [String: Any]?
    )
}

// MARK: ClassNameProtocol

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

// MARK: UITableView

public extension UITableView {
    func register<T: UITableViewCell>(cellType _: T.Type, bundle: Bundle? = nil) {
        let className = String(describing: T.self)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with _: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}

// MARK: UIVIEWController

extension UIViewController {
    func showAlert(withTitle title: String = "No Internet", message: String = "Please check your internet connection to display the current weather ") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default) { _ in
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
