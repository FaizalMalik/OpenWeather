//
//  HomeViewController.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import AVKit
import Foundation
import UIKit

class HomeViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var viewBGVideo: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblWeatherDesc: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblFeelLike: UILabel!
    @IBOutlet var lblWind: UILabel!
    @IBOutlet var lblHumidity: UILabel!
    @IBOutlet var lblSunrise: UILabel!
    @IBOutlet var lblSunset: UILabel!

    // MARK: Properties

    private var player: AVPlayer?
    private var playerObserver: NSObjectProtocol?
    var viewModel: HomeViewModel = {
        HomeViewModel()
    }()

    lazy var router: HomeRouter = {
        HomeRouter(viewModel: viewModel)
    }()

    enum Routes: String {
        case citySearch
        case favrouite
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewMode()
    }

    override func viewWillAppear(_: Bool) {
        playVideo()
    }

    func bindViewMode() {
        // Lisening to loading status
        viewModel.showLoadingStatus.addAndNotify(fireNow: false, observer: self) { status, _ in
            if status {
                Loader.startAnimating()
            } else {
                Loader.stopAnimating()
            }
        }

        // Lisening to weather data changes
        viewModel.weatherHomeModel.addAndNotify(fireNow: false, observer: self) { [weak self] response in
            self?.updateUI(vm: response)
        }

        viewModel.fetchWeather() // Calling the default city
    }

    // MARK: Setup Methods

    func setupView() {
        lblTitle.text = viewModel.title
        configureVideoView()
    }

    func updateUI(vm: WeatherHomeModel) {
        DispatchQueue.main.async {
            self.lblCity.text = vm.name
            self.lblWeatherDesc.text = vm.descriptionWeather
            self.lblTemp.text = vm.weatherCurrent
            self.lblDate.text = vm.date
            self.lblFeelLike.text = vm.tempFeel
            self.lblWind.text = vm.wind
            self.lblHumidity.text = vm.humidity
            self.lblSunset.text = vm.sunSet
            self.lblSunrise.text = vm.sunRise
        }
    }

    // MARK: Video methods

    private func configureVideoView() {
        guard let videoUrl = Bundle.main.url(forResource: App.backgroundVideo,
                                             withExtension: "mp4") else { return }
        player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.videoGravity = .resizeAspectFill
        viewBGVideo.layer.addSublayer(playerLayer)
        playerObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                object: player?.currentItem,
                                                                queue: .main) { [weak self] _ in
            self?.playVideo()
        }
    }

    private func playVideo(fromStart: Bool = true) {
        if fromStart {
            player?.seek(to: .zero)
        }
        player?.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Button Actionn

    @IBAction func searchAction(_: UIButton) {
        router.route(to: Routes.citySearch.rawValue, from: self, parameters: [:])
    }

    @IBAction func favAction(_: UIButton) {
        router.route(to: Routes.favrouite.rawValue, from: self, parameters: [:])
    }
}

// MARK: CitySearchViewControllerDelegate

extension HomeViewController: CitySearchViewControllerDelegate {
    func didSelectCity(city: City) {
        viewModel.fetchWeather(ofCity: city.name ?? "London")
    }
}
