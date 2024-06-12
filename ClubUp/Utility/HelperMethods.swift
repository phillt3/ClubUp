//
//  HelperMethods.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/31/24.
//
//  Description:
//  This file contains the implementation of various helper methods used throughout
//  the application, primarily for unit conversion purposes.

import Foundation

class HelperMethods {
    public static func convertKmhToMph(speedKmh: Double) -> Double {
        return speedKmh / 1.609
    }

    public static func convertMphToKmh(speedMph: Double) -> Double {
        return speedMph * 1.609
    }

    public static func convertFeetToMeters(distanceFeet: Double) -> Int {
        return Int(distanceFeet / 3.281)
    }

    public static func convertMetersToFeet(distanceMeters: Double) -> Int {
        return Int(distanceMeters * 3.281)
    }

    public static func convertCToF(tempC: Int) -> Int {
        return Int((Double(tempC) * (9/5)) + 32)
    }

    public static func convertFToC(tempF: Int) -> Int {
        return Int((Double(tempF - 32) * (5/9)))
    }
    
    public static func yardsToMeters(yards: Int) -> Int {
        return Int(round(Double(yards) * 0.9144))
    }
    
    public static func metersToYards(meters: Int) -> Int {
        return Int(round(Double(meters) / 0.9144))
    }
    
    /// In specific cases it is necessary to fill in test data when working with the simulator
    public static var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
