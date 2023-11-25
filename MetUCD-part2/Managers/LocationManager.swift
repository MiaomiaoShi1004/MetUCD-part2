//
//  LocationManager.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 26/11/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    
    // indicates whether the location request is in progress
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    // after tapping the botton or after initiate the app
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        isLoading = true
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    requestPermission()
                case .authorizedWhenInUse, .authorizedAlways:
                    manager.requestLocation()
                @unknown default:
                    isLoading = false
                    // Handle unexpected authroization status, like what???
            }
        } else {
            // Location services are not enabled; inform the user, like how?
            isLoading = false
            print("Location service are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
}
