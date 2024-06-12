//
//  WeatherData.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/27/24.
//
//  Description:
//  This file contains the necessary structs for representing and storing retrieved weather data
//  from OpenWeather API.

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

