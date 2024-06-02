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
enum TempUnit: String, CaseIterable, Codable {
    case Fahrenheit = "°F (Fahrenheit)"
    case Celsius = "°C (Celsius)"
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
            case .distance: return "This represents the direct measurement of length between you and the target. Use a rangefinder or look for signs and fairway indicators to determine this value."
            case .adjustedDistance: return "This represents the adjusted measurement for length between you and the target by accounting for height (either above or below your current position). Use a rangefinder to determine this value."
            case .windDirection: return "This represents from which direction the wind is blowing. Depending on the angle, wind direction can help or hurt a golf ball's distance to varying degrees. Throw a little bit of grass into the air and note the direction it moves or check nearby flags (such as the hole's flagstick) to determine this value relative to your position."
            case .lie: return "This represents the condition of the ground you are currently hitting off of. There is complexity and randomness to the effect of a golf ball's distance depending on lie, but typically the more pristine a lie, the more true and farther a ball will likely travel."
            case .slope: return "Slope can be understood differently based on the scenario, in this case, it is the representation of whether or not you are hitting on an upward angle, or downward angle. Hitting on an upward angle can promote the ball to fly higher and land shorter, the opposite is true for a downward angle."
            case .temperature: return "This represents the degree of temperature for current playing conditions. There are many factors as to why temperature effects carry distance such as with air density, air resistance, ball elasticity, firm or soft ground, etc. Colder weather promotes shorter carry distances and vice versa."
            case .airPressure: return "Negligible."
            case .humidity: return "Negligible."
            case .altitude: return "This represents the current distance you are above sea level. Altitude effects the carry distance of a golf ball through change in air density and even (on a minimal scale) gravity. The higher the altitude, the thinner the air and thus less drag force on a ball, letting it fly farther."
            case .windSpeed: return "This represents to what degree the wind will effect the ball. High wind speeds will more dramatically push the ball."
            case .rain: return "If it is currently raining, raindrops will disrupt airflow during a ball's flight, increasing drag, causing some downward momentum, leading to the ball flying shorter distances."
            case .custom(_, let message): return message
        }
    }
}


