//
//  Loader.swift
//  OpenWeatherApp
//
//  Created by Faizal on 07/07/2021.
//

import Foundation
import UIKit
import Lottie

let sceneDelegateK = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

class Loader: NSObject {
    static var animationView = AnimationView()
    static func startAnimating(view: UIView? = nil) {
        DispatchQueue.main.async {
            if let activity = sceneDelegateK?.window?.viewWithTag(1876) as? UIActivityIndicatorView {
                activity.startAnimating()
            } else {

                animationView.stop()
                animationView.removeFromSuperview()
                animationView = AnimationView(name: "LoaderAnimation")
                animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
                animationView.center = topMostViewController().view.center
                animationView.loopMode = .loop
                animationView.play()

                if view != nil {
                    view?.addSubview(animationView)
                    view?.isUserInteractionEnabled = false
                } else {
                    topMostViewController().view.addSubview(animationView)
                    topMostViewController().view.bringSubviewToFront(animationView)
                    topMostViewController().view.isUserInteractionEnabled = false
                }
            }
        }
    }


    static func stopAnimating(view: UIView? = nil) {
        DispatchQueue.main.async {
            animationView.stop()
            animationView.removeFromSuperview()
            topMostViewController().view.isUserInteractionEnabled = true
            if view != nil {
                view?.isUserInteractionEnabled = true
            }
        }
    }

    static func topMostViewController() -> UIViewController {
        var topController = sceneDelegateK?.window?.rootViewController
        while (topController?.presentedViewController) != nil {
            topController = topController?.presentedViewController
        }
        return topController!
    }
}
