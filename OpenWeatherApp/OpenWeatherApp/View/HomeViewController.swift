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
    //MARK: Outlets
    @IBOutlet weak var viewBGVideo: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFeelLike: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    
    //MARK: Properties
    private var player: AVPlayer?
    private var playerObserver: NSObjectProtocol?
    var viewModel:HomeViewModel = {
        return HomeViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
         bindViewMode()
    }
    override func viewWillAppear(_ animated: Bool) {
        playVideo()
    }
    
    func bindViewMode(){
        
        viewModel.showLoadingStatus.addAndNotify(fireNow: false, observer: self) { (status,message) in
            if status{
                Loader.startAnimating()
            }else{
                Loader.stopAnimating()
            }
        }
        viewModel.weatherHomeModel.addAndNotify(fireNow: false, observer: self) {[weak self] (response) in
            self?.updateUI(vm: response)
        }
        
        viewModel.fetchWeather()
    }
    //MARK: Setup Methods
    
    func setupView(){
        
     lblTitle.text = viewModel.title
     configureVideoView()
        
    }
    func updateUI(vm:WeatherHomeModel){
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
    //MARK: Video methods
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
}
