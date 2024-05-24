//
//  DistanceCalcViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//

import SwiftUI
import SwiftData
import CoreLocation
// ViewModel or Model to handle the calculation logic
extension DistanceCalcView{
    @Observable
    class DistanceCalcViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        var locationManager = CLLocationManager()
        
        //TODO: Might be better to transfer these to a model
        public var yardage: String = ""
        public var adjYardage: String = ""
        public var windSpeed: Double = 0 //got
        public var windDirection: String = "multiply.circle" //got
        public var slope: String = "Flat" //got but will actually be used in club algorithm
        public var temperature: String = "" //GOT
        public var humidity: String = "" //got - ngeligible
        public var airPressure: String = "" //might be begligble
        public var altitude: String = "" //got
        public var isRaining: Bool = false //got
        public var lie: String = "Tee" //got a working theory but also would be used in club algorithm
        public var showingResult = false
        public var showingAlert = false
        public var alertType: AlertType = .distance
        public var isLoading: Bool = false
        
        var yardageValue: Int? { Int(yardage) }
        var adjYardageValue: Int? { Int(adjYardage) }
        var tempValue: Int? { Int(temperature) }
        var humidityValue: Int? { Int(humidity) }
        var airPressValue: Double? { Double(airPressure) }
        var altitudeValue: Int? { Int(altitude) }
        
        var modelContext: ModelContext
        var clubs = [Club]()
        public var prefs: UserPrefs = UserPrefs() //TODO: How we set prefs here is how we should do it in other viewmodels probably
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            
            super.init()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
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
        
        private func getDistanceWithWind(distance: Int, windSpeedMph: Double)  -> Int {
            let windDirectionPercentage = getWindDirectionPercentage()
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
        
        private func getDistanceWithAltitude(distance: Int, altitudeMeters: Int) -> Int {
            let increasePercentage = Double(altitudeMeters) / 300.0
            var newDistance = Double(distance)
            newDistance = newDistance - (newDistance * (increasePercentage / 100.0))
            return Int(newDistance)
        }
        
        private func getDistanceWithRain(distance: Int) -> Int {
            var newDistance = Double(distance)
            newDistance = newDistance + (newDistance * 0.04)
            return Int(newDistance)
        }
        
        private func getWindDirectionPercentage() -> Double {
            let currentDirection = windDirection
            
            switch currentDirection {
            case "multiply.circle", "arrow.right", "arrow.left":
                return 0
            case "arrow.up":
                return -1
            case "arrow.down":
                return 1
            case "arrow.up.right", "arrow.up.left":
                return -0.5
            case "arrow.down.right", "arrow.down.left":
                return 0.5
            default:
                return 0
            }
        }
        
        private func getDistanceWithTemperature(distance: Int, tempF: Int) -> Int {
            let tempFromBase = tempF - 75
            let tempVar = Double(tempFromBase) / 10.0
            var newDistance = Double(distance)
            newDistance = newDistance + (-2.0 * tempVar)
            return Int(newDistance)
        }
        
        public func calculateTrueDistance() -> Int {
            var calcDistance = Int(adjYardage) ?? Int(yardage) ?? 0
            let calcAltitude = Int(altitude) ?? 0
            let calcTemp = Int(temperature) ?? 75
            
            calcDistance = getDistanceWithWind(distance: calcDistance, windSpeedMph: prefs.speedUnit == .Imperial ? windSpeed : UserPrefs.convertKmhToMph(speedKmh: windSpeed))
            calcDistance = getDistanceWithAltitude(distance: calcDistance, altitudeMeters: prefs.distanceUnit == .Imperial ? UserPrefs.convertFeetToMeters(distanceFeet: Double(calcAltitude)) : calcAltitude)
            calcDistance = getDistanceWithTemperature(distance: calcDistance, tempF: prefs.tempUnit == TempUnit.Fahrenheit ? calcTemp : UserPrefs.convertCToF(tempC: calcTemp))
            
            if (isRaining) {
                calcDistance = getDistanceWithRain(distance: calcDistance)
            }
            
            return calcDistance
        }
        
        private func accountForLie(index: Int) -> Club? {
            var newIndex = index
            
            if (slope == "Down") {
                newIndex -= 1
            } else if (slope == "Up") {
                newIndex += 1
            }
            
            if (lie == "Rough" || lie == "Bunker") {
                newIndex += 1
            } else if (lie == "Deep Rough") {
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
        
        public func fillInData() {
            locationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            
            altitude = String(Int(location.altitude.magnitude)) //TODO: Need to figure out converting this and all values when changing preferences, maybe even just reset the page more often
            
            DispatchQueue.global().async {
                // Simulate some network or data fetching delay
                sleep(2)
                self.isLoading = false
            }
            //isLoading = false
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error: \(error.localizedDescription)")
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
                
                //I think the way to implement favorites is if the yardages are equedistant, choose the favorite, otherwise random?
                if (resultDist < clubs[mid].distanceYards!) {
                    if (mid > 0 && resultDist > clubs[mid - 1].distanceYards!) {
                        if (prefs.favoritesOn && abs(resultDist - clubs[mid].distanceYards!) == abs(resultDist - clubs[mid - 1].distanceYards!)) {
                            if (clubs[mid].favorite) {
                                return accountForLie(index: mid)
                            } else if (clubs[mid - 1].favorite) {
                                return accountForLie(index: mid - 1)
                            }
                        }
                        let foundIndex = abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid - 1].distanceYards!) ? mid : mid - 1 //abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid - 1].distanceYards!) ? clubs[mid] : clubs[mid - 1]
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
                        let foundIndex = abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid + 1].distanceYards!) ? mid : mid + 1 //abs(resultDist - clubs[mid].distanceYards!) <= abs(resultDist - clubs[mid + 1].distanceYards!) ? clubs[mid] : clubs[mid + 1]
                        return accountForLie(index: foundIndex)
                    }
                    low = mid
                }
            }
            return accountForLie(index: mid)
        }
    }
}

