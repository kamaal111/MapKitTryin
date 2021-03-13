//
//  MainViewController.swift
//  MapKitTryin
//
//  Created by Kamaal M Farah on 13/03/2021.
//

import UIKit

final class MainViewController: UIViewController {

    lazy var mapViewController: MapViewController = {
        let viewController = MapViewController()
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        mapViewController.requestLocation()
    }

    private func setupView() {
        self.add(mapViewController)
    }

}
