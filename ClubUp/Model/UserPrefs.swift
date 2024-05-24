//
//  Settings.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//

import Foundation
import SwiftData


/*
 This model defines the structure and properties of global user preferences
 Currently only 1 userpref obj is kept in the swiftdata model list, will look for ways to improve this by having a singular peristent object
 */
@Model
class UserPrefs {
    
    var distanceUnit: Unit
    var speedUnit: Unit
    var tempUnit: TempUnit
    var favoritesOn: Bool
    var trackersOn: Bool
    
    init(distanceUnit: Unit = Unit.Imperial, speedUnit: Unit = Unit.Imperial, tempUnit: TempUnit = TempUnit.Fahrenheit, favoritesOn: Bool = true, trackersOn: Bool = true) {
        self.distanceUnit = distanceUnit
        self.speedUnit = speedUnit
        self.tempUnit = tempUnit
        self.favoritesOn = favoritesOn
        self.trackersOn = trackersOn
    }
    
    public static func getCurrentPrefs(prefs: [UserPrefs]) -> UserPrefs { //TODO: THis method could either be useful in other places or could be redundant and ultimately removed
        return prefs.first ?? UserPrefs()
    }
    
    public static func convertKmhToMph(speedKmh: Double) -> Double {
        return speedKmh / 1.609
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
}
