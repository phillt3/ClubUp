//
//  Settings.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//
//  Description:
//  This file contains the implementation of a model that defines the
//  structure and properties of global user preferences.

import Foundation
import SwiftData

@Model
class UserPrefs {
    
    var distanceUnit: Unit //what unit of measurement is used to represent distance
    var speedUnit: Unit //what unit of measurement is used to represent speed
    var tempUnit: TempUnit //what unit of measurement is used to represent temperature
    var favoritesOn: Bool //enable favoriting clubs and have those clubs weighed heaving in the selection algorithm
    var trackersOn: Bool //enable shot tracking to present what percent of the time the club choice results in a good shot
    var quickAddClubsOn: Bool //enable ui componently to quickly add recommened clubs without manually entering recommended clubs
    
    init(distanceUnit: Unit = Unit.Imperial, speedUnit: Unit = Unit.Imperial, tempUnit: TempUnit = TempUnit.Fahrenheit, favoritesOn: Bool = true, trackersOn: Bool = true, quickAddClubsOn: Bool = true) {
        self.distanceUnit = distanceUnit
        self.speedUnit = speedUnit
        self.tempUnit = tempUnit
        self.favoritesOn = favoritesOn
        self.trackersOn = trackersOn
        self.quickAddClubsOn = quickAddClubsOn
    }
    
    /*
     Because of the nature of swift data objects being stored in a queryable list and not as a singluar persistent object, this method makes checking and retreiving the singlue UserPref data easier.
     */
    public static func getCurrentPrefs(prefs: [UserPrefs]) -> UserPrefs {
        return prefs.first ?? UserPrefs() //if there is not swift data object for settings, then it has not been edited yet, so provide default settings
    }
}
