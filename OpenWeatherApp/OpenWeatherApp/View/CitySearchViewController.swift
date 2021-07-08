//
//  CitySearchViewController.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import UIKit
protocol CitySearchViewControllerDelegate: AnyObject {
    func didSelectCity(city: City)
}

class CitySearchViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableViewCityList: UITableView! {
        didSet {
            tableViewCityList.register(cellType: CityListTableViewCell.self)
        }
    }

    // MARK: Properties

    var viewModel: CitySearchViewModel = {
        CitySearchViewModel()
    }()

    weak var delegate: CitySearchViewControllerDelegate?
    private var datasourceCityList: TableViewDataSource<CityListTableViewCell, City>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewMode()
    }

    // MARK: Setup Methods

    func setupView() {
        searchBar.placeholder = "Search city"
        searchBar.becomeFirstResponder()
        tableViewCityList.dataSource = nil
    }

    func bindViewMode() {
        // Lisening to loading status
        viewModel.showLoadingStatus.addAndNotify(fireNow: true, observer: self) { [weak self] status, _ in
            if status {
                Loader.startAnimating(view: self?.tableViewCityList)
            } else {
                Loader.stopAnimating(view: self?.tableViewCityList)
            }
        }

        // Lisening to cityList changes
        viewModel.cityList.addAndNotify(fireNow: false, observer: self) { [weak self] _ in
            self?.updateDataSource()
        }
        viewModel.fetchFavCityList()
    }

    // DataSource Update
    func updateDataSource() {
        datasourceCityList = TableViewDataSource(cellIdentifier: CityListTableViewCell.className, items: viewModel.cityList.value, configureCell: { cell, vm, _ in

            cell.city = vm
            cell.delegate = self
        })

        DispatchQueue.main.async {
            self.tableViewCityList.dataSource = self.datasourceCityList
            self.tableViewCityList.reloadData()
        }
    }

    // MARK: - Button Actions

    @IBAction func actionClose(_: Any) {
        dismiss(animated: true) {}
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 3 else {
            return
        }

        viewModel.fetchCityList(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchCityList(query: searchBar.text ?? "")
    }
}

extension CitySearchViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.cityList.value.indices.contains(indexPath.row) else {
            return
        }
        let city = viewModel.cityList.value[indexPath.row]
        delegate?.didSelectCity(city: city)
        dismiss(animated: true) {}
    }
}

extension CitySearchViewController: CityListTableViewCellDelegate {
    func didSelectFav(city: City) {
        viewModel.saveFavCity(city: city)
    }
}
