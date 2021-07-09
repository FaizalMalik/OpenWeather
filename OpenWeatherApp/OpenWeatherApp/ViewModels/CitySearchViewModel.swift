//
//  CitySearchViewModel.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import CoreData
import Foundation

class CitySearchViewModel: CitySearchViewModelProtocol {
    // MARK: Properties

    var cityList = DynamicValue([City]())
    var service: WeatherServiceProtocol
    var showLoadingStatus = DynamicValue<(Bool, String)>.init((true, ""))
    var isApiCalling = false
    var favCities = DynamicValue([City]())

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
                let mappedCities = response.map { self.favCities.value.contains($0) ? $0.isSelected : $0 }
                self.cityList.value = mappedCities

            case let .failure(error):
                self.showLoadingStatus.value = (false, "\(error.localizedDescription)")
            }
        }
    }

    /* ? Core Data Methods */
    func fetchFavCityList() {
        DispatchQueue.main.async {
            let managedContext = AppDelegate.shared.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: App.cityEntity)

            do {
                let cityListSaved = try managedContext.fetch(fetchRequest)
                var cityList = [City]()
                for cityDB in cityListSaved {
                    cityList.append(cityDB.fetchCity())
                }
                self.favCities.value = cityList
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                self.favCities.value = []
            }
        }
    }

    func saveFavCity(city: City) {
        DispatchQueue.main.async {
            guard !self.cityExist(city: city) else {
                return
            }
            let managedContext = AppDelegate.shared.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: App.cityEntity, in: managedContext)!
            let cityDB = NSManagedObject(entity: entity, insertInto: managedContext)
            cityDB.saveCity(city)

            do {
                try managedContext.save()

            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func cityExist(city: City) -> Bool {
        let managedObjectContext = AppDelegate.shared.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: App.cityEntity)
        fetchRequest.predicate = NSPredicate(format: "name = %@", city.name ?? "")

        var results: [NSManagedObject] = []

        do {
            results = try managedObjectContext.fetch(fetchRequest)
            if !results.isEmpty, let cityDB = results.first, city.isFav == false {
                managedObjectContext.delete(cityDB)
                try managedObjectContext.save()
                return true
            }
        } catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0
    }
}

protocol CitySearchViewModelProtocol {
    func fetchCityList(query: String)
    func fetchFavCityList()
    func saveFavCity(city: City)
}
