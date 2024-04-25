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
    var favoritesOn: Bool
    var trackersOn: Bool
    
    init(distanceUnit: Unit = Unit.Imperial, speedUnit: Unit = Unit.Imperial, favoritesOn: Bool = true, trackersOn: Bool = true) {
        self.distanceUnit = distanceUnit
        self.speedUnit = speedUnit
        self.favoritesOn = favoritesOn
        self.trackersOn = trackersOn
    }
}
