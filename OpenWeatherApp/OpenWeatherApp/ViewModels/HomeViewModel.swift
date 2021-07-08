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
    func fetchWeather(ofCity name:String)
}

class HomeViewModel: HomeViewModelProtocol{
    //MARK: Properties
    var weatherHomeModel = DynamicValue.init(WeatherHomeModel.empty)
    var service :WeatherServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool,String)>.init((false,""))
    var title: String { return "☁️ Weather ☁️" }
    
    init(service:WeatherServiceProtocol = WeatherService.shared) {
        self.service = service
    }

    //MARK: Api Calls
    /**Api call to get default city weather */
    func fetchWeather(ofCity name:String = "London"){ 
        showLoadingStatus.value = (true,"Loading.")
        
        service.fetchWeather(ofCity: name) { [weak self](result) in
            guard let _self = self else {
                return
            }
            _self.showLoadingStatus.value = (false,"")
            switch result{
            case .success(let response):
                _self.showLoadingStatus.value = (false,"")
                _self.weatherHomeModel.value = _self.processWeatherResponse(data: response)
                break
            case .failure(let error):
                _self.showLoadingStatus.value = (false,"\(error.localizedDescription)")
                break
            }
        }

    }

    func processWeatherResponse(data:WeatherResponse) -> WeatherHomeModel{
        
        var vm = WeatherHomeModel.empty
        vm.name = data.name ?? ""
        vm.humidity = "Humidity: \(data.main.humidity) %"
        vm.descriptionWeather = data.weather?.first?.descriptionField ?? ""
        vm.wind = "Wind: \(vm.addUnit("km/h", toNumber: data.wind.speed))"
        vm.weatherCurrent = vm.addDegreeSign(toNumber: data.main.temp )
        vm.sunRise = "🌤️ " + vm.convertUnixTo24HDateString(value: data.sys.sunrise)
        vm.sunSet = "🌥️ " + vm.convertUnixTo24HDateString(value: data.sys.sunset)
        vm.date = vm.convertUnixToDayAndTime(value: data.dt)
        vm.tempFeel = "Feel Like: \(vm.addDegreeSign(toNumber: data.main.feelsLike))"
        
        return vm
    }

}

