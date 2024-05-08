//
//  ClubGroupType.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/17/24.
//

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
}

enum AlertType {
    case distance
    case adjustedDistance
    case windDirection
    case lie
    case slope
    case temperature
    case airPressure
    case humidity
    case altitude
    case windSpeed
    case rain
    case custom(title: String, message: String)
    
    var title: String {
        switch self {
            case .distance: return "Distance"
            case .adjustedDistance: return "Adjusted Distance"
            case .windDirection: return "Wind Direction"
            case .lie: return "Lie"
            case .slope: return "Slope"
            case .temperature: return "Temperature"
            case .airPressure: return "Air Pressure"
            case .humidity: return "Humidity"
            case .altitude: return "Altitude"
            case .windSpeed: return "Wind Speed"
            case .rain: return "Rain"
            case .custom(let title, _): return title
        }
    }
    
    var message: String {
        switch self {
            case .distance: return "Operation completed successfully."
            case .adjustedDistance: return "An error occurred. Please try again."
            case .windDirection: return "Warning: This action may have unexpected consequences."
            case .lie: return "Operation completed successfully."
            case .slope: return "Operation completed successfully."
            case .temperature: return "Operation completed successfully."
            case .airPressure: return "Operation completed successfully."
            case .humidity: return "Operation completed successfully."
            case .altitude: return "Operation completed successfully."
            case .windSpeed: return "Operation completed successfully."
            case .rain: return "Operation completed successfully."
            case .custom(_, let message): return message
        }
    }
}


