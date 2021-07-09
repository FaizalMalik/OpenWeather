////
////  HomeViewModel.swift
////  OpenWeatherApp
////
////  Created by Faizal on 07/07/2021.
////

import CoreData
import Foundation

protocol HomeViewModelProtocol {
    var title: String { get }
    var weatherHomeModel: DynamicValue<WeatherHomeModel> { get }
    func fetchWeather(ofCity name: String)
}

class HomeViewModel: HomeViewModelProtocol {
    // MARK: Properties

    var weatherHomeModel = DynamicValue(WeatherHomeModel.empty)
    var service: WeatherServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool, String)>.init((false, ""))
    var title: String { return "☁️ Weather ☁️" }
    let reachability = Reachability()

    init(service: WeatherServiceProtocol = WeatherService.shared) {
        self.service = service
    }

    // MARK: Api Calls

    /** Api call to get default city weather */
    func fetchWeather(ofCity name: String = "London") {
        // When no internet connection fetch last saved city weather
        guard reachability?.isReachable ?? true else {
            fetchLastCityWeather(onCompletion: { weather in
                sceneDelegateK?.window?.rootViewController?.showAlert()
                if let cacheWeather = weather {
                    self.weatherHomeModel.value = cacheWeather
                }
            })
            return
        }

        showLoadingStatus.value = (true, "Loading.") // we can use this string if want
        service.fetchWeather(ofCity: name) { [weak self] result in
            guard let _self = self else {
                return
            }
            _self.showLoadingStatus.value = (false, "")
            switch result {
            case let .success(response):
                _self.showLoadingStatus.value = (false, "")
                _self.weatherHomeModel.value = _self.processWeatherResponse(data: response)
            case let .failure(error):
                _self.showLoadingStatus.value = (false, "\(error.localizedDescription)")
            }
        }
    }

    func processWeatherResponse(data: WeatherResponse) -> WeatherHomeModel {
        var vm = WeatherHomeModel.empty
        vm.name = data.name ?? ""
        vm.humidity = "Humidity: \(data.main.humidity) %"
        vm.descriptionWeather = data.weather?.first?.main ?? ""
        vm.wind = "Wind: \(vm.addUnit("km/h", toNumber: data.wind.speed))"
        vm.weatherCurrent = vm.addDegreeSign(toNumber: data.main.temp.round(to: 1))
        vm.sunRise = "🌤️ " + vm.convertUnixTo24HDateString(value: data.sys.sunrise)
        vm.sunSet = "🌥️ " + vm.convertUnixTo24HDateString(value: data.sys.sunset)
        vm.date = vm.convertUnixToDayAndTime(value: data.dt)
        vm.tempFeel = "Feel Like: \(vm.addDegreeSign(toNumber: data.main.feelsLike))"
        saveCityWeatehr(weather: vm)
        return vm
    }

    // Core data methods
    func saveCityWeatehr(weather: WeatherHomeModel) {
        DispatchQueue.main.async {
            let managedObjectContext = AppDelegate.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: App.weatherEntity)
            var results: [NSManagedObject] = []

            do {
                results = try managedObjectContext.fetch(fetchRequest)
                if !results.isEmpty, let weather = results.first {
                    try managedObjectContext.save()
                    managedObjectContext.delete(weather) // Removing the existing weather and update the latest
                }
                let entity = NSEntityDescription.entity(forEntityName: App.weatherEntity, in: managedObjectContext)!

                let weatherDB = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                weatherDB.saveWeatherInfo(weather)
                try managedObjectContext.save()

            } catch {
                print("error executing fetch request: \(error)")
            }
        }
    }

    func fetchLastCityWeather(onCompletion: @escaping ((WeatherHomeModel?) -> Void)) {
        DispatchQueue.main.async {
            let managedContext = AppDelegate.shared.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: App.weatherEntity)

            do {
                let cityWeatherSaved = try managedContext.fetch(fetchRequest)

                if let weatherDB = cityWeatherSaved.first {
                    let cityWeather = weatherDB.getWeatherInfo()
                    onCompletion(cityWeather)
                }
                onCompletion(nil)

            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                onCompletion(nil)
            }
            onCompletion(nil)
        }
    }
}
