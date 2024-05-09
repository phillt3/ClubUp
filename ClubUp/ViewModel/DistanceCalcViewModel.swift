//
//  DistanceCalcViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//

import SwiftUI

// ViewModel or Model to handle the calculation logic
class DistanceCalcViewModel: ObservableObject {
    @Published public var yardage: String = ""
    @Published public var adjYardage: String = ""
    @Published public var windSpeed: Double = 0
    @Published public var windDirection: String = "multiply.circle"
    @Published public var slope = ""
    @Published public var isRaining: Bool = false
    @Published public var lie: String = ""
    @Published public var showingResult = false
    @Published public var showingAlert = false
    @Published public var alertType: AlertType = .distance
    
    let arrowImages = ["multiply.circle","arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
    let selectionOptions = ["Tee", "Fairway","Rough","Bunker", "Deep Rough"]
    let slopes = ["Flat","Down","Up"]
}
