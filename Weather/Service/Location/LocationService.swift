//
//  LocationService.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation()
}

final class LocationService: NSObject {
    
    weak var delegate: LocationServiceDelegate?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getWasAuthorizationDetermind() -> Bool {
        return locationManager.authorizationStatus != .notDetermined
    }
    
    func getLocation() -> (lat: Double, lon: Double)? {
        guard let coordinates = locationManager.location?.coordinate else { return nil }
        return (coordinates.latitude, coordinates.longitude)
    }
    
    
}

extension LocationService: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if getWasAuthorizationDetermind() {
            delegate?.didUpdateLocation()
        }
    }
    
}
