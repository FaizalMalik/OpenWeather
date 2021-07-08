//
//  HomeRouter.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import Foundation
import UIKit
class HomeRouter: Router {
    unowned var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    func route(to routeID: String, from context: UIViewController, parameters _: [String: Any]?) {
        DispatchQueue.main.async {
            switch routeID {
            case HomeViewController.Routes.citySearch.rawValue:
                if let citySearchVC = context.storyboard?.instantiateViewController(withIdentifier: CitySearchViewController.className) as? CitySearchViewController {
                    citySearchVC.delegate = context as? CitySearchViewControllerDelegate
                    context.present(citySearchVC, animated: true) {}
                }

            default:
                break
            }
        }
    }
}
