//
//  CityListTableViewCell.swift
//  OpenWeatherApp
//
//  Created by Faizal on 08/07/2021.
//

import UIKit

protocol CityListTableViewCellDelegate: AnyObject {
    func didSelectFav(city: City)
}

class CityListTableViewCell: UITableViewCell {
    // MARK: Outlets

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var btnFav: UIButton!

    // MARK: Properties

    var city: City? {
        didSet {
            DispatchQueue.main.async {
                self.lblName.text = self.city?.name
                self.lblCountryName.text = self.setupCountryName()
                self.setupFavButton()
            }
        }
    }

    weak var delegate: CityListTableViewCellDelegate?

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

    func setupFavButton() {
        btnFav.isSelected = city?.isFav ?? false
        btnFav.tintColor = city?.isFav ?? false ? UIColor.red : UIColor.lightGray
    }

    @IBAction func actionFav(_: Any) {
        if var city = self.city {
            self.city?.isFav = !(city.isFav ?? false)
            city.isFav = self.city?.isFav
            setupFavButton()
            delegate?.didSelectFav(city: city)
        }
    }
}
