//
//  DistanceCalcViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//

import SwiftUI
import SwiftData
// ViewModel or Model to handle the calculation logic
extension DistanceCalcView{
    @Observable
    class DistanceCalcViewModel: ObservableObject {
         public var yardage: String = ""
         public var adjYardage: String = ""
         public var windSpeed: Double = 0
         public var windDirection: String = "multiply.circle"
         public var slope = ""
         public var isRaining: Bool = false
         public var lie: String = ""
         public var showingResult = false
         public var showingAlert = false
         public var alertType: AlertType = .distance
        
        var modelContext: ModelContext
        var clubs = [Club]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
        
        let arrowImages = ["multiply.circle","arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
        let selectionOptions = ["Tee", "Fairway","Rough","Bunker", "Deep Rough"]
        let slopes = ["Flat","Down","Up"]
        
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<Club>(sortBy: [SortDescriptor(\.distanceYards)])
                clubs = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }
        
        public func calculateTrueDistance() -> Int {
            return 120
        }
        
        public func getRecommendedClub(distance: Int) -> Club? {
            
            //will need to convert distanve to yardage if it is meters
            
            guard !clubs.isEmpty else { return nil }
                
            var low = 0
            var high = clubs.count - 1
            // Binary search
            while low <= high {
                
                let mid = low + (high - low) / 2
                let currentClubDistance = clubs[mid].distanceYards ?? 0
                
                // Check if value is present at mid
                if currentClubDistance == distance {
                    return clubs[mid]
                }
                
                // Update closest if the current element is closer to the value
                if abs(currentClubDistance - distance) < abs(currentClubDistance - distance) {
                    low = mid
                }
                
                // Move search range accordingly
                if currentClubDistance < distance {
                    low = mid + 1
                } else {
                    high = mid - 1
                }
            }
            return clubs[low]
        }
    }
}

