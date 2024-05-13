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
            return Int(yardage) ?? 0
        }
        
        public func getRecommendedClub(distance: Int) -> Club? {
            
            //TODO: will need to convert distanve to yardage if it is meters
            
            guard !clubs.isEmpty else { return nil }
            
            if (distance <= (clubs.first?.distanceYards)!) {
                return clubs.first
            } else if (distance >= (clubs.last?.distanceYards)!){
                return clubs.last
            }
                
            var low = 0
            var mid = 0
            var high = clubs.count - 1
            
            // Binary search
            while low < high {
                
                mid = low + (high - low) / 2
                
                if clubs[mid].distanceYards! == distance {
                    return clubs[mid]
                }
                
                if distance < clubs[mid].distanceYards! {
                    high = mid
                    low += (abs(distance - clubs[high].distanceYards!) < abs(distance - clubs[low].distanceYards!)) ? 1 : 0
                } else {
                    low = mid
                    high -= (abs(distance - clubs[low].distanceYards!) < abs(distance - clubs[high].distanceYards!)) ? 1 : 0
                }

            }
            
            return clubs[low] //TODO: May have to reinclude difference check between low index and mid index but it algorithm should work as is
            
        }
    }
}

