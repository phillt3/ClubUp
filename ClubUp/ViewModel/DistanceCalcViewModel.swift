//
//  DistanceCalcViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//
//  Description:
//  This file contains the implementation of a viewmodel to support the data collection and
//  calculation of the DistanceCalcView.

import SwiftUI
import SwiftData
import CoreLocation

extension DistanceCalcView{
    @Observable
    class DistanceCalcViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        //UI Flags and Properties
        public var showingResult = false
        public var showingAlert = false
        public var alertType: AlertType = .distance
        public var isLoading: Bool = false
        
        //Data Properties
        var modelContext: ModelContext
        var clubs = [Club]()
        public var prefs: UserPrefs = UserPrefs()
        public var calcData: Calculation
        
        /// Initialize the view model and calculation model data object
        /// - Parameter modelContext: ModelContext to get access to swiftdata objects
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            calcData = Calculation(modelContext: modelContext)
        }
        
        /// Perform data fetch and binding reset
        public func prepareViewModelForView() {
            self.fetchData()
            self.calcData.fetchData()
            self.calcData.reset()
        }
        
        /// Fetch relevant swiftdata objects
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
        
        /// Calculate adjusted distance for current wind conditions. Rule is to add 1% distance to shot for every 1 mph the wind is hurting offset by direction or  add 0.5% distance for every 1mph the wind is helping offset by direction
        /// - Parameters:
        ///   - distance: the current distance
        ///   - windSpeedMph: the wind speed in mph
        /// - Returns: returns new distance adjusted for wind
        private func getDistanceWithWind(distance: Int, windSpeedMph: Double)  -> Int {
            let windDirectionPercentage = calcData.getWindDirectionPercentage()
            var newDistance: Double = Double(distance)
            
            if (windDirectionPercentage > 0) {
                newDistance = newDistance + (windDirectionPercentage * ((windSpeedMph / 100.0) * newDistance))
                return Int(newDistance)
            } else if (windDirectionPercentage < 0) {
                newDistance = newDistance + (windDirectionPercentage * (((windSpeedMph / 2) / 100.0) * newDistance))
                return Int(newDistance)
            } else {
                return distance
            }
        }
        
        /// Calculate adjusted distance for current altitude. Rule is that distance increases 1% for every 300 meters above sea leve
        /// - Parameters:
        ///   - distance: current distance
        ///   - altitudeMeters: altitude value in meters
        /// - Returns: returns new distance adjusted for altitude
        private func getDistanceWithAltitude(distance: Int, altitudeMeters: Int) -> Int {
            let increasePercentage = Double(altitudeMeters) / 300.0
            var newDistance = Double(distance)
            newDistance = newDistance - (newDistance * (increasePercentage / 100.0))
            return Int(newDistance)
        }
        
        /// Calculate adjusted distance for rain. Rule is the target will play 4% farther if raining.
        /// - Parameter distance: current distance
        /// - Returns: returns new distance adjusted for rain
        private func getDistanceWithRain(distance: Int) -> Int {
            var newDistance = Double(distance)
            newDistance = newDistance + (newDistance * 0.04)
            return Int(newDistance)
        }
        
        /// Calculate adjusted distance for temperature. Rule is 2 yards will be added or subtracted for every 10° above or below 75°F (will play shorter if warmer and vice versa)
        /// - Parameters:
        ///   - distance: current distance
        ///   - tempF: temperature in fahrenheit
        /// - Returns: returns new distance adjusted for temperature
        private func getDistanceWithTemperature(distance: Int, tempF: Int) -> Int {
            let tempFromBase = tempF - 75
            let tempVar = Double(tempFromBase) / 10.0
            var newDistance = Double(distance)
            newDistance = newDistance + (-2.0 * tempVar)
            return Int(newDistance)
        }
        
        /// Performs order operations to account for all current environmental variables that will impact how far the target is palying
        /// - Returns: return the adjusted distance for current environmental variables
        public func calculateTrueDistance() -> Int {
            var distance = calcData.initialDistance
            let altitude = prefs.distanceUnit == .Imperial ? HelperMethods.convertFeetToMeters(distanceFeet: Double(calcData.altitude) ?? 0.0) : Int(calcData.altitude) ?? 0
            let temp =  prefs.tempUnit == TempUnit.Fahrenheit ? Int(calcData.temperature) ?? 75 : HelperMethods.convertCToF(tempC: Int(calcData.temperature) ?? 24)
            let windSpeed = prefs.speedUnit == .Imperial ? calcData.windSpeed : HelperMethods.convertKmhToMph(speedKmh: calcData.windSpeed)
            
            distance = getDistanceWithWind(distance: distance, windSpeedMph: windSpeed)
            distance = getDistanceWithAltitude(distance: distance, altitudeMeters: altitude)
            distance = getDistanceWithTemperature(distance: distance, tempF: temp)
            
            if (calcData.isRaining) {
                distance = getDistanceWithRain(distance: distance)
            }
            
            return distance
        }
        
        ///  Lie is better accounted for in the club decision, the rule is to club up or down to varying amounts depending on given lie
        /// - Parameter index: The position of the currently decided club in the clubs list
        /// - Returns: returns the new club adjusted for lie
        private func accountForLie(index: Int) -> Club? {
            var newIndex = index + calcData.getSlopeLieFactor()
            
            if (calcData.lie == "Deep Rough") {
                while newIndex > 0 {
                    if (clubs[newIndex].rank >= 29) {
                        return clubs[newIndex]
                    } else {
                        newIndex -= 1
                    }
                }
                return clubs[newIndex] //return the highest lofted club
            }
            
            if (newIndex < 0) {
                return clubs.first
            } else if (newIndex > clubs.endIndex) {
                return clubs.last
            } else {
                return clubs[newIndex]
            }
        }
        
        /// This function utilizes a modified binary search algorithm (also account for lie and weighing in favorited clubs) to efficiently and accurately pickout the club with the assigned distance most helpful to the player with the adjusted distance
        /// - Parameter distance: distance with environmental variables accounted for
        /// - Returns: returns the recommend club to play
        public func getRecommendedClub(distance: Int) -> Club? {
            
            var resultDist = distance
            
            if (prefs.distanceUnit == .Metric) {
                resultDist = HelperMethods.metersToYards(meters: resultDist)
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
                        if (prefs.favoritesOn && abs(resultDist - clubs[mid].distanceYards!) == abs(resultDist - clubs[mid - 1].distanceYards!)) {
                            if (clubs[mid].favorite) {
                                return accountForLie(index: mid)
                            } else if (clubs[mid - 1].favorite) {
                                return accountForLie(index: mid - 1)
                            }
                        }
                        let foundIndex = abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid - 1].distanceYards!) ? mid : mid - 1
                        return accountForLie(index: foundIndex)
                    }
                    high = mid
                } else {
                    if (mid < clubs.count - 1 && resultDist < clubs[mid + 1].distanceYards!) {
                        if (prefs.favoritesOn &&  abs(resultDist - clubs[mid].distanceYards!) == abs(resultDist - clubs[mid + 1].distanceYards!)) {
                            if (clubs[mid].favorite) {
                                return accountForLie(index: mid)
                            } else if (clubs[mid + 1].favorite) {
                                return accountForLie(index: mid + 1)
                            }
                        }
                        let foundIndex = abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid + 1].distanceYards!) ? mid : mid + 1
                        return accountForLie(index: foundIndex)
                    }
                    low = mid
                }
            }
            return accountForLie(index: mid)
        }
    }
}

