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
        public var slope: String = "Flat"
        public var temperature: String = ""
        public var humidity: String = ""
        public var airPressure: String = ""
        public var altitude: String = ""
        public var isRaining: Bool = false
        public var lie: String = "Tee"
        public var showingResult = false
        public var showingAlert = false
        public var alertType: AlertType = .distance
        
        var modelContext: ModelContext
        var clubs = [Club]()
        public var prefs: UserPrefs = UserPrefs() //TODO: How we set prefs here is how we should do it in other viewmodels probably
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        let arrowImages = ["multiply.circle","arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
        let selectionOptions = ["Tee", "Fairway","Rough","Bunker", "Deep Rough"]
        let slopes = ["Flat","Down","Up"]
        
        func reset() {
            yardage = ""
            adjYardage = ""
            windSpeed = 0
            windDirection = "multiply.circle"
            slope = "Flat"
            temperature = ""
            humidity = ""
            airPressure = ""
            altitude = ""
            isRaining = false
            lie = "Tee"
        }
        
        public func fetchData() {
            do {
                let descriptor = FetchDescriptor<Club>(sortBy: [SortDescriptor(\.distanceYards)])
                clubs = try modelContext.fetch(descriptor)
            } catch {
                print("Club Fetch failed")
            }
            
            do {
                let descriptor = FetchDescriptor<UserPrefs>()
                let fetchedPrefs = try modelContext.fetch(descriptor)
                if (fetchedPrefs.first != nil) {
                    prefs = fetchedPrefs.first!
                }
            } catch {
                print("Prefs Fetch failed")
            }
        }
        
        public func calculateTrueDistance() -> Int {
            return Int(yardage) ?? 0
        }
        
        public func getRecommendedClub(distance: Int) -> Club? {
            
            var resultDist = distance
            
            if (prefs.distanceUnit == .Metric) {
                resultDist = Club.metersToYards(meters: resultDist)
            }
            
            guard !clubs.isEmpty else { return nil }
            
            if (resultDist <= (clubs.first?.distanceYards)!) {
                return clubs.first
            } else if (resultDist >= (clubs.last?.distanceYards)!){
                return clubs.last
            }
            
            var low = 0
            var mid = 0
            var high = clubs.count - 1
            
            while(low < high) {
                mid = (low + high) / 2
                
                if (clubs[mid].distanceYards! == resultDist) {
                    return clubs[mid]
                }
                
                if (resultDist < clubs[mid].distanceYards!) {
                    if (mid > 0 && resultDist > clubs[mid - 1].distanceYards!) {
                        return abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid - 1].distanceYards!) ? clubs[mid] : clubs[mid - 1]
                    }
                    high = mid
                } else {
                    if (mid < clubs.count - 1 && resultDist < clubs[mid + 1].distanceYards!) {
                        return abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid + 1].distanceYards!) ? clubs[mid] : clubs[mid + 1]
                    }
                    low = mid
                }
            }
            return clubs[mid]
            
        }
    }
}

