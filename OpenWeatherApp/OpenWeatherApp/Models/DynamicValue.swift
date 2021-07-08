//
//  DynamicValue.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation

class DynamicValue<T> {

    typealias CompletionHandler = ((T) -> Void)

    var value: T {
        didSet {
            self.notify()
        }
    }

    private var observers = [String: CompletionHandler]()

    init(_ value: T) {
        self.value = value
    }

    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        let description = observer.description
        observers[description] = completionHandler
       
    }

    public func addAndNotify(fireNow:Bool = true, observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        if fireNow {
             self.notify()
        }
       
    }
    public func remove(_ observer: NSObject) {
        
       observers.removeAll()
       }
    private func notify() {
        observers.forEach({ $0.value(value) })
    }

    deinit {
        observers.removeAll()
    }
}
