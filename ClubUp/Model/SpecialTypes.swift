//
//  ClubGroupType.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/17/24.
//
//  Description:
//  This file contains the implementation of a variety of custom data types that
//  are used throughout the application.

import Foundation

enum ClubType: Codable {
    case wood
    case iron
    case hybrid
    case wedge
}

enum Unit: String, CaseIterable, Codable {
    case Imperial = "Imperial (Yards, Miles)"
    case Metric = "Metric (Meters, Kilometers)"
    
    var title: String {
        switch self {
            case .Imperial: return String(format: NSLocalizedString("imperial", comment: ""))
            case .Metric: return String(format: NSLocalizedString("metric", comment: ""))
        }
    }
}
enum TempUnit: String, CaseIterable, Codable {
    case Fahrenheit = "°F (Fahrenheit)"
    case Celsius = "°C (Celsius)"
    
    var title: String {
        switch self {
            case .Fahrenheit: return String(format: NSLocalizedString("fahrenheit", comment: ""))
            case .Celsius: return String(format: NSLocalizedString("celsius", comment: ""))
        }
    }
}

/// Allow user to learn more about each variable impacting distance, presenting this info through alerts
enum AlertType {
    case distance
    case adjustedDistance
    case windDirection
    case lie
    case slope
    case temperature
    case altitude
    case windSpeed
    case rain
    case custom(title: String, message: String)
    
    var title: String {
        switch self {
            case .distance: return String(format: NSLocalizedString("distance", comment: ""))
            case .adjustedDistance: return String(format: NSLocalizedString("adj_distance", comment: ""))
            case .windDirection: return String(format: NSLocalizedString("Wind Direction", comment: ""))
            case .lie: return String(format: NSLocalizedString("Lie", comment: ""))
            case .slope: return String(format: NSLocalizedString("Slope", comment: ""))
            case .temperature: return String(format: NSLocalizedString("Temperature", comment: ""))
            case .altitude: return String(format: NSLocalizedString("Altitude", comment: ""))
            case .windSpeed: return String(format: NSLocalizedString("Wind Speed", comment: ""))
            case .rain: return String(format: NSLocalizedString("Rain", comment: ""))
            case .custom(let title, _): return title
        }
    }
    
    var message: String {
        switch self {
        case .distance: return String(format: NSLocalizedString("distance_alert", comment: ""))
            case .adjustedDistance: return String(format: NSLocalizedString("adj_distance_alert", comment: ""))
            case .windDirection: return String(format: NSLocalizedString("wind_direction_alert", comment: ""))
            case .lie: return String(format: NSLocalizedString("lie_alert", comment: ""))
            case .slope: return String(format: NSLocalizedString("slope_alert", comment: ""))
            case .temperature: return String(format: NSLocalizedString("temperature_alert", comment: ""))
            case .altitude: return String(format: NSLocalizedString("altitude_alert", comment: ""))
            case .windSpeed: return String(format: NSLocalizedString("wind_speed_alert", comment: ""))
            case .rain: return String(format: NSLocalizedString("rain_alert", comment: ""))
            case .custom(_, let message): return message
        }
    }
}


