//
//  LocationService.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import CoreLocation

final class LocationService {
    
    static let shared = LocationService()
    private let locationManager = CLLocationManager()
    
    private init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() -> (lat: Double, lon: Double)? {
        guard let coordinates = locationManager.location?.coordinate else { return nil }
        return (coordinates.latitude, coordinates.longitude)
    }
    
    
//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateLocations locations: [CLLocation]) {
//        print(manager.location?.coordinate)
//    }
    
    
}
