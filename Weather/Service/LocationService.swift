//
//  LocationService.swift
//  Weather
//
//  Created by Кирилл Зубков on 21.03.2024.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    
    // MARK: - Delegate
    
    func didUpdateLocation()
    
}

final class LocationService: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: LocationServiceDelegate?
    
    private let locationManager = CLLocationManager()
    
    
    // MARK: - Init
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    
    // MARK: - Interface
    
    func getWasAuthorizationDetermind() -> Bool {
        return locationManager.authorizationStatus != .notDetermined
    }
    
    func getLocation() -> CLLocation? {
        return locationManager.location
    }
    
    func getLocationName(location: CLLocation,
                         completion: @escaping (Result<String, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                completion(.failure(error))
            } else if let locality = placemarks?.first?.locality {
                completion(.success(locality))
            } else {
                completion(.failure(NSError(domain: "Ошибка расшифровки локации", code: 0)))
            }
        }
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
