//
//  WeatherData.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/27/24.
//

import Foundation
import CoreLocation

struct WeatherData {
    let altitude: Int
    let temperature: Double
    let condition: String
    let windSpeed: Double
    let windGust: Double
}

struct WeatherResponse: Codable {
    let main: MainWeather
    let wind: Wind
    let weather: [Weather]
}

struct MainWeather: Codable {
    let temp: Double
    let sea_level: Int
    
}

struct Wind: Codable {
    let speed: Double
    let gust: Double
}

struct Weather: Codable {
    let main: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
