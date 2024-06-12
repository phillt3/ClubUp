//
//  Calculation.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 6/2/24.
//
//  Description:
//  This file contains the implementation of a model used to represent the data organized for
//  distance calculation and club recommendation.

import Foundation
import CoreLocation
import SwiftData

@Observable
class Calculation: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //Properties to Track Selections
    let arrowImages = ["multiply.circle","arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
    let selectionOptions = ["Tee", "Fairway","Rough","Bunker", "Deep Rough"]
    let slopes = ["Flat","Down","Up"]
    
    // Data Properties
    var modelContext: ModelContext
    var locationManager = CLLocationManager()
    public var prefs: UserPrefs = UserPrefs()
    
    // Properites
    public var yardage: String = ""
    public var adjYardage: String = ""
    public var windSpeed: Double = 0 //got
    public var windDirection: String = "multiply.circle"
    public var lie: String = "Tee"
    public var slope: String = "Flat"
    public var temperature: String = ""
    public var altitude: String = ""
    public var isRaining: Bool = false
    public var showingResult = false
    public var showingAlert = false
    public var alertType: AlertType = .distance
    public var isLoading: Bool = false
    
    override var description: String {
        return "Calculation:\nyardage=\(yardage)\nadjYardage=\(adjYardage)\nwindSpeed=\(windSpeed)\nwindDirection=\(windDirection)\nlie=\(lie)\nslope=\(slope)\ntemp=\(temperature)\naltitude=\(altitude)\nisRaining=\(isRaining)"
    }
    
    /// Initialize Model with model context to have access to swiftdata structures
    /// - Parameter modelContext: model context for application
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Fetch relevant swiftdata objects
    public func fetchData() {
        do {
            let descriptor = FetchDescriptor<UserPrefs>()
            let fetchedPrefs = try modelContext.fetch(descriptor)
            if (fetchedPrefs.first != nil) {
                prefs = fetchedPrefs.first!
            }
        } catch {
            print("Prefs Fetch failed")
        }
    }
    
    /// Ensure the distance retrieved is not null
    public var initialDistance: Int {
        Int(adjYardage) ?? Int(yardage) ?? 0
    }
    
    /// Clear  model data
    func reset() {
        yardage = ""
        adjYardage = ""
        windSpeed = 0
        windDirection = "multiply.circle"
        slope = "Flat"
        temperature = ""
        altitude = ""
        isRaining = false
        lie = "Tee"
    }
    
    
    /// Return numeric representation to use as factor offset for wind direction
    /// - Returns: Double representing percentage the wind direction will offset the wind speed
    func getWindDirectionPercentage() -> Double {
        switch windDirection {
        case "multiply.circle", "arrow.right", "arrow.left":
            return 0
        case "arrow.up":
            return -1
        case "arrow.down":
            return 1
        case "arrow.up.right", "arrow.up.left":
            return -0.5
        case "arrow.down.right", "arrow.down.left":
            return 0.5
        default:
            return 0
        }
    }
    
    //TODO: THIS does not accout for if the user has gaps in their clubs, need to bring rank in on this
    /// Determine number of club positions to move based on lie
    /// - Returns: Index positions to move
    func getSlopeLieFactor() -> Int {
        var factor = 0
        
        if slope == "Down" {
            factor -= 1
        } else if slope == "Up" {
            factor += 1
        }
        
        if (lie == "Rough" || lie == "Bunker") {
            factor += 1
        }
        
        return factor
    }
    
    /// Initiate location retrieval
    public func fillInData() {
        locationManager.requestLocation()
    }
    
    /// Perform operations to handle location retrieval
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        guard let url = constructWeatherAPIURL(apiKey: Config.apiKey, location: location) else { return }

        fetchWeatherData(from: url)
    }
    
    /// Create the API call
    /// - Parameters:
    /// - Returns: Returns URL for API call
    private func constructWeatherAPIURL(apiKey: String, location: CLLocation) -> URL? {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        let lat = !HelperMethods.isRunningOnSimulator ? String(location.coordinate.latitude) : "40.392"
        let lon = !HelperMethods.isRunningOnSimulator ? String(location.coordinate.longitude) : "74.118"
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        return components?.url
    }
    
    /// Perform OpenWeather API Call
    /// - Parameter url: URL Containing API Call
    private func fetchWeatherData(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from weather API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: weatherResponse)
                }
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    /// Update UI with values retrieved from OpenWeather
    /// - Parameter weatherResponse: Struct to represent retrieved weather data
    private func updateUI(with weatherResponse: WeatherResponse) {
        let weatherData = WeatherData(
            altitude: weatherResponse.main.sea_level,
            temperature: weatherResponse.main.temp,
            condition: weatherResponse.weather.first?.main ?? "",
            windSpeed: weatherResponse.wind.speed,
            windGust: weatherResponse.wind.gust
        )
        
        self.altitude = self.prefs.distanceUnit == .Imperial ? String(weatherData.altitude) : String(HelperMethods.convertFeetToMeters(distanceFeet: Double(weatherData.altitude)))
        
        self.temperature = self.prefs.tempUnit == .Fahrenheit ? String(weatherData.temperature) : String(HelperMethods.convertFToC(tempF: Int(weatherData.temperature)))
        
        self.windSpeed = self.prefs.speedUnit == .Imperial ? weatherData.windSpeed : HelperMethods.convertMphToKmh(speedMph: weatherData.windSpeed)
        
        self.isRaining = weatherData.condition == "Rain"
        self.isLoading = false
    }

    //TODO: Handle this error user side
    /// Handle Unsuccessful Retrieval
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
