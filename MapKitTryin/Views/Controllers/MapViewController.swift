//
//  MapViewController.swift
//  MapKitTryin
//
//  Created by Kamaal M Farah on 13/03/2021.
//

import UIKit
import MapKit
import CoreLocation

public final class MapViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var wantsToRequestLocation = false

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    public func requestLocation() {
        wantsToRequestLocation = true
        handleAuthorization(locationManager)
    }

    public func requestFakeLocation() {
        let location = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let viewRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        mapView.showsUserLocation = true
        mapView.setRegion(viewRegion, animated: true)
    }

    private func setupView() {
        self.view.addSubview(mapView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

}

extension MapViewController: MKMapViewDelegate { }

extension MapViewController: CLLocationManagerDelegate {
    private func handleAuthorization(_ manager: CLLocationManager) {
        guard wantsToRequestLocation else { return }
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            if let userLocation = locationManager.location?.coordinate {
                let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let viewRegion = MKCoordinateRegion(center: userLocation, span: coordinateSpan)
                mapView.setRegion(viewRegion, animated: true)
            }
        case .restricted: print("no way jose")
        case .denied: print("denied")
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        @unknown default: print("unknown")
        }
    }
}

#if DEBUG
import SwiftUI
struct HomeCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        let mapViewController = MapViewController()
        mapViewController.requestFakeLocation()
        return mapViewController.toSwiftUIView().edgesIgnoringSafeArea(.all)
    }
}
#endif
