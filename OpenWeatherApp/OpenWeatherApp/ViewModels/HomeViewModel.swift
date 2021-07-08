////
////  HomeViewModel.swift
////  OpenWeatherApp
////
////  Created by Faizal on 07/07/2021.
////

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

    init(service: WeatherServiceProtocol = WeatherService.shared) {
        self.service = service
    }

    // MARK: Api Calls

    /** Api call to get default city weather */
    func fetchWeather(ofCity name: String = "London") {
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

        return vm
    }
}
