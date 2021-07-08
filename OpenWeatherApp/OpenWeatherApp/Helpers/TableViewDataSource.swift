//
//  TableViewDataSource.swift
//  OpenWeatherApp
//
//  Created by Faizal on 09/07/2021.
//

import Foundation
import UIKit
class TableViewDataSource<Cell: UITableViewCell, ViewModel>: NSObject, UITableViewDataSource {
    private var cellIdentifier: String!
    private var items: [ViewModel]!
    var configureCell: (Cell, ViewModel, IndexPath) -> Void

    init(cellIdentifier: String, items: [ViewModel], configureCell: @escaping (Cell, ViewModel, IndexPath) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
        let item = items[indexPath.row]
        configureCell(cell, item, indexPath)
        return cell
    }
}
