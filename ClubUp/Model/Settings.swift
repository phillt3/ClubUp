//
//  Settings.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//

import Foundation
import SwiftData

@Model
class Settings {
    
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
