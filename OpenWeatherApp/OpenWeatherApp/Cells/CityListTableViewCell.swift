//
//  CityListTableViewCell.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import UIKit

class CityListTableViewCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCountryName: UILabel!

    // MARK: Properties

    var city: City? {
        didSet {
            DispatchQueue.main.async {
                self.lblName.text = self.city?.name
                self.lblCountryName.text = self.setupCountryName()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCountryName() -> String {
        if let state = city?.state, !state.isEmpty, let country = city?.country {
            return state + " ," + country
        }
        return city?.country ?? ""
    }
}
