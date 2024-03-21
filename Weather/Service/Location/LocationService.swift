//
//  LocationService.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        
    }
}
