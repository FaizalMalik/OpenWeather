//
//  CitySearchViewModel.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import Foundation

protocol CitySearchViewModelProtocol {
    func fetchCityList(query: String)
}

class CitySearchViewModel: CitySearchViewModelProtocol {
    // MARK: Properties

    var cityList = DynamicValue([City]())
    var service: WeatherServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool, String)>.init((true, ""))
    var isApiCalling = false

    init(service: WeatherServiceProtocol = WeatherService.shared) {
        self.service = service
    }

    // MARK: Api Calls

    /** Api call to get city List */
    func fetchCityList(query: String) {
        guard !isApiCalling else {
            return
        }
        isApiCalling = true
        showLoadingStatus.value = (true, "Loading.") // we can use this string if want
        service.fetchCityList(query: query) { result in
            self.isApiCalling = false
            switch result {
            case let .success(response):
                self.showLoadingStatus.value = (false, "")
                self.cityList.value = response

            case let .failure(error):
                self.showLoadingStatus.value = (false, "\(error.localizedDescription)")
            }
        }
    }
}
