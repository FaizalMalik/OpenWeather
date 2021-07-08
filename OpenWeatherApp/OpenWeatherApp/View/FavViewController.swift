//
//  FavViewController.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import UIKit

class FavViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var tableViewFav: UITableView! {
        didSet {
            tableViewFav.register(cellType: CityListTableViewCell.self)
        }
    }

    // MARK: Properties

    private var datasourceFavCityList: TableViewDataSource<CityListTableViewCell, City>!
    var viewModel: CitySearchViewModel = {
        CitySearchViewModel() // Reusing the View Model
    }()

    weak var delegate: CitySearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewMode()
    }

    func setupView() {
        tableViewFav.dataSource = nil
    }

    func bindViewMode() {
        // Lisening to cityList changes
        viewModel.favCities.addAndNotify(fireNow: false, observer: self) { [weak self] _ in
            self?.updateDataSource()
        }
        viewModel.fetchFavCityList()
    }

    // DataSource Update
    func updateDataSource() {
        datasourceFavCityList = TableViewDataSource(cellIdentifier: CityListTableViewCell.className, items: viewModel.favCities.value, configureCell: { cell, vm, _ in
            cell.city = vm
            cell.delegate = self
        })

        DispatchQueue.main.async {
            self.tableViewFav.dataSource = self.datasourceFavCityList
            self.tableViewFav.reloadData()
        }
    }

    @IBAction func closeAction(_: UIButton) {
        dismiss(animated: true) {}
    }
}

extension FavViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.favCities.value.indices.contains(indexPath.row) else {
            return
        }
        let city = viewModel.favCities.value[indexPath.row]
        delegate?.didSelectCity(city: city)
        dismiss(animated: true) {}
    }
}

extension FavViewController: CityListTableViewCellDelegate {
    func didSelectFav(city: City) {
        viewModel.saveFavCity(city: city)
        viewModel.fetchFavCityList()
    }
}
